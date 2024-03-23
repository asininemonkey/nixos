{
  config,
  lib,
  pkgs,
  ...
}:

let
  # background-image = builtins.fetchurl "https://www.xxx/yyy.zzz";
  background-image = "/run/current-system/sw/share/backgrounds/gnome/morphogenesis-d.svg";
  browser-homepage = "https://start.duckduckgo.com/?kad=en_GB&kak=-1&kaq=-1&kau=-1&kl=uk-en&kn=1";
  tailnet-name = "fable-blues.ts.net";
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
          "noannoyance-fork@vrba.dev"
          "tiling-assistant@leleat-on-github"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "Vitals@CoreCoding.com"
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

      "org/gnome/shell/extensions/just-perfection" = {
        accessibility-menu = false;
      };

      "org/gnome/shell/extensions/noannoyance-fork" = {
        ignore-list-by-class = [
          "Signal"
        ];
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

        center-window = [
          "<Super>c"
        ];

        enable-advanced-experimental-features = true;
        show-layout-panel-indicator = true;
        window-gap = 4;
      };

      "org/gnome/shell/extensions/vitals" = {
        hot-sensors = [
          "_memory_usage_"
          "_processor_usage_"
          "__temperature_avg__"
        ];

        menu-centered = true;
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
        smb://intel-nuc/emulation emulation
        smb://intel-nuc/iso-images iso-images
        smb://intel-nuc/macos macos
        smb://intel-nuc/media media
        smb://intel-nuc/miscellaneous miscellaneous
        smb://intel-nuc/rips rips
        smb://intel-nuc/temporary temporary
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
              'https://caddy.josecardoso.net/iso-images/windows/Win11_23H2_English_International_x64_Oct_2023.iso'

            curl \
              --location \
              --output 'windows-11/virtio-win.iso' \
              'https://caddy.josecardoso.net/iso-images/windows/virtio-win-0.1.240.iso'
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
        '';

        matchBlocks = {
          "home-assistant" = {
            hostname = "home-assistant.${tailnet-name}";
            user = "root";
          };

          "intel-nuc" = {
            hostname = "intel-nuc.${tailnet-name}";
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
        package = pkgs.unstable.vscodium;

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
          export EXA_ICON_SPACING="2"
          export PATH="''${PATH}''${PATH:+:}''${GOBIN}"
          export SSH_AUTH_SOCK="''${HOME}/.1password/agent.sock"
        '';

        initExtra = ''
          source "''${HOME}/.config/op/plugins.sh"
          macchina
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
          clean = "sudo nix-collect-garbage --delete-old";
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
          nrd = "sudo nix-channel --update && sudo nixos-rebuild dry-activate";
          nrs = "sudo nix-channel --update && sudo nixos-rebuild switch";
          nso = "nix --extra-experimental-features nix-command store optimise";
          ping = "trip";
          speedtest = "speedtest --secure --share";
          top = "btop";
          tracepath = "trip";
          tree = "tree -aghpuCD";
        };
      };
    };
  };
}
