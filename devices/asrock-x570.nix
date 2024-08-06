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

    kernelModules = [
      "sg" # Required by MakeMKV
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
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-3</connector>
                  <vendor>DEL</vendor>
                  <product>Dell AW3423DW</product>
                  <serial>#GjMYMxgwABcQ</serial>
                </monitorspec>
                <mode>
                  <width>3440</width>
                  <height>1440</height>
                  <rate>119.991</rate>
                  <ratemode>variable</ratemode>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      '';
    };

    systemPackages = (with pkgs; [
      amdgpu_top
      esptool
      makemkv
      prusa-slicer
      rocmPackages.clr
    ]);
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    printers = {
      ensureDefaultPrinter = "Brother_HL-L8260CDW";

      ensurePrinters = [
        {
          description = "Brother HL-L8260CDW";
          deviceUri = "ipp://192.168.144.10/ipp";
          location = "Study";
          model = "everywhere";
          name = "Brother_HL-L8260CDW";
        }
      ];
    };
  };

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/monitors.xml".source = config.lib.file.mkOutOfStoreSymlink "/etc/monitors.xml";

      ".config/wireplumber/main.lua.d/disable-devices.lua".text = ''
        disable_devices = {
          apply_properties = {
            ["device.disabled"] = true
          },
          matches = {
            {
              {"device.name", "equals", "alsa_card.pci-0000_0b_00.1"}
            },
            {
              {"device.name", "equals", "alsa_card.pci-0000_0d_00.4"}
            }
          }
        }

        table.insert(alsa_monitor.rules, disable_devices)
      '';
    };
  };

  services = {
    fstrim.enable = true;
    # ollama.acceleration = "rocm";
    usbguard.enable = true;

    usbguard.rules = ''
      # usbguard generate-policy

      allow hash "VlQdu2UoDZmeF2eKvWpLnf7IsRdYcFDaZT5dgBAX7+s="        # Creative Speaker
      allow hash "tePaOBipPkv0w+43m89QSxmpyxK4O+5c2TCkEzUT+2k="        # Corsair PSU
      allow hash "OlAZ0WVYEJAB4aD4crBc2XT3YD9Y35l69FhAnUkd4+Y="        # Garmin Watch
      allow hash "Q26mMR4yTWM+GsoqXRtY81foWerxuan04933WMq7VSQ="        # Keychron Keyboard
      allow hash "yXobwMW1Gw0jxMPJdKyLWbxVAsqSFFtSaKn792aP87c="        # Logitech Camera
      allow hash "y0nMBYvoXYCGsR9c/YuFAQLlt1a63qgUaXo232qnT8Y="        # Logitech Receiver
      allow hash "iVf76Dc8asgE8m9aq9BFMhFgdkpnYuUToXPnt4Vf79Q="        # SanDisk Extreme Pro
      allow hash "rxeggb91UNgLtQU9ej+HZmyML69KropjTtXR3mbqSgE="        # SanDisk Extreme Pro
      allow hash "lzq9AGwU6Lp53U7fCfuh5Y+lII1P+xK/BnUp5hLweyc="        # SteelSeries Headphones
      allow hash "XBoEcj4BKpuQ+RwurNQvKfASfgwB5oGwhkWQTBozaOY="        # Thrustmaster Stick
      allow hash "ikayKI4/D/gOJKOvd1Ho/bfGuSVIWGi/9vtJxBgDrwk="        # Thrustmaster Throttle

      allow hash "Ghx8Z1hiW875rcDmwb6oAhtqT4Kf0XiUnQgANRLi6PI="        # Alienware Hub

      allow hash "6wd5RDNGVTlBi8cwUnlJhf6wQxVMw4lPppgOfi2ZFwk="        # Genesys Logic Hub
      allow hash "7L+4JQysVQmKqmuJW+7Tfm5pktL6b7OjAZ0NjvT92xQ="        # Genesys Logic Hub

      allow hash "+0s5mKAEDBjZasKfFR9ExKfjpMr/J4C4yq4bgYdLJSM="        # Host Controller
      allow hash "kfg9rWbHDmu9sziJKn54hYXgOUymiXkU/EU39jdg/GA="        # Host Controller
      allow hash "mwoNTKm3aF0jTqIhDGlVsUwfcb+vy+uyPfiVL/Uxir8="        # Host Controller
      allow hash "nyjiuLoRZPIYxANlVmwcZIYZhmLEJXOfZnW9G6v4oFo="        # Host Controller
      allow hash "OOTFv0DuAPoWzkjfh1FRhwu95L3mbMj68cvWj70EeKY="        # Host Controller
      allow hash "YCmLXGZH8v4LO2zcs6hgNQ6/M9R24O7dO1glO/IWMo4="        # Host Controller

      allow hash "PvoqVe8QP1gB0wnZ482YC92QbP8ztHOHqrhNzcS2F3g="        # Microchip Hub
      allow hash "V6W0USsOPQ9oncxHMVacxXal7RlHZxp6RTCnG4Z8mvg="        # Microchip Hub

      allow hash "AGUYEKgZCSjWnBQRgECiKsBFduiNgQO6eIKZQaynmmY="        # PNY Card Reader
      allow parent-hash "AGUYEKgZCSjWnBQRgECiKsBFduiNgQO6eIKZQaynmmY=" # PNY Card Reader (Devices)
    '';
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
