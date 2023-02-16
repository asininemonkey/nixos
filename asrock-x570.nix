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
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Geary.desktop"
        ];
      };
    };

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

      "Documents/Source/clone-repos.sh" = {
        executable = true;

        text = ''
          #!/usr/bin/env zsh

          CLONE_ROOT="''${HOME}/Documents/Source"

          for CLONE_DIRECTORY in Private
          do
            CLONE_SOURCE="git@github.com:asininemonkey"

            mkdir -p "''${CLONE_ROOT}/''${CLONE_DIRECTORY}"

            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/bootstrap.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/cv.josecardoso.com.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/josecardoso.com.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/nixos.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/obsidian.git"
          done
        '';
      };

      "Documents/Source/Private/private.code-workspace".text = ''
        {
            "extensions": {
                "recommendations": [
                    "bungcip.better-toml",
                    "eamodio.gitlens",
                    "esbenp.prettier-vscode",
                    "hashicorp.terraform",
                    "irongeek.vscode-env",
                    "jnoortheen.nix-ide",
                    "ms-azuretools.vscode-docker",
                    "ms-kubernetes-tools.vscode-kubernetes-tools",
                    "ms-vscode-remote.remote-containers",
                    "rangav.vscode-thunder-client",
                    "redhat.vscode-yaml",
                    "richie5um2.vscode-sort-json"
                ]
            },
            "folders": [
                {
                    "path": "./bootstrap"
                },
                {
                    "path": "./cv.josecardoso.com"
                },
                {
                    "path": "./josecardoso.com"
                },
                {
                    "path": "./nixos"
                },
                {
                    "path": "./obsidian"
                }
            ],
            "settings": {
                "diffEditor.ignoreTrimWhitespace": false,
                "editor.bracketPairColorization.enabled": true,
                "editor.defaultFormatter": "esbenp.prettier-vscode",
                "editor.fontFamily": "Iosevka",
                "editor.fontLigatures": true,
                "editor.fontSize": 18,
                "editor.fontWeight": "normal",
                "editor.guides.bracketPairs": "active",
                "editor.renderControlCharacters": true,
                "editor.renderWhitespace": "all",
                "explorer.confirmDelete": false,
                "files.associations": {
                    "*.hcl": "terraform"
                },
                "git.autofetch": true,
                "git.confirmSync": false,
                "git.showActionButton": {
                    "commit": false,
                    "publish": false,
                    "sync": false
                },
                "prettier.endOfLine": "auto",
                "prettier.tabWidth": 4,
                "redhat.telemetry.enabled": false,
                "scm.defaultViewMode": "tree",
                "scm.repositories.visible": 20,
                "terminal.integrated.fontFamily": "Iosevka",
                "terminal.integrated.fontSize": 18,
                "terminal.integrated.fontWeight": "normal",
                "update.mode": "none",
                "window.zoomLevel": 1
            }
        }
      '';
    };
  };

  networking = {
    extraHosts = "192.168.144.200 intel-nuc";
    hostName = "asrock-x570";
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
