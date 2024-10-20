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
    rev = "9d851cebffd92ad3d2c69cc4df7a2c9368b78f73";
    sha256 = "sha256-GMZubGvIEZIpHhb3sw7GIK7hFtHGBijsXQbR8TBAF+U=";
  };
in

{
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      akonadi
      breeze-icons
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
                  "applications:kitty.desktop"
                  "applications:signal-desktop.desktop"
                  "applications:codium.desktop"
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
