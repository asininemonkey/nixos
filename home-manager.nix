# https://nix-community.github.io/home-manager/options.html

{ config, lib, pkgs, ... }:

{
  home = {
    homeDirectory = "/Users/jcardoso";

    packages = with pkgs; [
      btop
      iosevka
      jq
      prettyping
    ];

    stateVersion = "22.11";
    username = "jcardoso";
  };

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
            columns = 128;
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

    git = {
      enable = true;
      userEmail = "65740649+asininemonkey@users.noreply.github.com";
      userName = "Jose Cardoso";
    };

    home-manager.enable = true;

    ssh = {
      enable = true;

      extraConfig = ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';

      matchBlocks = {
        "intel-nuc" = {
          dynamicForwards = [
            {
              address = "127.0.0.1";
              port = 3128;
            }
          ];

          user = "jcardoso";
        };
      };

      serverAliveInterval = 60;
    };

    starship = {
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

    vscode = {
      enable = true;

      extensions = with pkgs.vscode-extensions; [
        bungcip.better-toml
        eamodio.gitlens
        esbenp.prettier-vscode
        hashicorp.terraform
        irongeek.vscode-env
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        redhat.vscode-yaml
        # ms-vscode-remote.remote-containers
        # rangav.vscode-thunder-client
        # richie5um2.vscode-sort-json
      ];

      package = pkgs.vscodium;

      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.fontFamily" = "Iosevka";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 16;
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
        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.fontWeight" = "normal";
        "update.mode" = "none";
        "window.zoomLevel" = 1;
        "workbench.editor.untitled.hint" = "hidden";
        "workbench.startupEditor" = "none";
      };
    };

    zsh = {
      enable = true;
      enableVteIntegration = true;

      envExtra = ''
        [[ -o login ]] && export PATH='/usr/libexec:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'

        export SSH_AUTH_SOCK="''${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
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
        clean = "nix-collect-garbage --delete-old";
        code = "codium";
        grpo = "git remote prune origin";
        hms = "home-manager switch";
        htop = "btop";
        ping = "prettyping";
        top = "btop";
      };
    };
  };

  targets.darwin = {
    currentHostDefaults."com.apple.controlcenter".BatteryShowPercentage = true;

    defaults = {
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      "com.apple.desktopservices".DSDontWriteUSBStores = true;
      NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    };
  };
}
