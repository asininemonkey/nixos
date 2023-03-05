{ config, pkgs, ... }:

{
  boot.loader.grub.extraEntries = ''
    menuentry "Windows 11" {
      set root=(hd1,gpt1)
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

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
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      '';
    };

    systemPackages = (with pkgs; [
      chiaki
    ]);
  };

  hardware = {
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

  networking.extraHosts = "192.168.144.200 intel-nuc";

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
