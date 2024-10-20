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

  environment = {
    etc."monitors.xml" = {
      mode = "0444";

      text = ''
        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>DP-4</connector>
                  <vendor>IVM</vendor>
                  <product>PL2792QN</product>
                  <serial>1179220401325</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>74.924</rate>
                </mode>
              </monitor>
            </logicalmonitor>
            <logicalmonitor>
              <x>2560</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-3</connector>
                  <vendor>IVM</vendor>
                  <product>PL2792QN</product>
                  <serial>1179215305130</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>74.924</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      '';
    };

    systemPackages = (with pkgs; [
      amdgpu_top
      rocmPackages.clr
    ]);
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    printers = {
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
  };

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/monitors.xml".source = config.lib.file.mkOutOfStoreSymlink "/etc/monitors.xml";

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
  };

  imports = [
    ../desktops/gnome.nix
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

  services = {
    fstrim.enable = true;

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

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
