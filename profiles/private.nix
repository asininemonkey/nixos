{ config, pkgs, ... }:

{
  home-manager.users.jcardoso = { config, ... }: {
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Geary.desktop"
        ];
      };
    };

    home.file = {
      "Documents/Source/clone-repos.sh" = {
        executable = true;

        text = ''
          #!/usr/bin/env zsh

          CLONE_ROOT="''${HOME}/Documents/Source"

          for CLONE_DIRECTORY in Private
          do
            CLONE_SOURCE="git@github.com:asininemonkey"

            mkdir -p "''${CLONE_ROOT}/''${CLONE_DIRECTORY}"

            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/bootstrap.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/cv.josecardoso.com.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/josecardoso.com.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/nixos.git"
            git -C "''${CLONE_ROOT}/''${CLONE_DIRECTORY}" clone "''${CLONE_SOURCE}/obsidian.git"
          done
        '';
      };

      "Documents/Source/Private/private.code-workspace".text = ''
        {
            "extensions": {
                "recommendations": [
                    "bungcip.better-toml",
                    "eamodio.gitlens",
                    "esbenp.prettier-vscode",
                    "hashicorp.terraform",
                    "irongeek.vscode-env",
                    "jnoortheen.nix-ide",
                    "ms-azuretools.vscode-docker",
                    "ms-kubernetes-tools.vscode-kubernetes-tools",
                    "ms-vscode-remote.remote-containers",
                    "rangav.vscode-thunder-client",
                    "redhat.vscode-yaml",
                    "richie5um2.vscode-sort-json"
                ]
            },
            "folders": [
                {
                    "path": "./bootstrap"
                },
                {
                    "path": "./cv.josecardoso.com"
                },
                {
                    "path": "./josecardoso.com"
                },
                {
                    "path": "./nixos"
                },
                {
                    "path": "./obsidian"
                }
            ],
            "settings": {
                "diffEditor.ignoreTrimWhitespace": false,
                "editor.bracketPairColorization.enabled": true,
                "editor.defaultFormatter": "esbenp.prettier-vscode",
                "editor.fontFamily": "Iosevka",
                "editor.fontLigatures": true,
                "editor.fontSize": 18,
                "editor.fontWeight": "normal",
                "editor.guides.bracketPairs": "active",
                "editor.renderControlCharacters": true,
                "editor.renderWhitespace": "all",
                "explorer.confirmDelete": false,
                "files.associations": {
                    "*.hcl": "terraform"
                },
                "git.autofetch": true,
                "git.confirmSync": false,
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
                "terminal.integrated.fontFamily": "Iosevka",
                "terminal.integrated.fontSize": 18,
                "terminal.integrated.fontWeight": "normal",
                "update.mode": "none",
                "window.zoomLevel": 1
            }
        }
      '';
    };
  };
}
