{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    kernelModules = [
      "sg" # Required by MakeMKV
    ];

    kernelPackages = pkgs.linuxPackages_zen;
  };

  environment.systemPackages = (with pkgs; [
    esptool
    makemkv
    prusa-slicer
  ]);

  hardware = {
    nvidia = {
      modesetting.enable = true;

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        persistencedSha256 = lib.fakeSha256;
        settingsSha256 = "sha256-fPfIPwpIijoUpNlAUt9C8EeXR5In633qnlelL+btGbU=";
        sha256_64bit = "sha256-gBkoJ0dTzM52JwmOoHjMNwcN2uBN46oIRZHAX8cDVpc=";
        version = "550.120"; # https://www.nvidia.com/en-us/drivers/unix/
      };
    };

    printers = {
      ensureDefaultPrinter = "Brother_HL-L8260CDW";

      ensurePrinters = [
        {
          description = "Brother HL-L8260CDW";
          deviceUri = "ipp://192.168.144.11/ipp";
          location = "Study";
          model = "everywhere";
          name = "Brother_HL-L8260CDW";
        }
      ];
    };
  };

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/kwinoutputconfig.json".text = ''
        [
            {
                "data": [
                    {
                        "autoRotation": "InTabletMode",
                        "connectorName": "DP-1",
                        "edidHash": "6b85735fd37b4c0b998eb5e9ed61e9de",
                        "edidIdentifier": "DEL 41444 809782867 16 2022 0",
                        "highDynamicRange": false,
                        "iccProfilePath": "",
                        "mode": {
                            "height": 1440,
                            "refreshRate": 119991,
                            "width": 3440
                        },
                        "overscan": 0,
                        "rgbRange": "Automatic",
                        "scale": 1.1,
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
                                    "x": 0,
                                    "y": 0
                                },
                                "priority": 0
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
  };

  imports = [
    ../desktops/kde.nix
  ];

  nixpkgs.config.nvidia.acceptLicense = true;

  services = {
    fstrim.enable = true;

    usbguard = {
      enable = true;

      rules = ''
        # usbguard generate-policy

        allow hash "7BEPoG79cQnq0lFimyewt6Nn57hWEbWlGFzvJ5ssOZ0="        # Bluetooth Adapter
        allow hash "VlQdu2UoDZmeF2eKvWpLnf7IsRdYcFDaZT5dgBAX7+s="        # Creative Speaker
        allow hash "tePaOBipPkv0w+43m89QSxmpyxK4O+5c2TCkEzUT+2k="        # Corsair PSU
        allow hash "VVbAZs/7huTs9wzYc9hAE3ybG+F3hAo7pa56Pr20qyc="        # Fingerprint Reader
        allow hash "OlAZ0WVYEJAB4aD4crBc2XT3YD9Y35l69FhAnUkd4+Y="        # Garmin Watch
        allow hash "Q26mMR4yTWM+GsoqXRtY81foWerxuan04933WMq7VSQ="        # Keychron Keyboard
        allow hash "yXobwMW1Gw0jxMPJdKyLWbxVAsqSFFtSaKn792aP87c="        # Logitech Camera
        allow hash "y0nMBYvoXYCGsR9c/YuFAQLlt1a63qgUaXo232qnT8Y="        # Logitech Receiver
        allow hash "Gz21LLBKSOMz+9Lwg4mme7QnY5ob+uKuj+8/7CaaGrI="        # PlayStation VR2
        allow hash "iVf76Dc8asgE8m9aq9BFMhFgdkpnYuUToXPnt4Vf79Q="        # SanDisk Extreme Pro
        allow hash "rxeggb91UNgLtQU9ej+HZmyML69KropjTtXR3mbqSgE="        # SanDisk Extreme Pro
        allow hash "lzq9AGwU6Lp53U7fCfuh5Y+lII1P+xK/BnUp5hLweyc="        # SteelSeries Headphones
        allow hash "XBoEcj4BKpuQ+RwurNQvKfASfgwB5oGwhkWQTBozaOY="        # Thrustmaster Stick
        allow hash "ikayKI4/D/gOJKOvd1Ho/bfGuSVIWGi/9vtJxBgDrwk="        # Thrustmaster Throttle

        allow hash "Ghx8Z1hiW875rcDmwb6oAhtqT4Kf0XiUnQgANRLi6PI="        # Alienware Corporation Hub

        allow hash "6wd5RDNGVTlBi8cwUnlJhf6wQxVMw4lPppgOfi2ZFwk="        # Genesys Logic Hub
        allow hash "7L+4JQysVQmKqmuJW+7Tfm5pktL6b7OjAZ0NjvT92xQ="        # Genesys Logic Hub

        allow hash "EqDsL5iBogtOuZitOQzOr8UAQW5HOJLvkRn8ux26o6A="        # Huasheng Electronics Hub

        allow hash "+0s5mKAEDBjZasKfFR9ExKfjpMr/J4C4yq4bgYdLJSM="        # Host Controller
        allow hash "kfg9rWbHDmu9sziJKn54hYXgOUymiXkU/EU39jdg/GA="        # Host Controller
        allow hash "mwoNTKm3aF0jTqIhDGlVsUwfcb+vy+uyPfiVL/Uxir8="        # Host Controller
        allow hash "nyjiuLoRZPIYxANlVmwcZIYZhmLEJXOfZnW9G6v4oFo="        # Host Controller
        allow hash "OOTFv0DuAPoWzkjfh1FRhwu95L3mbMj68cvWj70EeKY="        # Host Controller
        allow hash "YCmLXGZH8v4LO2zcs6hgNQ6/M9R24O7dO1glO/IWMo4="        # Host Controller

        allow hash "PvoqVe8QP1gB0wnZ482YC92QbP8ztHOHqrhNzcS2F3g="        # Microchip Technology Hub
        allow hash "V6W0USsOPQ9oncxHMVacxXal7RlHZxp6RTCnG4Z8mvg="        # Microchip Technology Hub

        allow hash "AGUYEKgZCSjWnBQRgECiKsBFduiNgQO6eIKZQaynmmY="        # PNY Card Reader
        allow parent-hash "AGUYEKgZCSjWnBQRgECiKsBFduiNgQO6eIKZQaynmmY=" # PNY Card Reader (Devices)
      '';
    };

    xserver.videoDrivers = [
      "nvidia"
    ];
  };
}
