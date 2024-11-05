{
  config,
  pkgs,
  ...
}:

let
  background-image = builtins.fetchurl "https://images.hdqwalls.com/download/beyond-the-railroad-crossing-5k-5b-3440x1440.jpg"; # https://hdqwalls.com/3440x1440-resolution-wallpapers

  plasma-manager = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "plasma-manager";
    rev = "247a8e677b51f053ca89dcf67059e24f85e47391";
    sha256 = "sha256-2sVt2hbL+G0FzEESm/EZBewPOmNtZ6MTnYhsvHJW6Rs=";
  };
in

{
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      akonadi
      breeze-icons
      elisa
      kate
      konsole
      plasma-browser-integration
    ];

    systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${background-image}
      '')
    ];
  };

  home-manager.users.jcardoso = { config, ... }: {
    imports = [
      (plasma-manager + "/modules")
    ];

    # https://nix-community.github.io/plasma-manager/options.xhtml
    programs.plasma = {
      configFile = {
        kwinrc.Desktops.Number = {
          immutable = true;
          value = 2;
        };
      };

      enable = true;

      hotkeys.commands."kitty" = {
        command = "kitty";
        key = "Meta+Alt+K";
        name = "kitty";
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
                launchers = [
                  "applications:1password.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:GitKraken Desktop.desktop"
                  "applications:kitty.desktop"
                  "applications:obsidian.desktop"
                  "applications:signal-desktop.desktop"
                  "applications:dev.zed.Zed.desktop"
                ];
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
                  family = "Noto Sans";
                  size = 14;
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
        iconTheme = "Papirus-Dark";
        lookAndFeel = "org.kde.breezedark.desktop";
        wallpaper = background-image;
      };
    };
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.compositor = "kwin";
      wayland.enable = true;
    };
  };
}
