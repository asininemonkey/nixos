{
  custom,
  lib,
  ...
}: {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      autosuggestion.enable = true;
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;

      envExtra = ''
        export AWS_ACCESS_KEY_ID=""
        export AWS_PAGER=""
        export AWS_REGION="eu-west-1"
        export AWS_SDK_LOAD_CONFIG="true"
        export AWS_SECRET_ACCESS_KEY=""
        export EXA_ICON_SPACING="2"
        export SSH_AUTH_SOCK="''${HOME}/${custom.password-manager.ssh-agent}"
      '';

      history = {
        append = true;
        saveNoDups = true;
      };

      initContent = let
        initFirst = lib.mkOrder 500 ''
          ### initFirst ###

          # Use Bash For TTY
          if [ $(tput colors) != "256" ]
          then
            exec bash --login
          fi

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

          typeset -U cdpath fpath manpath path
          zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

          autoload run-help
          unalias run-help
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
        gcw = "git commit --message WIP";
        grit = "git rebase --interactive --root";
        grpo = "git remote prune origin";
        help = "run-help";
        htop = "btop";
        ls = "eza --git --git-repos --group --group-directories-first --icons --time-style long-iso";
        nfa = "nix flake archive --refresh --verbose --verbose /etc/nixos";
        nfu = "nix flake update --flake /etc/nixos";
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
