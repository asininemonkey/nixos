{
  pkgs,
  ...
}:

let
  browser-homepage = "https://start.duckduckgo.com/?kad=en_GB&kak=-1&kaq=-1&kau=-1&kl=uk-en&kn=1";

  colour-palette = { # https://colorkit.co/palette/ea3323-ff8b00-febb26-1eb253-017cf3-9c78fe/
    background = {
      one = "#ea3323";
      two = "#ff8b00";
      three = "#febb26";
      four = "#1eb253";
      five = "#017cf3";
      six = "#9c78fe";
    };

    foreground = "#000000";
  };

  font-family = "Iosevka Nerd Font";
  ghostty-shader = builtins.fetchurl "https://raw.githubusercontent.com/m-ahdal/ghostty-shaders/refs/heads/main/glow-rgbsplit-twitchy.glsl";
  tailnet-name = "fable-blues.ts.net";
  tailnet-server = "intel-nuc";
  webdav-server = "files.josecardoso.net";
in

{
  home-manager.users.jcardoso = { lib, ... }: with lib.hm.gvariant; {
    dconf.settings = { # https://nix-community.github.io/home-manager/options.xhtml#opt-dconf.settings
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    home.file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
      ".config/autostart/org.fkoehler.KTailctl.desktop".source = "${pkgs.unstable.ktailctl}/share/applications/org.fkoehler.KTailctl.desktop";

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
                "width": 46
            },
            "modules": [
                {
                    "key": "╭─ 󰌢 ",
                    "keyColor": "red",
                    "type": "host"
                },
                {
                    "key": "├─ 󰻠 ",
                    "keyColor": "red",
                    "type": "cpu"
                },
                {
                    "key": "├─ 󰍛 ",
                    "keyColor": "red",
                    "type": "gpu"
                },
                {
                    "key": "├─ 󰍹 ",
                    "keyColor": "red",
                    "type": "display"
                },
                {
                    "key": "├─  ",
                    "keyColor": "red",
                    "type": "disk"
                },
                {
                    "key": "╰─ 󰑭 ",
                    "keyColor": "red",
                    "type": "memory"
                },
                "break",
                {
                    "key": "╭─  ",
                    "keyColor": "green",
                    "type": "shell"
                },
                {
                    "key": "├─  ",
                    "keyColor": "green",
                    "type": "terminal"
                },
                {
                    "key": "├─  ",
                    "keyColor": "green",
                    "type": "de"
                },
                {
                    "key": "├─  ",
                    "keyColor": "green",
                    "type": "wm"
                },
                {
                    "key": "├─ 󰧨 ",
                    "keyColor": "green",
                    "type": "lm"
                },
                {
                    "key": "├─ 󰉼 ",
                    "keyColor": "green",
                    "type": "theme"
                },
                {
                    "key": "╰─ 󰀻 ",
                    "keyColor": "green",
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

      ".config/ghostty/config".text = ''
        # https://ghostty.org/docs/config/reference
        # background-opacity = 0.85 # Disabled by shaders
        bold-is-bright = true
        clipboard-paste-protection = true
        copy-on-select = clipboard
        cursor-style = block
        cursor-style-blink = true
        custom-shader = ${ghostty-shader}
        font-family = ${font-family}
        font-size = 16
        keybind = ctrl+shift+k=clear_screen
        theme = Builtin Tango Dark
        window-height = 35
        window-width = 155
      '';

      ".config/k9s/config.yaml".text = ''
        # https://k9scli.io/topics/config/
        k9s:
          readOnly: true
          refreshRate: 1
      '';

      ".config/k9s/plugins.yaml".text = ''
        # https://k9scli.io/topics/plugins/
        plugins:
          # https://github.com/derailed/k9s/blob/master/plugins/debug-container.yaml
          debug:
            args:
              - -c
              - "kubectl debug --image nicolaka/netshoot:v0.13 --kubeconfig ''${KUBECONFIG} --namespace ''${NAMESPACE} ''${POD} --share-processes --stdin --target ''${NAME} --tty -- bash"
            background: false
            command: bash
            confirm: true
            dangerous: true
            description: Add debug container
            scopes:
              - containers
            shortCut: Shift-D
          # https://github.com/derailed/k9s/blob/master/plugins/dive.yaml
          dive:
            args:
              - ''${COL-IMAGE}
            background: false
            command: dive
            confirm: false
            description: Dive image
            scopes:
              - containers
            shortCut: d
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
                  "background": "${colour-palette.background.one}",
                  "foreground": "${colour-palette.foreground}",
                  "powerline_symbol": "\ue0b0",
                  "style": "powerline",
                  "template": " {{ if .Env.DEVBOX_SHELL_ENABLED }}\uf489  Devbox{{ end }} ",
                  "type": "text"
                },
                {
                  "background": "${colour-palette.background.two}",
                  "foreground": "${colour-palette.foreground}",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "time_format": "3:04:05 PM"
                  },
                  "style": "powerline",
                  "template": " \uf017  {{ .CurrentDate | date .Format }} ",
                  "type": "time"
                },
                {
                  "background": "${colour-palette.background.three}",
                  "foreground": "${colour-palette.foreground}",
                  "powerline_symbol": "\ue0b0",
                  "style": "powerline",
                  "template": " {{ if .SSHSession }}\ueba9  {{ else }}\uea7a  {{ end }}{{ .UserName }}@{{ .HostName }} ",
                  "type": "session"
                },
                {
                  "background": "${colour-palette.background.four}",
                  "foreground": "${colour-palette.foreground}",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "folder_icon": "\uf115 ",
                    "folder_separator_icon": " \ue0b1 ",
                    "home_icon": "\udb84\udcb6 ",
                    "mapped_locations": {
                      "/etc/nixos": "\uf313 ",
                      "~/Documents": "\udb86\uddf7 ",
                      "~/Downloads": "\udb84\udce9 ",
                      "~/Music": "\udb84\udf5a ",
                      "~/Pictures": "\udb85\udf8b ",
                      "~/Public": "\udb84\udced ",
                      "~/Source": "\udb83\udd0a ",
                      "~/Templates": "\udb84\udee4 ",
                      "~/Videos": "\udb86\uddfb "
                    },
                    "style": "agnoster"
                  },
                  "style": "powerline",
                  "template": " {{ path .Path .Location }} ",
                  "type": "path"
                },
                {
                  "background": "${colour-palette.background.five}",
                  "foreground": "${colour-palette.foreground}",
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
                  "background": "${colour-palette.background.six}",
                  "foreground": "${colour-palette.foreground}",
                  "powerline_symbol": "\ue0b0",
                  "properties": {
                    "context_aliases": {
                      "arn:aws:eks:eu-west-1:1234567890:cluster/posh": "posh"
                    }
                  },
                  "style": "powerline",
                  "template": " \udb84\udcfe  {{ .Context }}{{ if .Namespace }} :: {{ .Namespace }}{{ end }} ",
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

      ".hidden".text = "Public";

      ".ssh/config" = { # https://github.com/nix-community/home-manager/issues/322
        onChange = ''
          cat .ssh/config_source > .ssh/config
          chmod 0600 .ssh/config
        '';

        target = ".ssh/config_source";
      };

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

        zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

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

        ## Oh My Zsh Libraries
        zinit snippet OMZL::history.zsh

        ## Oh My Zsh Plugins
        zinit snippet OMZP::git
        zinit snippet OMZP::kubectl

        # Fastfetch
        fastfetch
      '';

      ".zsh_aliases_common".text = ''
        alias 'clean'='sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old'
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
        alias 'ls'='eza --git --git-repos --group --group-directories-first --icons --time-style long-iso'
        alias 'ncu'='sudo nix-channel --update'
        alias 'nrd'='sudo nixos-rebuild dry-activate'
        alias 'nrs'='sudo nixos-rebuild switch'
        alias 'nso'='nix store optimise'
        alias 'nu'='sudo nix-channel --update && sudo nixos-rebuild switch'
        alias 'open'='xdg-open'
        alias 'ping'='trip'
        alias 'sc'='scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h265'
        alias 'sc4'='scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h264'
        alias 'speedtest'='speedtest --secure --share'
        alias 'tail'='tspin'
        alias 'top'='btop'
        alias 'tracepath'='trip'
        alias 'tree'='tree -aghpuCD'
        alias 'tsaws'='sudo tailscale up --accept-routes --exit-node aws-eu-west-1 --operator jcardoso --reset --ssh'
        alias 'tshome'='sudo tailscale up --accept-routes --exit-node intel-nuc --operator jcardoso --reset --ssh'
        alias 'tsmch'='sudo tailscale up --accept-routes --exit-node ch-zrh-wg-001.mullvad.ts.net --operator jcardoso --reset --ssh'
        alias 'tsmgb'='sudo tailscale up --accept-routes --exit-node gb-glw-wg-001.mullvad.ts.net --operator jcardoso --reset --ssh'
        alias 'tsmie'='sudo tailscale up --accept-routes --exit-node ie-dub-wg-101.mullvad.ts.net --operator jcardoso --reset --ssh'
        alias 'tsmus'='sudo tailscale up --accept-routes --exit-node us-chi-wg-301.mullvad.ts.net --operator jcardoso --reset --ssh'
      '';

      ".zsh_envs_common".text = ''
        HISTSIZE="10000"
        SAVEHIST="10000"

        export GOPATH="''${HOME}/Source/Go"

        export AWS_PAGER=""
        export AWS_SDK_LOAD_CONFIG="true"
        export EXA_ICON_SPACING="2"
        export GOBIN="''${GOPATH}/bin"
        export PATH="''${PATH}''${PATH:+:}''${GOBIN}"
        export SSH_AUTH_SOCK="''${HOME}/.1password/agent.sock"
        export TERM="xterm-256color"
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
                "defaultvolume": true,
                "disableautoplay": true,
                "hiderelated": true,
                "hideshorts": true,
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
                "selectqualityfullscreenon": true,
                "volume": 75
            },
            "version": "2.0.126.1"
        }
      '';

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
          # https://blog.gitbutler.com/how-git-core-devs-configure-git/
          branch.sort = "-committerdate";
          column.ui = "auto";
          commit.verbose = true;
          diff.algorithm = "histogram";
          diff.colorMoved = "plain";
          diff.mnemonicPrefix = true;
          diff.renames = true;
          fetch.all = true;
          fetch.prune = true;
          fetch.pruneTags = true;
          help.autocorrect = "prompt";
          push.autoSetupRemote = true;
          push.default = "simple";
          push.followTags = true;
          rebase.autoSquash = true;
          rebase.autoStash = true;
          rebase.updateRefs = true;
          rerere.autoupdate = true;
          rerere.enabled = true;
          tag.sort = "version:refname";

          commit.gpgsign = true;
          core.editor = "zeditor --wait";
          credential.helper = "libsecret";
          # diff.tool = "xxx";
          # difftool."xxx".cmd = "xxx --diff \${LOCAL} \${REMOTE} --wait";
          gpg."ssh".program = "/run/current-system/sw/bin/op-ssh-sign";
          gpg.format = "ssh";
          init.defaultBranch = "main";
          # merge.tool = "xxx";
          # mergetool."xxx".cmd = "xxx --wait \${MERGED}";
          pull.rebase = true;
          url."https://github.com".insteadOf = "ssh://git@github.com";
        };

        package = pkgs.gitFull;
        userEmail = "65740649+asininemonkey@users.noreply.github.com";
        userName = "Jose Cardoso";
      };

      mpv = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable
        config = {
          gpu-context = "wayland";
          hwdec = "vaapi";
        };

        enable = true;
      };

      ssh = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
        controlPath = "/tmp/%r@%n:%p";
        enable = true;

        extraConfig = ''
          IdentityAgent ~/.1password/agent.sock

          Host github.com
            IdentitiesOnly yes
            User git
        '';

        matchBlocks = {
          "aws-eu-west-1" = {
            hostname = "%h.${tailnet-name}";
            user = "ubuntu";
          };

          "${tailnet-server}" = {
            forwardAgent = true;
            hostname = "%h.${tailnet-name}";
            user = "jcardoso";
          };
        };

        serverAliveInterval = 60;
      };

      zed-editor = { # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zed-editor.enable
        enable = true;

        extensions = [
          "dockerfile"
          "env"
          "git-firefly"
          "make"
          "nix"
          "sql"
          "terraform"
          "toml"
        ];

        package = pkgs.unstable.zed-editor;

        userSettings = {
          assistant.version = "2";
          auto_update = false;
          buffer_font_family = font-family;
          buffer_font_size = 20;

          file_types = {
            Helm = [
              "**/helmfile.d/**/*.yaml"
              "**/helmfile.d/**/*.yml"
              "**/templates/**/*.tpl"
              "**/templates/**/*.yaml"
              "**/templates/**/*.yml"
            ];
          };

          tab_size = 2;

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          theme = {
            dark = "Andromeda";
            light = "Andromeda";
            mode = "dark";
          };

          ui_font_size = 20;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
}
