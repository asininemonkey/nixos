{
  config,
  lib,
  pkgs,
  ...
}:

let
  # background-image = builtins.fetchurl "https://www.xxx/yyy.zzz";
  background-image = "/run/current-system/sw/share/backgrounds/gnome/pixels-d.jpg";
  browser-homepage = "https://start.duckduckgo.com/?kad=en_GB&kak=-1&kaq=-1&kau=-1&kl=uk-en&kn=1";
  tailnet-name = "fable-blues.ts.net";
  tailnet-server = "intel-nuc";
  webdav-server = "files.josecardoso.net";
in

{
  home-manager.users.jcardoso = { config, lib, ... }: with lib.hm.gvariant; {
    dconf.settings = { # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };

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
        monospace-font-name = "Fantasque Sans Mono 12";
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

      "org/gnome/epiphany" = {
        default-search-engine = "DuckDuckGo";
        homepage-url = "${browser-homepage}";
        search-engine-providers = "[{'url': <'https://duckduckgo.com/?q=%s'>, 'bang': <'!ddg'>, 'name': <'DuckDuckGo'>}]";
      };

      "org/gnome/GHex" = {
        font = "Fantasque Sans Mono 16";
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
          "obsidian.desktop"
          "signal-desktop.desktop"
          "codium.desktop"
          "org.wezfurlong.wezterm.desktop"
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
      ".config/fastfetch/config.jsonc".text = ''
        {
            "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
            "display": {
                "separator": " "
            },
            "logo": {
                "height": 20,
                "source": "/etc/nixos/logo.png",
                "type": "iterm",
                "width": 44
            },
            "modules": [
                {
                    "key": "╭─ 󰌢",
                    "keyColor": "green",
                    "type": "host"
                },
                {
                    "key": "├─ 󰻠",
                    "keyColor": "green",
                    "type": "cpu"
                },
                {
                    "key": "├─ 󰍛",
                    "keyColor": "green",
                    "type": "gpu"
                },
                {
                    "key": "├─ 󰍹",
                    "keyColor": "green",
                    "type": "display"
                },
                {
                    "key": "├─ ",
                    "keyColor": "green",
                    "type": "disk"
                },
                {
                    "key": "╰─ 󰑭",
                    "keyColor": "green",
                    "type": "memory"
                },
                "break",
                {
                    "key": "╭─ ",
                    "keyColor": "yellow",
                    "type": "shell"
                },
                {
                    "key": "├─ ",
                    "keyColor": "yellow",
                    "type": "terminal"
                },
                {
                    "key": "├─ ",
                    "keyColor": "yellow",
                    "type": "de"
                },
                {
                    "key": "├─ ",
                    "keyColor": "yellow",
                    "type": "wm"
                },
                {
                    "key": "├─ 󰧨",
                    "keyColor": "yellow",
                    "type": "lm"
                },
                {
                    "key": "├─ 󰉼",
                    "keyColor": "yellow",
                    "type": "theme"
                },
                {
                    "key": "╰─ 󰀻",
                    "keyColor": "yellow",
                    "type": "icons"
                },
                "break",
                {
                    "format": "{1}@{2}",
                    "key": "╭─ ",
                    "keyColor": "blue",
                    "type": "title"
                },
                {
                    "key": "├─ ",
                    "keyColor": "blue",
                    "type": "os"
                },
                {
                    "format": "{1} {2}",
                    "key": "├─ ",
                    "keyColor": "blue",
                    "type": "kernel"
                },
                {
                    "key": "├─ 󰅐",
                    "keyColor": "blue",
                    "type": "uptime"
                },
                {
                    "compact": true,
                    "key": "╰─ 󰩟",
                    "keyColor": "blue",
                    "type": "localip"
                },
                "break",
                {
                    "paddingLeft": 5,
                    "type": "colors"
                }
            ]
        }
      '';

      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/jcardoso/.var/app Flatpak Data
        davs://${webdav-server}/emulation ${tailnet-server}/emulation
        davs://${webdav-server}/iso-images ${tailnet-server}/iso-images
        davs://${webdav-server}/media ${tailnet-server}/media
        davs://${webdav-server}/miscellaneous ${tailnet-server}/miscellaneous
        davs://${webdav-server}/rips ${tailnet-server}/rips
        davs://${webdav-server}/temporary ${tailnet-server}/temporary
      '';

      ".config/op/plugins.sh".text = ''
        alias gh="op plugin run -- gh"
        export OP_PLUGIN_ALIASES_SOURCED=1
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

      ".config/VSCodium/product.json".text = ''
        {
            "extensionsGallery": {
                "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
                "itemUrl": "https://marketplace.visualstudio.com/items",
                "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery"
            }
        }
      '';

      ".hidden".text = "Public";

      ".local/share/applications/btop.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/cups.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/mpv.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/org.gnome.Extensions.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/umpv.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";

      ".local/share/remmina/home_rdp_asrock-x570_asrock-x570-windows.remmina".text = ''
        [remmina]
        group=Home
        name=asrock-x570
        protocol=RDP
        server=asrock-x570-windows
        username=Jose
        window_height=1080
        window_width=1920
      '';

      ".wezterm.lua".text = ''
        local wezterm = require 'wezterm'

        local config = {}

        config.color_scheme = 'Konsolas'

        config.colors = {
          scrollbar_thumb = 'grey',
          selection_bg = 'rgba:50% 50% 50% 50%',
          selection_fg = 'none',
        }

        config.cursor_blink_rate = 500

        config.default_cursor_style = 'BlinkingBlock'

        config.enable_scroll_bar = true

        config.font = wezterm.font {
          family = 'Fantasque Sans Mono',
          harfbuzz_features = {
            'ss01'
          },
        }

        config.font_size = 18

        config.initial_cols = 160
        config.initial_rows = 40

        config.keys = {
          {
            action = wezterm.action.Multiple {
              wezterm.action.ClearScrollback 'ScrollbackAndViewport',
              wezterm.action.SendKey {
                key = 'l',
                mods = 'CTRL'
              },
            },
            key = 'k',
            mods = 'CTRL|SHIFT',
          }
        }

        config.window_background_opacity = 0.9

        config.xcursor_theme = 'Adwaita'

        return config
      '';

      "Documents/Bottles/Cyberduck.yaml".text = ''
        Arch: win64
        CompatData: \'\'
        Custom_Path: false
        DLL_Overrides: {}
        DXVK: dxvk-2.1-1-0811813
        Environment: Custom
        Environment_Variables: {}
        External_Programs: {}
        Installed_Dependencies:
        - dotnet40
        - dotnet45
        - dotnet46
        - dotnet461
        - dotnet462
        - dotnet472
        Language: sys
        LatencyFleX: latencyflex-v0.1.1
        NVAPI: dxvk-nvapi-v0.6.1-1-0c54f06
        Name: Cyberduck
        Parameters:
            custom_dpi: 96
            decorated: true
            discrete_gpu: false
            dxvk: false
            dxvk_nvapi: false
            fixme_logs: false
            fsr: false
            fsr_quality_mode: none
            fsr_sharpening_strength: 2
            fullscreen_capture: false
            gamemode: false
            gamescope: false
            gamescope_borderless: false
            gamescope_fps: 0
            gamescope_fps_no_focus: 0
            gamescope_fullscreen: true
            gamescope_game_height: 0
            gamescope_game_width: 0
            gamescope_scaling: false
            gamescope_window_height: 0
            gamescope_window_width: 0
            latencyflex: false
            mangohud: false
            mouse_warp: true
            obsvkc: false
            pulseaudio_latency: false
            renderer: gl
            sandbox: false
            sync: wine
            take_focus: false
            use_be_runtime: true
            use_eac_runtime: true
            use_runtime: false
            use_steam_runtime: false
            versioning_automatic: false
            versioning_compression: false
            versioning_exclusion_patterns: false
            virtual_desktop: false
            virtual_desktop_res: 1280x720
            vkbasalt: false
            vkd3d: false
            vmtouch: false
            vmtouch_cache_cwd: false
        Path: Cyberduck
        Runner: soda-7.0-9
        RunnerPath: \'\'
        Sandbox:
            share_net: false
            share_sound: false
        State: 0
        Uninstallers: {}
        VKD3D: vkd3d-proton-2.8-1-08909d9
        Versioning: false
        Versioning_Exclusion_Patterns: []
        Windows: win10
        WorkingDir: \'\'
        data: {}
        run_in_terminal: false
        session_arguments: \'\'
      '';

      "Documents/Backups/Enhancer for YouTube.json".text = ''
        {
            "settings": {
                "controlbar": {
                    "active": false
                },
                "controls": [
                    "cards-end-screens",
                    "cinema-mode",
                    "screenshot",
                    "video-filters"
                ],
                "controlsvisible": true,
                "darktheme": true,
                "disableautoplay": true,
                "hiderelated": true,
                "miniplayerposition": "_top-right",
                "newestcomments": true,
                "qualityembeds": "hd720",
                "qualityembedsfullscreen": "hd1080",
                "qualityplaylists": "hd1080",
                "qualityplaylistsfullscreen": "hd2160",
                "qualityvideos": "hd1080",
                "qualityvideosfullscreen": "hd2160",
                "selectquality": true,
                "selectqualityfullscreenoff": true,
                "selectqualityfullscreenon": true
            },
            "version": "2.0.117.10"
        }
      '';

      "Documents/Virtual Machines/quickemu/nixos-gnome.clean" = {
        executable = true;

        text = ''
          #!/usr/bin/env bash

          if [ ! -d nixos-gnome ]
          then
            mkdir nixos-gnome

            curl \
              --location \
              --output 'nixos-gnome/latest-nixos-gnome-x86_64-linux.iso' \
              'https://releases.nixos.org/nixos/23.11/nixos-23.11.2962.b8dd8be3c790/nixos-gnome-23.11.2962.b8dd8be3c790-x86_64-linux.iso'
          fi

          rm --force nixos-gnome/.lock
          rm --force nixos-gnome/*.fd
          rm --force nixos-gnome/*.qcow2
          rm --force nixos-gnome/*.sock*
          rm --force nixos-gnome/nixos-gnome.*
        '';
      };

      "Documents/Virtual Machines/quickemu/nixos-gnome.conf" = {
        executable = true;

        text = ''
          #!/run/current-system/sw/bin/quickemu --vm
          cpu_cores="4"
          disk_img="nixos-gnome/disk.qcow2"
          disk_size="64G"
          guest_os="linux"
          iso="nixos-gnome/latest-nixos-gnome-x86_64-linux.iso"
          preallocation="metadata"
        '';
      };

      "Documents/Virtual Machines/quickemu/nixos-minimal.clean" = {
        executable = true;

        text = ''
          #!/usr/bin/env bash

          if [ ! -d nixos-minimal ]
          then
            mkdir nixos-minimal

            curl \
              --location \
              --output 'nixos-minimal/latest-nixos-minimal-x86_64-linux.iso' \
              'https://releases.nixos.org/nixos/23.11/nixos-23.11.2962.b8dd8be3c790/nixos-minimal-23.11.2962.b8dd8be3c790-x86_64-linux.iso'
          fi

          rm --force nixos-minimal/.lock
          rm --force nixos-minimal/*.fd
          rm --force nixos-minimal/*.qcow2
          rm --force nixos-minimal/*.sock*
          rm --force nixos-minimal/nixos-minimal.*
        '';
      };

      "Documents/Virtual Machines/quickemu/nixos-minimal.conf" = {
        executable = true;

        text = ''
          #!/run/current-system/sw/bin/quickemu --vm
          cpu_cores="4"
          disk_img="nixos-minimal/disk.qcow2"
          disk_size="64G"
          guest_os="linux"
          iso="nixos-minimal/latest-nixos-minimal-x86_64-linux.iso"
          preallocation="metadata"
        '';
      };

      "Documents/Virtual Machines/quickemu/windows-11.clean" = {
        executable = true;

        text = ''
          #!/usr/bin/env bash

          if [ ! -d windows-11 ]
          then
            mkdir windows-11

            curl \
              --location \
              --output 'windows-11/latest-windows-11.iso' \
              'https://${webdav-server}/iso-images/windows/Win11_23H2_English_International_x64_Oct_2023.iso'

            curl \
              --location \
              --output 'windows-11/virtio-win.iso' \
              'https://${webdav-server}/iso-images/windows/virtio-win-0.1.240.iso'
          fi

          rm --force windows-11/.lock
          rm --force windows-11/*.fd
          rm --force windows-11/*.qcow2
          rm --force windows-11/*.sock*
          rm --force windows-11/tpm2*.*
          rm --force windows-11/windows-11.*
        '';
      };

      "Documents/Virtual Machines/quickemu/windows-11.conf" = {
        executable = true;

        text = ''
          #!/run/current-system/sw/bin/quickemu --vm
          cpu_cores="4"
          disk_img="windows-11/disk.qcow2"
          disk_size="32G"
          fixed_iso="windows-11/virtio-win.iso"
          guest_os="windows"
          iso="windows-11/latest-windows-11.iso"
          preallocation="metadata"
          # secureboot="on"
          tpm="on"
        '';
      };
    };

    home.sessionPath = [
      "\${GOBIN}"
    ];

    programs = {
      # chromium = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.chromium.enable
      #   commandLineArgs = [ # https://chromium.googlesource.com/chromium/src/+/refs/heads/main/chrome/common/chrome_switches.cc
      #     "--homepage=${browser-homepage}"
      #     "--incognito"
      #     "--no-experiments"
      #     "--no-first-run"
      #   ];

      #   enable = true;

      #   extensions = [
      #     {
      #       id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; # 1Password
      #     }
      #     {
      #       id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; # uBlock Origin
      #     }
      #     {
      #       id = "lmeddoobegbaiopohmpmmobpnpjifpii"; # Open in Firefox
      #     }
      #   ];
      # };

      firefox = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable
        enable = true;

        profiles = {
          jcardoso = {
            search = {
              default = "DuckDuckGo";
              force = true;
              order = [
                "DuckDuckGo"
              ];
            };

            settings = {
              "app.shield.optoutstudies.enabled" = false;
              "browser.aboutConfig.showWarning" = false;
              "browser.aboutwelcome.enabled" = false;
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
              "browser.formfill.enable" = false;
              "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
              "browser.newtabpage.activity-stream.feeds.snippets" = false;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
              "browser.newtabpage.activity-stream.showSearch" = true;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.search.suggest.enabled.private" = true;
              "browser.startup.homepage" = "${browser-homepage}";
              "browser.tabs.loadInBackground" = false;
              "browser.toolbars.bookmarks.visibility" = "always";
              "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"screenshot-button\",\"fxa-toolbar-menu-button\",\"customizableui-special-spring4\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\"],\"currentVersion\":18,\"newElementCount\":4}";
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.firstRunURL" = "";
              "devtools.toolbox.zoomValue" = 1.2;
              "dom.disable_open_during_load" = true;
              "dom.security.https_only_mode" = true;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "font.minimum-size.x-western" = 14;
              "font.name.monospace.x-western" = "Fantasque Sans Mono";
              "font.name.sans-serif.x-western" = "Arcticons Sans";
              "font.name.serif.x-western" = "Arcticons Sans";
              "font.size.monospace.x-western" = 16;
              "font.size.variable.x-western" = 16;
              "layout.css.prefers-color-scheme.content-override" = 0;
              "media.eme.enabled" = true;
              "network.cookie.lifetimePolicy" = 2;
              "network.protocol-handler.expose.virt-viewer" = true;
              "places.history.enabled" = false;
              "privacy.clearOnShutdown.offlineApps" = true;
              "privacy.clearOnShutdown.siteSettings" = true;
              "privacy.cpd.cache" = true;
              "privacy.cpd.cookies" = true;
              "privacy.cpd.formdata" = true;
              "privacy.cpd.history" = true;
              "privacy.cpd.offlineApps" = true;
              "privacy.cpd.sessions" = true;
              "privacy.cpd.siteSettings" = true;
              "privacy.donottrackheader.enabled" = true;
              "privacy.history.custom" = true;
              "privacy.sanitize.pending" = "[{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"downloads\",\"formdata\",\"history\",\"offlineApps\",\"sessions\",\"siteSettings\"],\"options\":{}}]";
              "privacy.sanitize.sanitizeOnShutdown" = true;
              "privacy.sanitize.timeSpan" = 0;
              "signon.autofillForms" = false;
              "signon.generation.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
              "signon.rememberSignons" = false;
              "xpinstall.whitelist.required" = true;
            };
          };
        };
      };

      git = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
        diff-so-fancy.enable = true;
        enable = true;

        extraConfig = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          gpg."ssh".program = "/run/current-system/sw/bin/op-ssh-sign";
          pull.rebase = false;
          url."ssh://git@github.com".insteadOf = "https://github.com";
        };

        userEmail = "65740649+asininemonkey@users.noreply.github.com";
        userName = "Jose Cardoso";
      };

      go = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.enable
        enable = true;
        goBin = "Documents/Source/Go/bin";
        goPath = "Documents/Source/Go";
      };

      mpv = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable
        config = {
          gpu-context = "wayland";
          hwdec = "vaapi";
        };

        enable = true;
      };

      ssh = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
        enable = true;

        extraConfig = ''
          IdentityAgent ~/.1password/agent.sock

          Host github.com
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519.pub
            User git
        '';

        matchBlocks = {
          "home-assistant" = {
            hostname = "home-assistant.${tailnet-name}";
            user = "root";
          };

          "${tailnet-server}" = {
            hostname = "${tailnet-server}.${tailnet-name}";
            user = "jcardoso";
          };
        };

        serverAliveInterval = 60;
      };

      starship = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
        enable = true;

        settings = {
          character = {
            error_symbol = "[→](bold red)"; # https://unicode-table.com/en/2192/
            success_symbol = "[→](bold green)"; # https://unicode-table.com/en/2192/
          };

          command_timeout = 2000;

          format = lib.concatStrings [
            "$username"
            "$directory"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$kubernetes"
            "$cmd_duration"
            "$line_break"
            "$time"
            "$character"
          ];

          kubernetes = {
            disabled = false;
            style = "bold green";
          };

          time = {
            disabled = false;
            use_12hr = true;
          };

          username.show_always = true;
        };
      };

      vscode = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enable
        enable = true;
        package = pkgs.vscodium;

        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "editor.bracketPairColorization.enabled" = true;
          "editor.fontFamily" = "Fantasque Sans Mono";
          "editor.fontLigatures" = "'ss01'";
          "editor.fontSize" = 18;
          "editor.fontWeight" = "normal";
          "editor.guides.bracketPairs" = "active";
          "editor.renderControlCharacters" = true;
          "editor.renderWhitespace" = "all";
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.ignoreRebaseWarning" = true;
          "redhat.telemetry.enabled" = false;
          "scm.defaultViewMode" = "tree";
          "security.workspace.trust.untrustedFiles" = "open";
          "telemetry.telemetryLevel" = "off";
          "terminal.integrated.fontFamily" = "Fantasque Sans Mono";
          "terminal.integrated.fontSize" = 18;
          "terminal.integrated.fontWeight" = "normal";
          "update.mode" = "none";
          "window.zoomLevel" = 1;
          "workbench.editor.empty.hint" = "hidden";
          "workbench.startupEditor" = "none";
        };
      };

      zsh = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
        enable = true;
        enableVteIntegration = true;

        envExtra = ''
          export AWS_PAGER=""
          export EXA_ICON_SPACING="2"
          export PATH="''${PATH}''${PATH:+:}''${GOBIN}"
          export SSH_AUTH_SOCK="''${HOME}/.1password/agent.sock"
        '';

        initExtra = ''
          source "''${HOME}/.config/op/plugins.sh"
          fastfetch
        '';

        oh-my-zsh = {
          enable = true;

          plugins = [
            "docker"
            "git"
            "kubectl"
          ];
        };

        shellAliases = {
          clean = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
          code = "codium";
          dig = "drill";
          dsc = "docker stop $(docker ps --quiet)";
          dsp = "docker system prune --all --force --volumes";
          failed = "systemctl list-units --state failed";
          fl = "flatpak list";
          fr = "sudo flatpak repair";
          fuu = "flatpak uninstall --unused";
          grpo = "git remote prune origin";
          htop = "btop";
          installed = "nix-store --query --references /run/current-system/sw | sed \"s/^\\/nix\\/store\\/[[:alnum:]]\\{32\\}-//\" | \sort";
          k9s = "k9s --readonly";
          ls = "eza --git --git-repos --group --group-directories-first --icons --time-style long-iso";
          mvc = "mullvad connect --wait";
          mvd = "mullvad disconnect --wait";
          mvl = "mullvad relay list";
          mvlch = "mullvad relay set location ch zrh";
          mvlgb = "mullvad relay set location gb lon";
          mvlie = "mullvad relay set location ie dub";
          mvs = "mullvad status --location -v";
          ncu = "sudo nix-channel --update";
          nrd = "sudo nixos-rebuild dry-activate";
          nrs = "sudo nixos-rebuild switch";
          nso = "nix --extra-experimental-features nix-command store optimise";
          nu = "sudo nix-channel --update && sudo nixos-rebuild switch";
          ping = "trip";
          speedtest = "speedtest --secure --share";
          tail = "tspin";
          top = "btop";
          tracepath = "trip";
          tree = "tree -aghpuCD";
        };
      };
    };
  };
}
