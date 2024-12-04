{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd.kernelModules = [
      "amdgpu" # Required by 'console.earlySetup'
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = (with pkgs; [
    amdgpu_top
  ]);

  hardware.printers = {
    ensureDefaultPrinter = "Ricoh_MP_C4504";

    ensurePrinters = [
      {
        description = "Ricoh MP C4504";
        deviceUri = "ipp://172.16.30.245/ipp/print";
        location = "3rd Floor";
        model = "everywhere";
        name = "Ricoh_MP_C4504";
      }
      {
        description = "HP OfficeJet Pro 9020";
        deviceUri = "ipp://172.16.30.246/ipp/print";
        location = "3rd Floor";
        model = "everywhere";
        name = "HP_OfficeJet_Pro_9020";
      }
    ];
  };

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/kwinoutputconfig.json".text = ''
        [
            {
                "data": [
                    {
                        "autoRotation": "InTabletMode",
                        "brightness": 1,
                        "colorProfileSource": "sRGB",
                        "connectorName": "DP-3",
                        "edidHash": "36a5b22547ca51a99fb14dc5faf74dce",
                        "edidIdentifier": "IVM 26200 5130 53 2021 0",
                        "highDynamicRange": false,
                        "iccProfilePath": "",
                        "mode": {
                            "height": 1440,
                            "refreshRate": 74924,
                            "width": 2560
                        },
                        "mstPath": "-8\u0000",
                        "overscan": 0,
                        "rgbRange": "Automatic",
                        "scale": 1.25,
                        "sdrBrightness": 200,
                        "sdrGamutWideness": 0,
                        "transform": "Normal",
                        "vrrPolicy": "Automatic",
                        "wideColorGamut": false
                    },
                    {
                        "autoRotation": "InTabletMode",
                        "brightness": 1,
                        "colorProfileSource": "sRGB",
                        "connectorName": "DP-4",
                        "edidHash": "f6ed787deea3f334083f92dc9b410b3a",
                        "edidIdentifier": "IVM 26200 1325 4 2022 0",
                        "highDynamicRange": false,
                        "iccProfilePath": "",
                        "mode": {
                            "height": 1440,
                            "refreshRate": 74924,
                            "width": 2560
                        },
                        "mstPath": "-1\u0000",
                        "overscan": 0,
                        "rgbRange": "Automatic",
                        "scale": 1.25,
                        "sdrBrightness": 200,
                        "sdrGamutWideness": 0,
                        "transform": "Normal",
                        "vrrPolicy": "Automatic",
                        "wideColorGamut": false
                    }
                ],
                "name": "outputs"
            },
            {
                "data": [
                    {
                        "lidClosed": false,
                        "outputs": [
                            {
                                "enabled": true,
                                "outputIndex": 0,
                                "position": {
                                    "x": 2048,
                                    "y": 0
                                },
                                "priority": 0
                            },
                            {
                                "enabled": true,
                                "outputIndex": 1,
                                "position": {
                                    "x": 0,
                                    "y": 0
                                },
                                "priority": 1
                            }
                        ]
                    }
                ],
                "name": "setups"
            }
        ]
      '';

      ".config/wireplumber/wireplumber.conf.d/disable-devices.conf".text = ''
        monitor.alsa.rules = [
          {
            actions = {
              update-props = {
                device.disabled = true
              }
            }
            matches = [
              {
                device.name = "~alsa_card.pci-*"
              }
            ]
          }
        ]
      '';
    };

    programs.plasma.powerdevil.AC = {
      autoSuspend.action = "nothing";
      powerButtonAction = "nothing";
    };

    programs.zed-editor.userSettings.assistant.default_model.model = "llama3.2:latest";
  };

  imports = [
    ../desktops/kde.nix
  ];

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "tailscale-performance" ''
        if [ "''${DEVICE_IFACE}" == "enp2s0" ] && [ "''${2}" == "up" ]
        then
          ${pkgs.ethtool.out}/bin/ethtool --features ''${DEVICE_IFACE} rx-gro-list off rx-udp-gro-forwarding on
          logger "Tailscale performance features enabled for ''${DEVICE_IFACE}"
        fi
      '';

      type = "basic";
    }
  ];

  # nixpkgs.config.rocmSupport = true;

  services = {
    fstrim.enable = true;

    ollama.loadModels = [
      "llama3.2:latest"
    ];

    usbguard = {
      enable = true;

      rules = ''
        # usbguard generate-policy

        allow hash "M7TWJmUTUZr/fVMQQYY6QXU/FQ3pCBfSFnVupc2X0iA=" # Intel Bluetooth
        allow hash "P1PFVlVCFRHNkvxuC9Jh5Ae+wofyPgXtgyTPpej9YrY=" # Keychron Keyboard
        allow hash "EhX4Eu+u69SQBRB41ITnKdTEt2jQjpsTHNbRfU35+QM=" # Logitech Receiver
        allow hash "FrzXT/qv1CFLgGIGczUmfT818wGFhXJF6IUv3IT0/DM=" # Realtek Billboard
        allow hash "U2ggp+1IbZXbviK5ZSbahLv8DZjdvkvzDWVkW2sx1JM=" # SanDisk Extreme Pro
        allow hash "3AWS7hVImBt+rc1P8uxiuF85l84jowWHyCJQAFUc4tM=" # Sennheiser Headphones
        allow hash "TUonI3xjdnKzqUJ6Yfo05B2ujl8v5tX5qiRWRXaiIyA=" # Sennheiser Headphones (Hub)
        allow hash "vTQDxYra1S117L9vQ5ccQRR6oQs4kBp2oXcZtvDcCSM=" # Yubico Yubikey

        allow hash "5uYwceHbvuBGAzUuLBS+ZQi9HzXT0tA6gPM3aE6l+PU=" # Genesys Logic Hub

        allow hash "6N1TzJjHwwpfxs1tKPqEW87V2i+tHyyRUvFlgF5cGtw=" # Linux Root Hub
        allow hash "hUMPrpUUWjXN6LOshdE/S/HI1Kx/9TvIRabxmN272oA=" # Linux Root Hub
        allow hash "SQO9g2Bt21p8dKkNmw9lqWKzphaGisG3dmz0QWJVjzc=" # Linux Root Hub
        allow hash "vtM3uheObXFIOQNcFII3a6Jan4oRRxULqAzx+5d2q/E=" # Linux Root Hub

        allow hash "o1hrvXH26zcx3A/3vCcb25O/iq6y7ENNuEQdMdpSjXs=" # Realtek Hub
        allow hash "UhBNsUR5mbPiw1u5jm0bAjcGEyiOEkTkf4ksy6qqDk8=" # Realtek Hub
      '';
    };
  };
}
