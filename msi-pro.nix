{ config, pkgs, ... }:

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

    systemPackages = (with pkgs; [
      amazon-ecr-credential-helper
      awscli2
      globalprotect-openconnect
      gnupg
      gnutls
      nodejs-16_x
      python311
      slack
      zoom-us
    ]) ++ (with pkgs.unstable; [
      asdf-vm
    ]);
  };

  hardware = {
    printers = {
      ensureDefaultPrinter = "Ricoh_MP_C4504";

      ensurePrinters = [
        {
          description = "Ricoh MP C4504";
          deviceUri = "ipp://172.16.30.245/ipp";
          location = "3rd Floor";
          model = "everywhere";
          name = "Ricoh_MP_C4504";
        }
      ];
    };
  };

  home-manager.users.jcardoso = { config, ... }: {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 0;
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-timeout = 0;
        sleep-inactive-battery-type = "nothing";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "slack.desktop"
          "Zoom.desktop"
        ];
      };
    };

    home.file = {
      ".aws/config".text = ''
        [profile friday-production]
        output = json
        region = us-east-2
        s3 =
            signature_version = s3v4
        sso_account_id = 129796368817
        sso_region = us-east-1
        sso_role_name = fridayProdAdmin
        sso_start_url = https://dailypay.awsapps.com/start

        [profile friday-staging]
        output = json
        region = us-east-2
        s3 =
            signature_version = s3v4
        sso_account_id = 343349230900
        sso_region = us-east-1
        sso_role_name = fridayStagingAdmin
        sso_start_url = https://dailypay.awsapps.com/start

        [profile friday-uat]
        output = json
        region = us-east-2
        s3 =
            signature_version = s3v4
        sso_account_id = 196087155463
        sso_region = us-east-1
        sso_role_name = fridayUatAdmin
        sso_start_url = https://dailypay.awsapps.com/start
      '';

      ".aws/credentials".text = "";

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

      ".config/wireplumber/main.lua.d/prioritise-nodes.lua".text = ''
        analog_input = {
          apply_properties = {
            ["priority.driver"] = 1900,
            ["priority.session"] = 1900
          },
          matches = {
            {
              {"node.name", "equals", "alsa_input.usb-046d_Logitech_StreamCam_1635D365-02.analog-stereo"}
            }
          }
        }

        analog_output = {
          apply_properties = {
            ["priority.driver"] = 900,
            ["priority.session"] = 900
          },
          matches = {
            {
              {"node.name", "equals", "alsa_output.usb-Sennheiser_electronic_GmbH___Co._KG_MOMENTUM_3_KG001016090460576383B1GD900570005-00.analog-stereo"}
            }
          }
        }

        digital_input = {
          apply_properties = {
            ["priority.driver"] = 2000,
            ["priority.session"] = 2000
          },
          matches = {
            {
              {"node.name", "equals", "alsa_input.usb-046d_Logitech_StreamCam_1635D365-02.iec958-stereo"}
            }
          }
        }

        digital_output = {
          apply_properties = {
            ["priority.driver"] = 1000,
            ["priority.session"] = 1000
          },
          matches = {
            {
              {"node.name", "equals", "alsa_output.usb-Sennheiser_electronic_GmbH___Co._KG_MOMENTUM_3_KG001016090460576383B1GD900570005-00.iec958-stereo"}
            }
          }
        }

        table.insert(alsa_monitor.rules, analog_input)
        table.insert(alsa_monitor.rules, analog_output)
        table.insert(alsa_monitor.rules, digital_input)
        table.insert(alsa_monitor.rules, digital_output)
      '';

      ".config/Yubico/u2f_keys".text = ''
        jcardoso:kLm87XWNdgYbbmORyQMCX9CAwG5GRCjXidRoqcmxmdtCbv0kqEcUYy6PnLpK2zDX2FGusn7ak/OogXbrjipwsw==,c4Znnm3Exo2azeZv7J41ATAYe/35+XYqdH7dn4HHQPLTiyP//tNsCnJKofL/QIAqExeWIa7LjUlqZRanrQf+mg==,es256,+presence
      '';

      ".docker/config.json".text = ''
        {
          "credHelpers": {
            "129796368817.dkr.ecr.us-east-2.amazonaws.com": "ecr-login",
            "343349230900.dkr.ecr.us-east-2.amazonaws.com": "ecr-login",
            "870869572832.dkr.ecr.us-east-1.amazonaws.com": "ecr-login",
            "974673539992.dkr.ecr.us-east-1.amazonaws.com": "ecr-login"
          }
        }
      '';

      "Documents/Source/clone-repos.sh" = {
        executable = true;

        text = ''
          #!/usr/bin/env zsh

          CLONE_ROOT="''${HOME}/Documents/Source"

          for CLONE_DIRECTORY in Work
          do
            CLONE_SOURCE="git@github.com:dailypay"

            mkdir -p "''${CLONE_ROOT}/''${CLONE_DIRECTORY}"

            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/core-infrastructure.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-batch.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-ecs.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-harness.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-infrastructure.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-performance.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-runbooks.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-socketcluster.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/friday-webhooks.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/fridaycardapp.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/harness.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/joey-card.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/joey-sdk.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/terraform-aws-ecr-module.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/terraform-dailypay-globals.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/terraform-shared-infrastructure.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/user-management.git"
          done
        '';
      };

      "Documents/Source/Work/work.code-workspace".text = ''
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
                    "path": "./core-infrastructure"
                },
                {
                    "path": "./fridaycardapp"
                },
                {
                    "path": "./friday-batch"
                },
                {
                    "path": "./friday-ecs"
                },
                {
                    "path": "./friday-harness"
                },
                {
                    "path": "./friday-infrastructure"
                },
                {
                    "path": "./friday-performance"
                },
                {
                    "path": "./friday-runbooks"
                },
                {
                    "path": "./friday-socketcluster"
                },
                {
                    "path": "./friday-webhooks"
                },
                {
                    "path": "./harness"
                },
                {
                    "path": "./joey-card"
                },
                {
                    "path": "./joey-sdk"
                },
                {
                    "path": "./terraform-aws-ecr-module"
                },
                {
                    "path": "./terraform-dailypay-globals"
                },
                {
                    "path": "./terraform-shared-infrastructure"
                },
                {
                    "path": "./user-management"
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
                "window.zoomLevel": 1
            }
        }
      '';
    };

    programs = {
      ssh = {
        matchBlocks = {
          "fb?" = {
            user = "jose_cardoso";
          };

          "fb? intel-nuc msi-pro" = {
            forwardAgent = true;
          };

          "fbp" = {
            hostname = "bastion.dpfriday.com";
          };

          "fbs" = {
            hostname = "bastion.dpfridaystaging.com";
          };

          "fbu" = {
            hostname = "bastion.dpfridayuat.com";
          };
        };
      };

      zsh = {
        envExtra = ''
          export AWS_PAGER=""
          export AWS_SDK_LOAD_CONFIG=true
        '';

        shellAliases = {
          asl = "aws --profile friday-staging sso login";
          tf = "terraform fmt --recursive";

          tafp = "SERVICE=friday ENVIRONMENT=\${SERVICE}-production ./scripts/tfs apply";
          tafs = "SERVICE=friday ENVIRONMENT=\${SERVICE}-staging ./scripts/tfs apply";
          tafu = "SERVICE=friday ENVIRONMENT=\${SERVICE}-uat ./scripts/tfs apply";
          tpfp = "SERVICE=friday ENVIRONMENT=\${SERVICE}-production ./scripts/tfs plan";
          tpfs = "SERVICE=friday ENVIRONMENT=\${SERVICE}-staging ./scripts/tfs plan";
          tpfu = "SERVICE=friday ENVIRONMENT=\${SERVICE}-uat ./scripts/tfs plan";
          tsfp = "SERVICE=friday ENVIRONMENT=\${SERVICE}-production ./scripts/tfs state";
          tsfs = "SERVICE=friday ENVIRONMENT=\${SERVICE}-staging ./scripts/tfs state";
          tsfu = "SERVICE=friday ENVIRONMENT=\${SERVICE}-uat ./scripts/tfs state";
        };
      };
    };
  };

  networking = {
    hostName = "msi-pro";

    networkmanager.unmanaged = [
      "mac:1c:e1:92:b2:ad:32"
      "mac:1c:e1:92:b2:f8:53"
    ];
  };

  security = {
    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };

      u2f = {
        cue = true;
        enable = true;
      };
    };
  };

  services.globalprotect = {
    enable = true;

    settings = {
      "a7.dailypay.com" = {
        openconnect-args = "--servercert=pin-sha256:dUqBLtWTRcX2IUm3HTTiKA68AjmibowaJscs6T8mmrg="; # gnutls-cli --insecure a7.dailypay.com | grep --after-context 1 'Public Key PIN'
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
  ];
}
