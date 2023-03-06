{ config, pkgs, ... }:

{
  home-manager.users.jcardoso = { config, lib, ... }: with lib.hm.gvariant; {
    dconf.settings = { # https://rycee.gitlab.io/home-manager/options.html#opt-dconf.settings
      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };

      "io/github/celluloid-player/celluloid" = {
        mpv-options = "hwdec=vaapi";
      };

      "org/gnome/boxes" = {
        first-run = false;
      };

      "org/gnome/calculator" = {
        button-mode = "advanced";
        refresh-interval = 86400;
        source-currency = "GBP";
        target-currency = "EUR";
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/pixels-d.webp";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/pixels-d.webp";
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
        document-font-name = "Vegur 12";
        font-name = "Vegur 12";
        gtk-theme = "Adwaita-dark";
        icon-theme = "Papirus-Dark";
        monospace-font-name = "Iosevka 12";
        text-scaling-factor = 1.1;
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
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/pixels-d.webp";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        titlebar-font = "Vegur Bold 12";
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
          "gTile@vibou"
          "just-perfection-desktop@just-perfection"
          "lockkeys@vaina.lt"
          "noannoyance@daase.net"
          "quick-settings-tweaks@qwreey"
          "ssm-gnome@lgiki.net"
          "tiling-assistant@leleat-on-github"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "window-list@gnome-shell-extensions.gcampax.github.com"
        ];

        favorite-apps = [
          "1password.desktop"
          "Alacritty.desktop"
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "obsidian.desktop"
          "signal-desktop.desktop"
          "codium.desktop"
        ];
      };

      "org/gnome/shell/extensions/alphabetical-app-grid" = {
        folder-order-position = "end";
        show-favourite-apps = true;
      };

      "org/gnome/shell/extensions/gtile" = {
        grid-sizes = "16x16,12x12,8x8,4x4";

        show-toggle-tiling = [
          "<Super>z"
        ];

        theme = "Minimal Dark";
      };

      "org/gnome/shell/extensions/just-perfection" = {
        accessibility-menu = false;
      };

      "org/gnome/shell/extensions/noannoyance" = {
        by-class = [
          "Signal"
        ];
      };

      "org/gnome/shell/extensions/quick-settings-tweaks" = {
        input-always-show = true;
        input-show-selected = true;
        output-show-selected = true;
      };

      "org/gnome/shell/extensions/simple-system-monitor" = {
        cpu-usage-text = "CPU";
        font-family = "Vegur";
        font-size = "18";
        font-weight = 500;
        is-download-speed-enable = false;
        is-upload-speed-enable = false;
        item-separator = "⋮"; # https://unicode-table.com/en/22EE/
        memory-usage-text = "Mem";
        show-extra-spaces = false;
      };

      "org/gnome/shell/extensions/tiling-assistant" = {
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

      "org/gnome/software" = {
        first-run = false;
      };

      "org/gnome/system/location" = {
        enabled = true;
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      "org/gtk/settings/file-chooser" = {
        sort-directories-first = true;
      };
    };

    home.file = { # https://rycee.gitlab.io/home-manager/options.html#opt-home.file
      ".asdf/asdf.sh".source = "${pkgs.unstable.asdf-vm}/share/asdf-vm/asdf.sh";
      ".asdf/lib".source = "${pkgs.unstable.asdf-vm}/share/asdf-vm/lib";

      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/jcardoso/.var/app Flatpak Data
        smb://intel-nuc/roms roms (intel-nuc)
        smb://intel-nuc/temporary temporary (intel-nuc)
        smb://admin@pi-server/admin admin (pi-server)
        smb://admin@pi-server/roms-full roms-full (pi-server)
        smb://pi-server/temporary temporary (pi-server)
      '';

      ".config/obsidian/b46cab08ad4f3833.json".text = ''
        {
            "devTools": false,
            "height": 900,
            "isMaximized": false,
            "width": 1600,
            "zoom": 1.25
        }
      '';

      ".config/obsidian/cda1bce76c7db627.json".text = ''
        {
            "devTools": false,
            "height": 900,
            "isMaximized": false,
            "width": 1600,
            "zoom": 1.25
        }
      '';

      ".config/obsidian/obsidian.json".text = ''
        {
          "vaults": {
            "cda1bce76c7db627": {
              "path": "/home/jcardoso/Documents/Source/Private/obsidian/Private",
              "ts": 1672531200000
            },
            "b46cab08ad4f3833": {
              "path": "/home/jcardoso/Documents/Source/Private/obsidian/Work",
              "ts": 1672531200000
            }
          }
        }
      '';

      ".config/macchina/macchina.toml".text = ''
        theme = "custom"
      '';

      # wget https://raw.githubusercontent.com/nixos/nixos-artwork/master/logo/nix-snowflake.svg
      # inkscape --export-filename nix-snowflake.png nix-snowflake.svg
      # ascii-image-converter --braille --color --dither --height 16 nix-snowflake.png
      ".config/macchina/themes/custom.ascii".text = ''

        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⢐[0m[38;2;82;119;195m⠐[0m[38;2;80;116;190m⢐[0m[38;2;30;44;72m⠀[0m[38;2;1;1;3m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;2;2m⠀[0m[38;2;30;44;54m⠐[0m[38;2;123;182;223m⡱[0m[38;2;125;185;227m⡱[0m[38;2;125;184;226m⡱[0m[38;2;108;160;196m⡡[0m[38;2;0;1;1m⡀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⢠[0m[38;2;124;183;225m⢪[0m[38;2;124;183;224m⢪[0m[38;2;37;55;67m⢂[0m[38;2;1;2;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;2m⠀[0m[38;2;44;64;106m⠐[0m[38;2;81;117;192m⡈[0m[38;2;81;118;193m⠄[0m[38;2;78;115;188m⠂[0m[38;2;48;70;114m⢂[0m[38;2;0;1;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;9;14;17m⠀[0m[38;2;125;184;226m⢱[0m[38;2;126;186;228m⢱[0m[38;2;125;185;227m⢱[0m[38;2;123;182;223m⢱[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⢜[0m[38;2;126;186;228m⢜[0m[38;2;126;185;227m⢜[0m[38;2;126;185;227m⢜[0m[38;2;126;184;227m⠈[0m[38;2;0;1;1m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;2m⠀[0m[38;2;24;35;58m⠀[0m[38;2;80;116;190m⢈[0m[38;2;80;117;191m⠨[0m[38;2;79;113;186m⠀[0m[38;2;64;93;153m⢂[0m[38;2;0;0;1m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠈[0m[38;2;126;186;228m⢎[0m[38;2;126;186;228m⢎[0m[38;2;126;186;228m⢪[0m[38;2;125;184;226m⢪[0m[38;2;125;184;226m⢢[0m[38;2;126;184;227m⢣[0m[38;2;126;184;226m⢱[0m[38;2;126;183;226m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;2m⠀[0m[38;2;14;20;33m⠌[0m[38;2;81;118;194m⡀[0m[38;2;82;119;195m⢂[0m[38;2;82;119;195m⠐[0m[38;2;82;119;195m⡐[0m[38;2;79;115;188m⢀[0m[38;2;80;117;191m⠂[0m[38;2;80;115;189m⠡[0m[38;2;79;114;187m⠐[0m[38;2;78;113;185m⡀[0m[38;2;77;112;183m⢂[0m[38;2;76;111;181m⠁[0m[38;2;76;109;179m⠡[0m[38;2;74;106;174m⠈[0m[38;2;37;53;93m⠄[0m[38;2;125;184;226m⢃[0m[38;2;126;184;227m⢇[0m[38;2;126;184;226m⢇[0m[38;2;126;183;226m⢕[0m[38;2;125;182;224m⠕[0m[38;2;119;172;213m⠁[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠄[0m[38;2;0;0;0m⡀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;1;3m⠀[0m[38;2;28;41;68m⠈[0m[38;2;80;117;191m⠄[0m[38;2;81;118;194m⠂[0m[38;2;81;118;194m⠂[0m[38;2;81;118;194m⠂[0m[38;2;81;118;194m⠐[0m[38;2;80;117;192m⠠[0m[38;2;79;116;190m⠈[0m[38;2;79;114;188m⠄[0m[38;2;78;113;186m⠡[0m[38;2;77;112;184m⠐[0m[38;2;76;111;182m⠀[0m[38;2;75;110;180m⠌[0m[38;2;75;108;178m⠠[0m[38;2;74;107;176m⠁[0m[38;2;73;105;171m⠐[0m[38;2;54;78;133m⠀[0m[38;2;125;181;224m⢣[0m[38;2;126;182;225m⢱[0m[38;2;126;182;225m⢑[0m[38;2;126;181;224m⢍[0m[38;2;4;7;8m⢄[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;1m⠠[0m[38;2;82;119;195m⢁[0m[38;2;82;119;195m⠐[0m[38;2;0;0;0m⡀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⢀[0m[38;2;112;157;195m⢕[0m[38;2;114;161;204m⢜[0m[38;2;113;161;206m⢜[0m[38;2;108;156;203m⠈[0m[38;2;9;13;17m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;115;166;205m⠱[0m[38;2;125;178;221m⡑[0m[38;2;126;180;223m⡅[0m[38;2;125;177;221m⡇[0m[38;2;22;31;39m⢆[0m[38;2;2;3;4m⢀[0m[38;2;9;14;22m⠨[0m[38;2;81;118;193m⠐[0m[38;2;82;119;195m⡀[0m[38;2;81;118;194m⠂[0m[38;2;79;115;188m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠠[0m[38;2;126;179;223m⡊[0m[38;2;126;179;222m⡎[0m[38;2;126;178;222m⡢[0m[38;2;126;178;222m⠁[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;2;2m⠀[0m[38;2;92;131;162m⠱[0m[38;2;124;175;219m⡑[0m[38;2;126;178;221m⢕[0m[38;2;125;176;221m⢁[0m[38;2;27;39;64m⢀[0m[38;2;81;117;191m⠂[0m[38;2;82;119;195m⠡[0m[38;2;81;117;192m⠠[0m[38;2;65;95;156m⠁[0m[38;2;0;1;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⢀[0m[38;2;72;106;130m⢎[0m[38;2;73;107;132m⢇[0m[38;2;73;106;132m⢇[0m[38;2;73;106;131m⢇[0m[38;2;73;106;130m⢇[0m[38;2;72;104;129m⢇[0m[38;2;71;103;127m⢣[0m[38;2;126;181;224m⢣[0m[38;2;126;181;224m⠣[0m[38;2;126;180;223m⡣[0m[38;2;126;180;223m⠃[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;2;2m⠀[0m[38;2;58;82;105m⠈[0m[38;2;117;168;218m⠊[0m[38;2;37;55;94m⠄[0m[38;2;79;114;187m⢐[0m[38;2;80;116;191m⠈[0m[38;2;80;116;191m⠄[0m[38;2;74;108;177m⠡[0m[38;2;55;81;133m⠈[0m[38;2;55;81;133m⠄[0m[38;2;54;79;130m⠡[0m[38;2;54;79;130m⠁[0m[38;2;10;14;24m⡂[0m
        [38;2;104;154;189m⠑[0m[38;2;125;184;226m⢕[0m[38;2;126;185;228m⢕[0m[38;2;126;185;227m⢕[0m[38;2;126;184;227m⢕[0m[38;2;126;184;226m⠕[0m[38;2;126;184;226m⡕[0m[38;2;126;183;226m⢕[0m[38;2;126;183;225m⢕[0m[38;2;126;182;225m⢕[0m[38;2;126;182;225m⠁[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;1m⡀[0m[38;2;63;90;149m⢂[0m[38;2;77;111;182m⠈[0m[38;2;79;114;186m⠄[0m[38;2;79;114;187m⢂[0m[38;2;79;115;188m⠡[0m[38;2;80;116;189m⠈[0m[38;2;80;116;190m⠄[0m[38;2;81;117;191m⠡[0m[38;2;81;118;193m⢈[0m[38;2;81;118;193m⠐[0m[38;2;82;119;195m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;10;16;19m⡰[0m[38;2;125;184;226m⡱[0m[38;2;126;185;227m⡱[0m[38;2;125;183;226m⡱[0m[38;2;113;166;202m⠁[0m[38;2;68;98;162m⠄[0m[38;2;72;105;171m⠡[0m[38;2;12;17;27m⢀[0m[38;2;0;0;1m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠠[0m[38;2;73;105;172m⠐[0m[38;2;75;109;180m⢀[0m[38;2;77;111;182m⠂[0m[38;2;76;111;181m⠁[0m[38;2;7;11;18m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;2;2m⠠[0m[38;2;47;70;86m⡸[0m[38;2;124;183;225m⡸[0m[38;2;126;186;228m⡸[0m[38;2;124;183;225m⡸[0m[38;2;94;140;171m⠀[0m[38;2;62;90;145m⠁[0m[38;2;74;106;174m⠌[0m[38;2;75;109;178m⡀[0m[38;2;75;107;176m⢂[0m[38;2;29;42;68m⠀[0m[38;2;1;1;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠠[0m[38;2;74;107;175m⠁[0m[38;2;75;108;176m⠨[0m[38;2;75;108;177m⢀[0m[38;2;75;109;178m⠀[0m[38;2;0;0;1m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;1m⠀[0m[38;2;17;26;32m⠀[0m[38;2;125;184;226m⢕[0m[38;2;126;186;228m⢕[0m[38;2;124;183;224m⠕[0m[38;2;63;94;115m⠁[0m[38;2;1;2;2m⠀[0m[38;2;0;1;2m⠀[0m[38;2;44;63;102m⠀[0m[38;2;75;109;178m⡐[0m[38;2;77;111;182m⠠[0m[38;2;75;110;180m⢈[0m[38;2;48;70;114m⢀[0m[38;2;24;35;47m⠢[0m[38;2;23;33;42m⡰[0m[38;2;24;34;42m⡠[0m[38;2;24;34;42m⡢[0m[38;2;24;34;42m⡢[0m[38;2;24;34;42m⢢[0m[38;2;24;34;43m⢢[0m[38;2;31;45;60m⢰[0m[38;2;29;43;56m⢰[0m[38;2;29;43;56m⢐[0m[38;2;29;42;55m⢆[0m[38;2;22;33;40m⢆[0m[38;2;23;35;42m⢆[0m[38;2;23;35;42m⢆[0m[38;2;23;35;42m⢆[0m[38;2;23;35;42m⢆[0m[38;2;23;35;42m⠆[0m[38;2;18;27;33m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠈[0m[38;2;125;185;227m⠎[0m[38;2;32;47;58m⠀[0m[38;2;1;2;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;1;2m⠀[0m[38;2;36;52;84m⠐[0m[38;2;76;111;183m⢐[0m[38;2;79;114;187m⠠[0m[38;2;78;114;186m⠐[0m[38;2;60;89;148m⡀[0m[38;2;121;172;220m⢢[0m[38;2;126;177;221m⠣[0m[38;2;126;178;222m⡪[0m[38;2;126;179;223m⡊[0m[38;2;126;180;223m⡎[0m[38;2;126;181;224m⡪[0m[38;2;126;182;225m⡸[0m[38;2;126;183;226m⡨[0m[38;2;126;184;226m⡪[0m[38;2;126;185;227m⡪[0m[38;2;126;186;228m⡪[0m[38;2;126;186;228m⡪[0m[38;2;126;186;228m⡪[0m[38;2;126;186;228m⡪[0m[38;2;124;183;225m⡪[0m[38;2;92;137;168m⠀[0m[38;2;1;2;2m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;2m⢀[0m[38;2;49;72;116m⠈[0m[38;2;77;113;185m⡐[0m[38;2;80;116;189m⢀[0m[38;2;80;116;190m⠂[0m[38;2;80;117;191m⠡[0m[38;2;80;116;191m⠐[0m[38;2;78;114;188m⡀[0m[38;2;10;14;18m⠀[0m[38;2;11;16;20m⠀[0m[38;2;11;16;20m⠀[0m[38;2;12;17;22m⠀[0m[38;2;12;17;22m⠈[0m[38;2;126;182;225m⢪[0m[38;2;126;183;226m⠪[0m[38;2;126;184;226m⡪[0m[38;2;126;185;227m⡪[0m[38;2;7;11;14m⡀[0m[38;2;11;16;20m⠀[0m[38;2;12;18;22m⠀[0m[38;2;12;18;23m⠀[0m[38;2;10;15;18m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;1m⡀[0m[38;2;68;100;162m⢀[0m[38;2;79;115;189m⢂[0m[38;2;81;117;192m⠐[0m[38;2;80;117;191m⠀[0m[38;2;27;40;64m⠈[0m[38;2;82;119;195m⠄[0m[38;2;82;119;195m⠡[0m[38;2;82;119;195m⠐[0m[38;2;82;119;195m⡀[0m[38;2;0;0;0m⠄[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;126;183;226m⢃[0m[38;2;126;184;226m⢇[0m[38;2;126;185;227m⢇[0m[38;2;125;185;227m⢝[0m[38;2;4;6;8m⢄[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m
        [38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;72;104;169m⠀[0m[38;2;80;117;191m⠐[0m[38;2;82;118;194m⠠[0m[38;2;81;118;193m⠈[0m[38;2;9;13;21m⠀[0m[38;2;0;0;1m⠀[0m[38;2;0;0;0m⠈[0m[38;2;82;119;195m⠀[0m[38;2;82;119;195m⠡[0m[38;2;82;119;195m⠐[0m[38;2;82;119;195m⡈[0m[38;2;0;0;0m⠄[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;1;1m⠀[0m[38;2;116;170;209m⠘[0m[38;2;125;183;225m⢜[0m[38;2;126;186;228m⢜[0m[38;2;125;184;226m⠌[0m[38;2;3;5;6m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m

      '';

      ".config/macchina/themes/custom.toml".text = ''
        # https://github.com/Macchina-CLI/macchina/wiki/Theme-Documentation

        padding = 0
        separator = "→" # https://unicode-table.com/en/2192/

        [bar]
        glyph = "•" # https://unicode-table.com/en/2022/
        symbol_close = ")"
        symbol_open = "("
        visible = true

        [box]
        title = ""
        visible = true

        [box.inner_margin]
        x = 1
        y = 0

        [custom_ascii]
        path = "~/.config/macchina/themes/custom.ascii"

        [keys]
        host = "Host"
        kernel = "Kernel"
        os = "OS"
        machine = "Machine"
        de = "DE"
        wm = "WM"
        distro = "Distro"
        packages = "Packages"
        terminal = "Terminal"
        shell = "Shell"
        local_ip = "Local IP"
        uptime = "Uptime"
        memory = "Memory"
        battery = "Battery"
        backlight = "Backlight"
        resolution = "Resolution"
        cpu_load = "CPU Load"
        cpu = "CPU"

        [palette]
        type = "Full"
        visible = true
      '';

      ".kube/config".text = "";

      ".local/share/applications/btop.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/cups.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/mpv.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      ".local/share/applications/umpv.desktop".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";

      ".ssh/authorized_keys".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYDHpVs4nKaLG+tnLUGH+4Ivnq9ELPW0S3W/uJhxNd/
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

      "Documents/Virtual Machines/quickemu/nixos-22.11-minimal.clean" = {
        executable = true;

        text = ''
          #!/usr/bin/env bash
          rm --force nixos-22.11-minimal/.lock
          rm --force nixos-22.11-minimal/*.fd
          rm --force nixos-22.11-minimal/*.qcow2
          rm --force nixos-22.11-minimal/*.sock*
          rm --force nixos-22.11-minimal/nixos-22.11-minimal.*
        '';
      };

      "Documents/Virtual Machines/quickemu/nixos-22.11-minimal.conf" = {
        executable = true;

        text = ''
          #!/run/current-system/sw/bin/quickemu --vm
          cpu_cores="4"
          disk_img="nixos-22.11-minimal/disk.qcow2"
          disk_size="32G"
          guest_os="linux"
          iso="nixos-22.11-minimal/latest-nixos-minimal-x86_64-linux.iso"
          preallocation="metadata"
        '';
      };

      "Documents/Virtual Machines/quickemu/windows-11.clean" = {
        executable = true;

        text = ''
          #!/usr/bin/env bash
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
      alacritty = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.alacritty.enable
        enable = true;

        settings = {
          colors = {
            bright = {
              black = "#545454";
              blue = "#00afff";
              cyan = "#50cdfe";
              green = "#b0e05e";
              magenta = "#af87ff";
              red = "#f5669c";
              white = "#ffffff";
              yellow = "#fef26c";
            };

            normal = {
              black = "#121212";
              blue = "#0f7fcf";
              cyan = "#42a7cf";
              green = "#97e123";
              magenta = "#8700ff";
              red = "#fa2573";
              white = "#bbbbbb";
              yellow = "#dfd460";
            };

            primary = {
              background = "#121212";
              foreground = "#bbbbbb";
            };

            selection = {
              background = "#b4d5ff";
              text = "#121212";
            };
          };

          cursor.style.blinking = "On";
          env.TERM = "xterm-256color";

          font = {
            normal.family = "Iosevka";
            size = 18;
          };

          key_bindings = [
            {
              action = "ClearHistory";
              key = "Delete";
              mods = "Control";
            }
            {
              action = "SpawnNewInstance";
              key = "N";
              mods = "Control|Shift";
            }
          ];

          scrolling.history = 100000;
          selection.save_to_clipboard = true;

          window = {
            dimensions = {
              columns = 160;
              lines = 32;
            };

            opacity = 0.9;

            padding = {
              x = 5;
              y = 5;
            };
          };
        };
      };

      firefox = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.firefox.enable
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
              "browser.startup.homepage" = "https://start.duckduckgo.com/?kad=en_GB&kak=-1&kaq=-1&kau=-1&kl=uk-en&kn=1";
              "browser.tabs.loadInBackground" = false;
              "browser.toolbars.bookmarks.visibility" = "always";
              "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"screenshot-button\",\"fxa-toolbar-menu-button\",\"customizableui-special-spring4\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\"],\"dirtyAreaCache\":[\"nav-bar\"],\"currentVersion\":18,\"newElementCount\":4}";
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.firstRunURL" = "";
              "dom.disable_open_during_load" = true;
              "dom.security.https_only_mode" = true;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "font.minimum-size.x-western" = 18;
              "font.name.monospace.x-western" = "Iosevka";
              "font.size.monospace.x-western" = 18;
              "media.eme.enabled" = true;
              "network.cookie.lifetimePolicy" = 2;
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

      git = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
        diff-so-fancy.enable = true;
        enable = true;

        extraConfig = {
          url."ssh://git@github.com".insteadOf = "https://github.com";
        };

        userEmail = "65740649+asininemonkey@users.noreply.github.com";
        userName = "Jose Cardoso";
      };

      go = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.go.enable
        enable = true;
        goBin = "Documents/Source/Go/bin";
        goPath = "Documents/Source/Go";
      };

      mpv = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.mpv.enable
        config = {
          gpu-context = "wayland";
          hwdec = "vaapi";
        };

        enable = true;
      };

      ssh = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
        enable = true;

        extraConfig = ''
          IdentityAgent ~/.1password/agent.sock
        '';

        matchBlocks = {
          "aur.archlinux.org" = {
            user = "aur";
          };

          "beelink" = {
            user = "retro";
          };

          "intel-nuc" = {
            dynamicForwards = [
              {
                address = "127.0.0.1";
                port = 3128;
              }
            ];

            user = "jcardoso";
          };

          "msi-pro" = {
            dynamicForwards = [
              {
                address = "127.0.0.1";
                port = 3128;
              }
            ];

            user = "jcardoso";
          };

          "pi-server" = {
            user = "alarm";
          };
        };

        serverAliveInterval = 60;
      };

      starship = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
        enable = true;

        settings = {
          character = {
            error_symbol = "[→](bold red)"; # https://unicode-table.com/en/2192/
            success_symbol = "[→](bold green)"; # https://unicode-table.com/en/2192/
          };

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
            " "
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

      vscode = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.vscode.enable
        enable = true;

        extensions = (with pkgs.vscode-extensions; [
          bungcip.better-toml
          eamodio.gitlens
          esbenp.prettier-vscode
          hashicorp.terraform
          jnoortheen.nix-ide
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          # ms-vscode-remote.remote-containers
          # rangav.vscode-thunder-client
          redhat.vscode-yaml
          # richie5um2.vscode-sort-json
        ]) ++ (with pkgs.unstable.vscode-extensions; [
          irongeek.vscode-env
        ]);

        package = pkgs.unstable.vscodium;

        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "editor.bracketPairColorization.enabled" = true;
          "editor.fontFamily" = "Iosevka";
          "editor.fontLigatures" = true;
          "editor.fontSize" = 18;
          "editor.fontWeight" = "normal";
          "editor.guides.bracketPairs" = "active";
          "editor.renderControlCharacters" = true;
          "editor.renderWhitespace" = "all";
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "redhat.telemetry.enabled" = false;
          "scm.defaultViewMode" = "tree";
          "security.workspace.trust.untrustedFiles" = "open";
          "telemetry.telemetryLevel" = "off";
          "terminal.integrated.fontFamily" = "Iosevka";
          "terminal.integrated.fontSize" = 18;
          "terminal.integrated.fontWeight" = "normal";
          "update.mode" = "none";
          "window.zoomLevel" = 1;
          "workbench.editor.untitled.hint" = "hidden";
          "workbench.startupEditor" = "none";
        };
      };

      zsh = { # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zsh.enable
        enable = true;
        enableVteIntegration = true;

        envExtra = ''
          export PATH="''${PATH}''${PATH:+:}''${GOBIN}"
          export SSH_AUTH_SOCK="''${HOME}/.1password/agent.sock"
        '';

        initExtra = ''
          macchina
        '';

        oh-my-zsh = {
          enable = true;

          plugins = [
            "asdf"
            "docker"
            "git"
            "kubectl"
          ];
        };

        shellAliases = {
          clean = "sudo nix-collect-garbage --delete-old";
          code = "codium";
          dig = "drill";
          dsp = "docker system prune --all --force --volumes";
          grpo = "git remote prune origin";
          htop = "btop";
          installed = "nix-store --query --references /run/current-system/sw";
          ls = "ls --all --color=always -l";
          nrd = "sudo nixos-rebuild dry-activate";
          nrs = "sudo nixos-rebuild switch";
          ping = "prettyping";
          speedtest = "speedtest --secure --share";
          top = "btop";
          tree = "tree -aghpuCD";
        };
      };
    };
  };
}
