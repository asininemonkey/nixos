{
  custom,
  lib,
  ...
}: {
  programs = {
    fastfetch = {
      enable = true;

      settings = {
        display = {
          separator = " ";
        };

        logo = {
          height = 20;
          source = "/etc/nixos/logo.png";
          type = "kitty-direct";
          width = 46;
        };

        modules = [
          {
            key = "╭─ 󰌢 ";
            keyColor = "red";
            type = "host";
          }
          {
            key = "├─ 󰻠 ";
            keyColor = "red";
            type = "cpu";
          }
          {
            key = "├─ 󰍛 ";
            keyColor = "red";
            type = "gpu";
          }
          {
            key = "├─ 󰍹 ";
            keyColor = "red";
            type = "display";
          }
          {
            key = "├─  ";
            keyColor = "red";
            type = "disk";
          }
          {
            key = "╰─ 󰑭 ";
            keyColor = "red";
            type = "memory";
          }
          "break"
          {
            key = "╭─  ";
            keyColor = "green";
            type = "shell";
          }
          {
            key = "├─  ";
            keyColor = "green";
            type = "terminal";
          }
          {
            key = "├─  ";
            keyColor = "green";
            type = "de";
          }
          {
            key = "├─  ";
            keyColor = "green";
            type = "wm";
          }
          {
            key = "├─ 󰧨 ";
            keyColor = "green";
            type = "lm";
          }
          {
            key = "├─ 󰉼 ";
            keyColor = "green";
            type = "theme";
          }
          {
            key = "╰─ 󰀻 ";
            keyColor = "green";
            type = "icons";
          }
          "break"
          {
            format = "{1}@{2}";
            key = "╭─  ";
            keyColor = "blue";
            type = "title";
          }
          {
            key = "├─  ";
            keyColor = "blue";
            type = "os";
          }
          {
            format = "{1} {2}";
            key = "├─  ";
            keyColor = "blue";
            type = "kernel";
          }
          {
            key = "├─ 󰅐 ";
            keyColor = "blue";
            type = "uptime";
          }
          {
            compact = true;
            key = "╰─ 󰩟 ";
            keyColor = "blue";
            type = "localip";
          }
          "break"
        ];
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "catppuccin";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;

      envExtra = ''
        export AWS_ACCESS_KEY_ID=""
        export AWS_PAGER=""
        export AWS_REGION="eu-west-1"
        export AWS_SDK_LOAD_CONFIG="true"
        export AWS_SECRET_ACCESS_KEY=""
        export EXA_ICON_SPACING="2"
        export SSH_AUTH_SOCK="''${HOME}/.bitwarden-ssh-agent.sock"
      '';

      history = {
        append = true;
        saveNoDups = true;
      };

      initContent = let
        initFirst = lib.mkOrder 500 ''
          ### initFirst ###

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
        '';

        initEarly = lib.mkOrder 550 ''
          ### initEarly ###
        '';

        initMiddle = lib.mkOrder 1000 ''
          ### initMiddle ###
        '';

        initLast = lib.mkOrder 1500 ''
          ### initLast ###

          fastfetch
        '';
      in
        lib.mkMerge [initFirst initEarly initMiddle initLast];

      shellAliases = {
        clean = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
        dig = "drill";
        dsc = "docker stop $(docker ps --quiet)";
        dsp = "docker system prune --all --force --volumes";
        failed = "systemctl list-units --state failed";
        fl = "flatpak list";
        fla = "flatpak list --app";
        fr = "sudo flatpak repair";
        fuu = "flatpak uninstall --unused";
        grit = "git rebase --interactive --root";
        grpo = "git remote prune origin";
        help = "run-help";
        htop = "btop";
        ls = "eza --git --git-repos --group --group-directories-first --icons --time-style long-iso";
        nfa = "nix flake archive --refresh --verbose --verbose /etc/nixos";
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos#${custom.host.id}";
        nso = "nix store optimise";
        nv = "niri validate";
        open = "xdg-open";
        ping = "trip";
        sc = "scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h265";
        sc4 = "scrcpy --keyboard uhid --max-fps 60 --max-size 1920 --no-audio --video-codec h264";
        speedtest = "speedtest --secure --share";
        tail = "tspin";
        top = "btop";
        tracepath = "trip";
        tree = "tree -aghpuCD";
        tsaws = "sudo tailscale up --accept-routes --exit-node aws-eu-west-1 --operator ${custom.user.name} --reset --ssh";
        tshome = "sudo tailscale up --accept-routes --exit-node intel-nuc --operator ${custom.user.name} --reset --ssh";
        tsmch = "sudo tailscale up --accept-routes --exit-node ch-zrh-wg-001.mullvad.ts.net --operator ${custom.user.name} --reset --ssh";
        tsmgb = "sudo tailscale up --accept-routes --exit-node gb-glw-wg-001.mullvad.ts.net --operator ${custom.user.name} --reset --ssh";
        tsmie = "sudo tailscale up --accept-routes --exit-node ie-dub-wg-101.mullvad.ts.net --operator ${custom.user.name} --reset --ssh";
        tsmus = "sudo tailscale up --accept-routes --exit-node us-chi-wg-301.mullvad.ts.net --operator ${custom.user.name} --reset --ssh";
        tsreset = "sudo tailscale up --accept-routes --operator ${custom.user.name} --reset --ssh";
      };
    };
  };
}
