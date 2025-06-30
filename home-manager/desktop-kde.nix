{
  custom,
  pkgs,
  ...
}: {
  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma = {
    configFile = {
      klipperrc.General = {
        KeepClipboardContents = {
          immutable = true;
          value = false;
        };

        MaxClipItems = {
          immutable = true;
          value = 10;
        };
      };

      kwinrc.Desktops.Number = {
        immutable = true;
        value = 2;
      };

      plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = {
        immutable = true;
        value = false;
      };
    };

    enable = true;

    hotkeys.commands."ghostty" = {
      command = "ghostty";
      key = "Meta+Alt+G";
      name = "ghostty";
    };

    input.keyboard = {
      layouts = [
        {
          layout = "gb";
        }
      ];

      repeatDelay = 500;
      repeatRate = 25;
    };

    kwin.virtualDesktops = {
      number = 2;
      rows = 1;
    };

    overrideConfig = true;

    panels = [
      {
        floating = true;
        location = "bottom";

        widgets = [
          # https://github.com/nix-community/plasma-manager/tree/trunk/modules/widgets
          {
            kickoff = {
              icon = "nix-snowflake-white";
              sortAlphabetically = true;
            };
          }
          {
            pager.general.displayedText = "desktopNumber";
          }
          {
            iconTasks = {
              launchers =
                if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
                then [
                  "applications:1password.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:com.mitchellh.ghostty.desktop"
                  "applications:obsidian.desktop"
                  "applications:signal.desktop"
                  "applications:sublime_merge.desktop"
                  "applications:dev.zed.Zed.desktop"
                ]
                else [];
            };
          }
          {
            panelSpacer = {};
          }
          {
            systemTray = {};
          }
          {
            systemMonitor = {
              displayStyle = "org.kde.ksysguard.linechart";

              sensors = [
                {
                  color = "50,175,225";
                  label = "CPU Usage";
                  name = "cpu/all/usage";
                }
              ];

              settings = {
                Appearance.updateRateLimit = 1000;
              };

              title = "CPU Usage";
            };
          }
          {
            systemMonitor = {
              displayStyle = "org.kde.ksysguard.linechart";

              sensors = [
                {
                  color = "50,225,175";
                  label = "Memory Usage";
                  name = "memory/physical/used";
                }
              ];

              settings = {
                Appearance.updateRateLimit = 1000;
              };

              title = "Memory Usage";
            };
          }
          {
            digitalClock = {
              font = {
                family = custom.font.sans.name;
                size = custom.font.sans.size;
                style = "Regular";
                weight = 400;
              };

              time = {
                format = "12h";
                showSeconds = "always";
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    workspace = {
      colorScheme = "BreezeDark";
      iconTheme = "Papirus-Dark";
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      wallpaper = custom.image.wall;
    };
  };
}
