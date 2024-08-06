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
  font-family = "Iosevka Nerd Font";
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

      "org/gnome/epiphany" = {
        default-search-engine = "DuckDuckGo";
        homepage-url = browser-homepage;
        search-engine-providers = "[{'url': <'https://duckduckgo.com/?q=%s'>, 'bang': <'!ddg'>, 'name': <'DuckDuckGo'>}]";
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
                "type": "kitty-direct",
                "width": 44
            },
            "modules": [
                {
                    "key": "╭─ 󰌢 ",
                    "keyColor": "green",
                    "type": "host"
                },
                {
                    "key": "├─ 󰻠 ",
                    "keyColor": "green",
                    "type": "cpu"
                },
                {
                    "key": "├─ 󰍛 ",
                    "keyColor": "green",
                    "type": "gpu"
                },
                {
                    "key": "├─ 󰍹 ",
                    "keyColor": "green",
                    "type": "display"
                },
                {
                    "key": "├─  ",
                    "keyColor": "green",
                    "type": "disk"
                },
                {
                    "key": "╰─ 󰑭 ",
                    "keyColor": "green",
                    "type": "memory"
                },
                "break",
                {
                    "key": "╭─  ",
                    "keyColor": "yellow",
                    "type": "shell"
                },
                {
                    "key": "├─  ",
                    "keyColor": "yellow",
                    "type": "terminal"
                },
                {
                    "key": "├─  ",
                    "keyColor": "yellow",
                    "type": "de"
                },
                {
                    "key": "├─  ",
                    "keyColor": "yellow",
                    "type": "wm"
                },
                {
                    "key": "├─ 󰧨 ",
                    "keyColor": "yellow",
                    "type": "lm"
                },
                {
                    "key": "├─ 󰉼 ",
                    "keyColor": "yellow",
                    "type": "theme"
                },
                {
                    "key": "╰─ 󰀻 ",
                    "keyColor": "yellow",
                    "type": "icons"
                },
                "break",
                {
                    "format": "{1}@{2}",
                    "key": "╭─  ",
                    "keyColor": "blue",
                    "type": "title"
                },
                {
                    "key": "├─  ",
                    "keyColor": "blue",
                    "type": "os"
                },
                {
                    "format": "{1} {2}",
                    "key": "├─  ",
                    "keyColor": "blue",
                    "type": "kernel"
                },
                {
                    "key": "├─ 󰅐 ",
                    "keyColor": "blue",
                    "type": "uptime"
                },
                {
                    "compact": true,
                    "key": "╰─ 󰩟 ",
                    "keyColor": "blue",
                    "type": "localip"
                },
                "break"
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

      ".config/kitty/kitty.conf".text = ''
        # https://sw.kovidgoyal.net/kitty/conf/
        background_opacity 0.9
        bold_font auto
        bold_italic_font auto
        cursor_stop_blinking_after 0
        font_family ${font-family}
        font_size 18
        initial_window_height 40c
        initial_window_width 160c
        italic_font auto
        remember_window_size no
        tab_bar_edge top
        tab_bar_min_tabs 0
        tab_bar_style powerline
        tab_powerline_style slanted
      '';

      ".config/oh-my-posh/config.json".text = ''
        {
          "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
          "blocks": [
            {
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "background": "red",
                  "foreground": "white",
                  "powerline_symbol": "\ue0b0",
                  "style": "powerline",
                  "template": " {{ if .Env.DEVBOX_SHELL_ENABLED }}\uf489  Devbox{{ end }} ",
                  "type": "text"
                },
                {
                  "background": "magenta",
                  "foreground": "black",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "time_format": "3:04:05 PM"
                  },
                  "style": "powerline",
                  "template": " \uf017  {{ .CurrentDate | date .Format }} ",
                  "type": "time"
                },
                {
                  "background": "white",
                  "foreground": "black",
                  "powerline_symbol": "\ue0b0",
                  "style": "powerline",
                  "template": " {{ if .SSHSession }}\ueba9  {{ else }}\uea7a  {{ end }}{{ .UserName }}@{{ .HostName }} ",
                  "type": "session"
                },
                {
                  "background": "yellow",
                  "foreground": "black",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "folder_icon": "\uf115",
                    "folder_separator_icon": " \ue0b1 ",
                    "style": "agnoster"
                  },
                  "style": "powerline",
                  "template": " {{ .Path }} ",
                  "type": "path"
                },
                {
                  "background": "green",
                  "foreground": "black",
                  "properties": {
                    "fetch_status": true,
                    "fetch_upstream_icon": true
                  },
                  "powerline_symbol": "\ue0b0",
                  "style": "powerline",
                  "template": " {{ .UpstreamIcon }} {{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \uf0c7 {{ .StashCount }}{{ end }} ",
                  "type": "git"
                },
                {
                  "background": "blue",
                  "foreground": "white",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "context_aliases": {
                      "arn:aws:eks:eu-west-1:1234567890:cluster/posh": "posh"
                    }
                  },
                  "style": "powerline",
                  "template": " \udb84\udcfe {{ .Context }}{{ if .Namespace }} :: {{ .Namespace }}{{ end }} ",
                  "type": "kubectl"
                }
              ],
              "type": "prompt"
            },
            {
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "foreground_templates": [
                    "{{ if eq .Code 0 }}cyan{{ else }}red{{ end }}"
                  ],
                  "style": "plain",
                  "template": "\u276f ",
                  "type": "text"
                }
              ],
              "type": "prompt"
            }
          ],
          "console_title_template": "{{ .Folder }}",
          "transient_prompt": {
            "background": "transparent",
            "foreground_templates": [
              "{{ if eq .Code 0 }}cyan{{ else }}red{{ end }}"
            ],
            "template": "\u276f "
          },
          "version": 2
        }
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
          family = '${font-family}',
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

      ".zshrc".text = ''
        for ALIASES in "''${HOME}/.zsh_aliases_"*
        do
          source "''${ALIASES}"
        done

        for ENVS in "''${HOME}/.zsh_envs_"*
        do
          source "''${ENVS}"
        done

        autoload run-help
        unalias run-help

        setopt HIST_FCNTL_LOCK
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_SPACE
        setopt SHARE_HISTORY

        unsetopt EXTENDED_HISTORY

        for PROFILE in ''${(z)NIX_PROFILES}
        do
          fpath+=(''${PROFILE}/share/zsh/site-functions ''${PROFILE}/share/zsh/vendor-completions ''${PROFILE}/share/zsh/''${ZSH_VERSION}/functions)
        done

        typeset -U cdpath fpath manpath path

        # 1Password CLI
        source "''${HOME}/.config/op/plugins.sh"

        # Oh My Posh
        eval "$(${pkgs.unstable.oh-my-posh}/bin/oh-my-posh init zsh --config ''${HOME}/.config/oh-my-posh/config.json)"

        # Zinit
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

        [ ! -d ''${ZINIT_HOME} ] && mkdir -p "''$(dirname ''${ZINIT_HOME})"
        [ ! -d ''${ZINIT_HOME}/.git ] && git clone 'https://github.com/zdharma-continuum/zinit.git' "''${ZINIT_HOME}"

        source "''${ZINIT_HOME}/zinit.zsh"

        ## Oh My Zsh Plugins
        zinit snippet OMZP::git
        zinit snippet OMZP::kubectl

        # Fastfetch
        fastfetch
      '';

      ".zsh_aliases_common".text = ''
        alias 'clean'='sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old'
        alias 'code'='codium'
        alias 'dig'='drill'
        alias 'dsc'='docker stop $(docker ps --quiet)'
        alias 'dsp'='docker system prune --all --force --volumes'
        alias 'failed'='systemctl list-units --state failed'
        alias 'fl'='flatpak list'
        alias 'fla'='flatpak list --app'
        alias 'fr'='sudo flatpak repair'
        alias 'fuu'='flatpak uninstall --unused'
        alias 'grpo'='git remote prune origin'
        alias 'help'='run-help'
        alias 'htop'='btop'
        alias 'installed'='nix-store --query --references /run/current-system/sw | sed "s/^\/nix\/store\/[[:alnum:]]\{32\}-//" | sort'
        alias 'k9s'='k9s --readonly'
        alias 'ls'='eza --git --git-repos --group --group-directories-first --icons --time-style long-iso'
        alias 'ncu'='sudo nix-channel --update'
        alias 'nrd'='sudo nixos-rebuild dry-activate'
        alias 'nrs'='sudo nixos-rebuild switch'
        alias 'nso'='nix store optimise'
        alias 'nu'='sudo nix-channel --update && sudo nixos-rebuild switch'
        alias 'ping'='trip'
        alias 'sc'='scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h265'
        alias 'sc4'='scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h264'
        alias 'speedtest'='speedtest --secure --share'
        alias 'tail'='tspin'
        alias 'top'='btop'
        alias 'tracepath'='trip'
        alias 'tree'='tree -aghpuCD'
      '';

      ".zsh_envs_common".text = ''
        HISTSIZE="10000"
        SAVEHIST="10000"

        export AWS_PAGER=""
        export AWS_SDK_LOAD_CONFIG="true"
        export EXA_ICON_SPACING="2"
        export PATH="''${PATH}''${PATH:+:}''${GOBIN}"
        export SSH_AUTH_SOCK="''${HOME}/.1password/agent.sock"
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
              'https://${webdav-server}/iso-images/windows/Win11_23H2_English_International_x64_Oct_2023_Tiny.iso'

            curl \
              --location \
              --output 'windows-11/virtio-win.iso' \
              'https://${webdav-server}/iso-images/windows/virtio-win-0.1.248.iso'
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
          disk_size="64G"
          fixed_iso="windows-11/virtio-win.iso"
          guest_os="windows"
          iso="windows-11/latest-windows-11.iso"
          preallocation="metadata"
          secureboot="on"
          tpm="on"
        '';
      };
    };

    home.sessionPath = [
      "\${GOBIN}"
    ];

    programs = {
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
              "browser.startup.homepage" = browser-homepage;
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
              "font.name.monospace.x-western" = font-family;
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

          "openmediavault" = {
            hostname = "openmediavault.${tailnet-name}";
            user = "jcardoso";
          };

          "${tailnet-server}" = {
            hostname = "${tailnet-server}.${tailnet-name}";
            user = "jcardoso";
          };
        };

        serverAliveInterval = 60;
      };

      vscode = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enable
        enable = true;
        package = pkgs.vscodium;

        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "editor.bracketPairColorization.enabled" = true;
          "editor.fontFamily" = font-family;
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
          "terminal.integrated.fontFamily" = font-family;
          "terminal.integrated.fontSize" = 18;
          "terminal.integrated.fontWeight" = "normal";
          "update.mode" = "none";
          "window.zoomLevel" = 1;
          "workbench.editor.empty.hint" = "hidden";
          "workbench.startupEditor" = "none";
        };
      };
    };
  };
}
