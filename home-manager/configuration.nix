{
  custom,
  lib,
  pkgs,
  ...
}: {
  home = {
    activation = {
      docker-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ''${DRY_RUN_CMD} mkdir --parents ''${VERBOSE_ARG} "''${HOME}/.docker"

        ''${DRY_RUN_CMD} cat << EOF > "''${HOME}/.docker/config.json"
        {
          "auths": {
            "https://index.docker.io/v1/": {}
          },
          "credHelpers": {
            "134474400229.dkr.ecr.eu-west-1.amazonaws.com": "ecr-login"
          },
          "credsStore": "secretservice"
        }
        EOF
      '';
    };

    homeDirectory = "/home/${custom.user.name}";
    stateVersion = "25.05";
    username = custom.user.name;
  };

  imports = [
    ./desktop-${custom.desktop}.nix
    ./fastfetch.nix
    ./files.nix
    ./firefox.nix
    ./ghostty.nix
    ./git.nix
    ./k9s.nix
    ./kubecolor.nix
    ./mangohud.nix
    ./oh-my-posh.nix
    ./ssh.nix
    ./zed-editor.nix
    ./zsh.nix
  ];

  programs = {
    awscli = {
      credentials = {
        "default" = {
          aws_access_key_id = "test";
          aws_secret_access_key = "test";
        };
      };

      enable = true;

      settings = {
        "default" = {
          output = "json";
          region = "eu-west-1";
        };
      };
    };

    btop = {
      enable = true;

      settings = {
        clock_format = "%I:%M:%S %p";
        presets = "cpu:0:default,proc:1:default mem:0:default";
      };
    };

    chromium = {
      dictionaries = [
        pkgs.hunspellDictsChromium.en-gb
      ];

      enable = true;

      extensions = [
        {
          id = custom.password-manager.chrome-extension;
        }
        {
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; # Dark Reader
        }
        {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; # uBlock Origin
        }
      ];
    };

    distrobox.enable = true;
    gh.enable = true;
    jq.enable = true;

    mpv = {
      config = {
        gpu-context = "wayland";
        hwdec =
          if custom.host.name == "asrock-x570-linux"
          then "nvdec"
          else "vaapi";
      };

      enable = true;
    };

    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        wlrobs
      ];
    };

    tmux.enable = true;
    yt-dlp.enable = true;
  };

  services.trayscale.enable = true;

  xdg = {
    desktopEntries = {
      "btop" = {
        name = "";
        noDisplay = true;
      };

      "cups" = {
        name = "";
        noDisplay = true;
      };

      "org.pulseaudio.pavucontrol" = {
        name = "";
        noDisplay = true;
      };

      "mpv" = {
        name = "";
        noDisplay = true;
      };

      "uuctl" = {
        name = "";
        noDisplay = true;
      };
    };

    userDirs = {
      createDirectories = true;
      enable = true;
    };
  };
}
