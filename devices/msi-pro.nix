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

    systemPackages = with pkgs; [
      rocmPackages.clr
    ];
  };

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

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
              {"device.name", "equals", "alsa_card.pci-0000_04_00.1"}
            }
          }
        }

        table.insert(alsa_monitor.rules, disable_devices)
      '';
    };
  };

  services = {
    create_ap = {
      enable = false;

      settings = {
        # FREQ_BAND = 5;
        HIDDEN = 1;
        HT_CAPAB = "[HT40+]";
        IEEE80211AC = 1;
        IEEE80211N = 1;
        INTERNET_IFACE = "enp2s0";
        PASSPHRASE = "bnvYksQgiqrmGpJKLyMfNeks8QuNUkzwuQFvUD2QuAqYJTxgR9iZVnYphiwgaQN";
        SHARE_METHOD = "bridge";
        SSID = config.networking.hostName;
        WIFI_IFACE = "wlp3s0";
      };
    };

    fstrim.enable = true;
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
