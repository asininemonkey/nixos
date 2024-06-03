{
  config,
  lib,
  pkgs,
  ...
}:

let
  public-ssh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQowLl5Bzn87ig+Gs7Ze5kWODRTdHiD+V8sOCwOx16Z";
in

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
  ] else []) ++ (with pkgs; [
    chiaki
    darktable
    mangohud
    pupdate
  ]);

  home-manager.users.jcardoso = { config, lib, ... }: {
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Geary.desktop"
        ];
      };
    };

    home = {
      activation = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
        docker-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
          ''${DRY_RUN_CMD} mkdir --parents ''${VERBOSE_ARG} "''${HOME}/.docker"

          ''${DRY_RUN_CMD} cat << EOF > "''${HOME}/.docker/config.json"
          {
            "auths": {
              "https://index.docker.io/v1/": {}
            },
            "credsStore": "secretservice"
          }
          EOF
        '';
      };

      file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
        ".config/MangoHud/MangoHud.conf".text = ''
          cpu_stats
          fps
          frametime
          frame_timing
          gpu_stats
        '';

        # https://developer.1password.com/docs/ssh/agent/advanced/#match-key-with-host
        ".ssh/id_ed25519.pub".text = public-ssh-key;

        "Documents/Source/clone-repos.sh" = {
          executable = true;

          text = ''
            #!/usr/bin/env zsh

            CLONE_ROOT="''${HOME}/Documents/Source"

            for CLONE_DIRECTORY in Personal
            do
              CLONE_SOURCE="git@github.com:asininemonkey"

              mkdir -p "''${CLONE_ROOT}/''${CLONE_DIRECTORY}"

              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/cv.josecardoso.com.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/josecardoso.cloud.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/josecardoso.com.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/josecardoso.net.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/miscellaneous.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/miscellaneous-private.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/nixos.git"
              git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/nixpkgs.git"
            done
          '';
        };

        "Documents/Source/Personal/personal.code-workspace".text = ''
          {
              "extensions": {
                  "recommendations": [
                      "bungcip.better-toml",
                      "eamodio.gitlens",
                      "editorconfig.editorconfig",
                      "esbenp.prettier-vscode",
                      "hashicorp.terraform",
                      "irongeek.vscode-env",
                      "jetpack-io.devbox",
                      "jnoortheen.nix-ide",
                      "mineiros.terramate",
                      "ms-azuretools.vscode-docker",
                      "ms-kubernetes-tools.vscode-kubernetes-tools",
                      "ms-vscode-remote.remote-containers",
                      "ms-vscode-remote.remote-ssh",
                      "pascalreitermann93.vscode-yaml-sort",
                      "redhat.vscode-yaml",
                      "richie5um2.vscode-sort-json"
                  ]
              },
              "folders": [
                  {
                      "path": "./cv.josecardoso.com"
                  },
                  {
                      "path": "./josecardoso.cloud"
                  },
                  {
                      "path": "./josecardoso.com"
                  },
                  {
                      "path": "./josecardoso.net"
                  },
                  {
                      "path": "./miscellaneous"
                  },
                  {
                      "path": "./miscellaneous-private"
                  },
                  {
                      "path": "./nixos"
                  },
                  {
                      "path": "./nixpkgs"
                  }
              ],
              "settings": {
                  "diffEditor.ignoreTrimWhitespace": false,
                  "editor.bracketPairColorization.enabled": true,
                  "editor.defaultFormatter": "esbenp.prettier-vscode",
                  "editor.fontFamily": "Fantasque Sans Mono",
                  "editor.fontLigatures": "'ss01'",
                  "editor.fontSize": 18,
                  "editor.fontWeight": "normal",
                  "editor.guides.bracketPairs": "active",
                  "editor.renderControlCharacters": true,
                  "editor.renderWhitespace": "all",
                  "explorer.confirmDelete": false,
                  "files.associations": {
                      "*.hcl": "terraform",
                      "*.tm.hcl": "terramate"
                  },
                  "git.autofetch": true,
                  "git.confirmSync": false,
                  "git.ignoreRebaseWarning": true,
                  "git.showActionButton": {
                      "commit": false,
                      "publish": false,
                      "sync": false
                  },
                  "prettier.endOfLine": "auto",
                  "prettier.tabWidth": 4,
                  "redhat.telemetry.enabled": false,
                  "scm.defaultViewMode": "tree",
                  "scm.repositories.visible": 20,
                  "terminal.integrated.fontFamily": "Fantasque Sans Mono",
                  "terminal.integrated.fontSize": 18,
                  "terminal.integrated.fontWeight": "normal",
                  "update.mode": "none",
                  "window.zoomLevel": 1
              }
          }
        '';
      };
    };

    programs = {
      git = {
        extraConfig = {
          user.signingkey = public-ssh-key;
        };
      };

      zsh.envExtra = ''
        export AWS_ACCESS_KEY_ID="op://Personal/awhb35qeiidqikaej6ub2ftphm/username"
        export AWS_REGION="eu-west-1"
        export AWS_SECRET_ACCESS_KEY="op://Personal/awhb35qeiidqikaej6ub2ftphm/credential"
        export OP_ACCOUNT="JMEFUTV6DJDCBNLIUHRSTFIXOM"
      '';
    };
  };

  networking.timeServers = [
    "nts.netnod.se"
    "time.cloudflare.com"
  ];

  programs.steam.enable = true;

  services.chrony.enableNTS = true;
}
