{ config, ... }:

{
  environment = {
    etc."monitors.xml" = {
      mode = "0444";

      text = ''
        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>2560</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>DP-1</connector>
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
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <monitor>
                <monitorspec>
                  <connector>HDMI-1</connector>
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
          </configuration>
        </monitors>
      '';
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
              {"device.name", "equals", "alsa_card.pci-0000_04_00.1"}
            }
          }
        }

        table.insert(alsa_monitor.rules, disable_devices)
      '';
    };
  };

  networking.networkmanager.unmanaged = [
    "mac:1c:e1:92:b2:ad:32" # USB Ethernet - Monitor
    "mac:1c:e1:92:b2:f8:53" # USB Ethernet - Monitor
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
