{
  config,
  pkgs,
  ...
}:

let
  background-image = "/run/current-system/sw/share/backgrounds/gnome/pixels-d.jpg";
  font-family = "Iosevka Nerd Font";
  nixos-unstable = fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
  tailnet-server = "intel-nuc";
  webdav-server = "files.josecardoso.net";
in

{
  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      cheese
      epiphany
      geary
      gnome-calendar
      gnome-contacts
      gnome-music
      gnome-shell-extensions
      pkgs.gnome-connections
      pkgs.gnome-console
      pkgs.gnome-photos
      pkgs.gnome-text-editor
      pkgs.gnome-tour
      simple-scan
      totem
      yelp
    ];

    systemPackages = with pkgs; [
      celluloid
      dconf2nix
      gnome-firmware
      gnome.dconf-editor
      gnome.ghex
      gnome.gnome-tweaks
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.appindicator
      gnomeExtensions.astra-monitor
      gnomeExtensions.extension-list
      gnomeExtensions.just-perfection
      gnomeExtensions.lock-keys
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.tiling-assistant
      gnomeExtensions.user-themes
      gnomeExtensions.window-list
      libgtop # Astra Monitor
    ];

    variables = {
      GTK_THEME = "Adwaita:dark";
    };
  };

  home-manager.users.jcardoso = { config, lib, ... }: with lib.hm.gvariant; {
    dconf.settings = { # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
      "io/github/celluloid-player/celluloid" = {
        mpv-options = "hwdec=vaapi";
      };

      "org/gnome/calculator" = {
        button-mode = "advanced";
        refresh-interval = 86400;
        source-currency = "GBP";
        target-currency = "EUR";
      };

      "org/gnome/clocks" = {
        world-clocks = [
          ([ 
            (mkDictionaryEntry ["location" (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "Adelaide"
                "YPAD"
                true
                [(mkTuple [(-0.6097016795455882) (2.4175719080385765)])]
                [(mkTuple [(-0.6097016795455882) (2.419026343264141)])]
              ]))
            ]))])
          ])
          ([ 
            (mkDictionaryEntry ["location" (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "New York"
                "KNYC"
                true
                [(mkTuple [(0.7118034407872564) (-1.2909618758762367)])]
                [(mkTuple [(0.7105980465926592) (-1.2916478949920254)])]
              ]))
            ]))])
          ])
        ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${background-image}";
        picture-uri-dark = "file://${background-image}";
      };

      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };

      "org/gnome/desktop/datetime" = {
        automatic-timezone = false;
      };

      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        clock-show-seconds = true;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        cursor-size = 32;
        document-font-name = "Arcticons Sans 12";
        font-name = "Arcticons Sans 12";
        gtk-theme = "Adwaita-dark";
        icon-theme = "Papirus-Dark";
        monospace-font-name = "${font-family} 12";
        show-battery-percentage = true;
        # text-scaling-factor = 1.1;
      };

      "org/gnome/desktop/media-handling" = {
        autorun-never = true;

        autorun-x-content-ignore = [
          "x-content/audio-cdda"
          "x-content/audio-player"
          "x-content/image-dcf"
          "x-content/unix-software"
          "x-content/video-dvd"
        ];
      };

      "org/gnome/desktop/privacy" = {
        old-files-age = mkUint32 1;
        recent-files-max-age = 1;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      "org/gnome/desktop/screensaver" = {
        lock-delay = mkUint32 30;
        picture-uri = "file://${background-image}";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        titlebar-font = "Arcticons Sans Bold 12";
      };

      "org/gnome/GHex" = {
        font = "${font-family} 16";
      };

      "org/gnome/gnome-screenshot" = {
        auto-save-directory = "file:///home/jcardoso/Pictures/Screenshots";
        last-save-directory = "file:///home/jcardoso/Pictures/Screenshots";
      };

      "org/gnome/gnome-system-monitor" = {
        disks-interval = 1000;
        graph-update-interval = 1000;
        show-dependencies = true;
        update-interval = 1000;
      };

      "org/gnome/mutter" = {
        center-new-windows = true;
        dynamic-workspaces = true;

        experimental-features = [
          "scale-monitor-framebuffer"
          "variable-refresh-rate"
        ];
      };

      "org/gnome/nautilus/preferences" = {
        show-delete-permanently = true;
      };

      "org/gnome/nautilus/window-state" = {
        initial-size = mkTuple [ 1800 900 ];
        sidebar-width = 300;
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "appindicatorsupport@rgcjonas.gmail.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "extension-list@tu.berry"
          "just-perfection-desktop@just-perfection"
          "lockkeys@vaina.lt"
          "monitor@astraext.github.io"
          "tiling-assistant@leleat-on-github"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "window-list@gnome-shell-extensions.gcampax.github.com"
        ];

        favorite-apps = [
          "1password.desktop"
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "kitty.desktop"
          "obsidian.desktop"
          "signal-desktop.desktop"
          "codium.desktop"
        ];
      };

      "org/gnome/shell/extensions/alphabetical-app-grid" = {
        folder-order-position = "end";
        show-favourite-apps = true;
      };

      "org/gnome/shell/extensions/astra-monitor" = {
      };

      "org/gnome/shell/extensions/just-perfection" = {
        accessibility-menu = false;
        window-demands-attention-focus = true;
      };

      "org/gnome/shell/extensions/tiling-assistant" = {
        activate-layout0 = [
          "<Alt><Super>1"
        ];

        activate-layout1 = [
          "<Alt><Super>2"
        ];

        activate-layout2 = [
          "<Alt><Super>3"
        ];

        activate-layout3 = [
          "<Alt><Super>4"
        ];

        activate-layout4 = [
          "<Alt><Super>5"
        ];

        activate-layout5 = [
          "<Alt><Super>6"
        ];

        center-window = [
          "<Super>c"
        ];

        enable-advanced-experimental-features = true;
        show-layout-panel-indicator = true;
        window-gap = 4;
      };

      "org/gnome/shell/extensions/window-list" = {
        grouping-mode = "auto";
        show-on-all-monitors = true;
      };

      "org/gnome/shell/world-clocks" = {
        locations = [
          ([ 
            (mkDictionaryEntry ["location" (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "Adelaide"
                "YPAD"
                true
                [(mkTuple [(-0.6097016795455882) (2.4175719080385765)])]
                [(mkTuple [(-0.6097016795455882) (2.419026343264141)])]
              ]))
            ]))])
          ])
          ([ 
            (mkDictionaryEntry ["location" (mkVariant (mkTuple [
              (mkUint32 2)
              (mkVariant (mkTuple [
                "New York"
                "KNYC"
                true
                [(mkTuple [(0.7118034407872564) (-1.2909618758762367)])]
                [(mkTuple [(0.7105980465926592) (-1.2916478949920254)])]
              ]))
            ]))])
          ])
        ];
      };

      "org/gnome/software" = {
        first-run = false;
      };

      "org/gnome/system/location" = {
        enabled = true;
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gtk/gtk4/settings/file-chooser" = {
        sort-directories-first = true;
      };

      "org/gtk/settings/file-chooser" = {
        sort-directories-first = true;
      };
    };

    home.file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/jcardoso/.var/app Flatpak Data
        davs://${webdav-server}/emulation ${tailnet-server}/emulation
        davs://${webdav-server}/iso-images ${tailnet-server}/iso-images
        davs://${webdav-server}/media ${tailnet-server}/media
        davs://${webdav-server}/miscellaneous ${tailnet-server}/miscellaneous
        davs://${webdav-server}/rips ${tailnet-server}/rips
        davs://${webdav-server}/temporary ${tailnet-server}/temporary
      '';

      ".config/tiling-assistant/layouts.json".text = ''
        [
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 0.9,
                            "width": 0.9,
                            "x": 0.05,
                            "y": 0.05
                        }
                    }
                ],
                "_name": "Focused (Large)"
            },
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 0.8,
                            "width": 0.8,
                            "x": 0.1,
                            "y": 0.1
                        }
                    }
                ],
                "_name": "Focused (Medium)"
            },
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 0.7,
                            "width": 0.7,
                            "x": 0.15,
                            "y": 0.15
                        }
                    }
                ],
                "_name": "Focused (Small)"
            },
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 1,
                            "width": 0.6,
                            "x": 0.2,
                            "y": 0
                        }
                    }
                ],
                "_name": "Middle"
            },
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 0.9,
                            "width": 0.9,
                            "x": 0,
                            "y": 0
                        }
                    }
                ],
                "_name": "Top Left"
            },
            {
                "_items": [
                    {
                        "appId": null,
                        "loopType": null,
                        "rect": {
                            "height": 0.9,
                            "width": 0.9,
                            "x": 0.1,
                            "y": 0.1
                        }
                    }
                ],
                "_name": "Bottom Right"
            }
        ]
      '';
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      inherit (import nixos-unstable {
        config = config.nixpkgs.config;
      }) gnomeExtensions;
    })
  ];

  services = {
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      enable = true;

      excludePackages = with pkgs; [
        xterm
      ];

      xkb.layout = "gb";
    };
  };
}
