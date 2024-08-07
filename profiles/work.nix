{
  config,
  lib,
  pkgs,
  ...
}:

let
  company = "dailypay";
  font-family = "Iosevka Nerd Font";
  public-ssh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEe5fSnP76m3ui0RhuSLrGE6C1J99nFkWn7+lH/Wdpi";
in

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
    slack
    zoom-us
  ] else []) ++ (with pkgs; [
    docker-buildx
    docker-compose
    gcc
    gnupg
    gnutls
  ]);

  home-manager.users.jcardoso = { config, lib, ... }: {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 0;
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-battery-timeout = 0;
        sleep-inactive-battery-type = "nothing";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "slack.desktop"
          "Zoom.desktop"
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
              "https://artifactory.${company}.com": {},
              "https://index.docker.io/v1/": {}
            },
            "credHelpers": {
              "129796368817.dkr.ecr.us-east-2.amazonaws.com": "ecr-login",
              "343349230900.dkr.ecr.us-east-2.amazonaws.com": "ecr-login",
              "660136129197.dkr.ecr.us-east-1.amazonaws.com": "ecr-login",
              "870869572832.dkr.ecr.us-east-1.amazonaws.com": "ecr-login",
              "974673539992.dkr.ecr.us-east-1.amazonaws.com": "ecr-login"
            },
            "credsStore": "secretservice"
          }
          EOF
        '';
      };

      file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
        ".aws/config".text = ''
          [profile consumer-production]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 008971667266
          sso_region = us-east-1
          sso_role_name = cfsProdOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile consumer-staging]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 008971666916
          sso_region = us-east-1
          sso_role_name = cfsStagingOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile consumer-uat]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 008971667083
          sso_region = us-east-1
          sso_role_name = cfsUatOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile core-uat]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 870869572832
          sso_region = us-east-1
          sso_role_name = coreUatOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile default]
          output = json
          region = eu-west-1
          s3 =
              signature_version = s3v4

          [profile friday-production]
          output = json
          region = us-east-2
          s3 =
              signature_version = s3v4
          sso_account_id = 129796368817
          sso_region = us-east-1
          sso_role_name = fridayProdAdmin
          sso_start_url = https://${company}.awsapps.com/start

          [profile friday-sandbox]
          output = json
          s3 =
              signature_version = s3v4
          sso_account_id = 983954424130
          sso_region = us-east-1
          sso_role_name = fridaySandboxOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile friday-staging]
          output = json
          region = us-east-2
          s3 =
              signature_version = s3v4
          sso_account_id = 343349230900
          sso_region = us-east-1
          sso_role_name = fridayStagingAdmin
          sso_start_url = https://${company}.awsapps.com/start

          [profile friday-uat]
          output = json
          region = us-east-2
          s3 =
              signature_version = s3v4
          sso_account_id = 196087155463
          sso_region = us-east-1
          sso_role_name = fridayUatAdmin
          sso_start_url = https://${company}.awsapps.com/start

          [profile self-service-production]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 581192633327
          sso_region = us-east-1
          sso_role_name = selfsvcProdOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile self-service-staging]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 487914742059
          sso_region = us-east-1
          sso_role_name = selfsvcStagingOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile self-service-uat]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 545905650584
          sso_region = us-east-1
          sso_role_name = selfsvcUatOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile workloads-production]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 975049948807
          sso_region = us-east-1
          sso_role_name = wrkloadProdOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile workloads-staging]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 767397785371
          sso_region = us-east-1
          sso_role_name = wrkloadStagingOperator
          sso_start_url = https://${company}.awsapps.com/start

          [profile workloads-uat]
          output = json
          region = us-east-1
          s3 =
              signature_version = s3v4
          sso_account_id = 533267336757
          sso_region = us-east-1
          sso_role_name = wrkloadUatOperator
          sso_start_url = https://${company}.awsapps.com/start
        '';

        ".aws/credentials".text = ''
        [default]
        aws_access_key_id=test
        aws_secret_access_key=test
        '';

        # pamu2fcfg --verbose
        # msi-pro-work - 'kdNTnXtsc/TPAmGK0BTB3s2jovOYtch2ofKTJpY3AWzVgnpXdy7UsCdU1ME3BD2bNsDxEKkSdRXKWUhraKm6qA==,I5x/SC7ABLFG2+TWBuZwsMox3qqbAwPNsY4aaeOn47KWM7zv2uK7D9YCDPY7KW1AbdIOhc4RmBkYkA93zoxi6A==,es256,+presence'
        # parallels-work-mac-mini - 'O6HNnYvUpiQEAinDbo/b8oriQCQR2qD/Pd+hB7Vq4OJfQxMzkKvYP7SM8MuPd2uU5P+Kk9zYtFUqGAiBb16d2Q==,LVo5GYwX7Arbn4Fly7U/ra9qKArJV8LEanLtF/477TWaRc13OhU1zLhTwf9Eq5Nj/irtKgyiD3LH8Pr0JiB14g==,es256,+presence'
        # parallels-work-macbook-pro - 'e3W5r5C5hrUuQpc4v9ujA7fzqJVg4YfMlucDqXO45A3PvxotkwBSpfJiUbrU0mvGAoTCBdiQOEmzGYpI3H3TYg==,yB2nAB/k1EhnOqXLza7z+V24+SRnQoJdD+EF3MnagxtqA3OvoQthIvCVi0HwM/GstsXDAq8kFdmmmd+sKS5f7w==,es256,+presence'
        ".config/Yubico/u2f_keys".text = ''
          jcardoso:kdNTnXtsc/TPAmGK0BTB3s2jovOYtch2ofKTJpY3AWzVgnpXdy7UsCdU1ME3BD2bNsDxEKkSdRXKWUhraKm6qA==,I5x/SC7ABLFG2+TWBuZwsMox3qqbAwPNsY4aaeOn47KWM7zv2uK7D9YCDPY7KW1AbdIOhc4RmBkYkA93zoxi6A==,es256,+presence:O6HNnYvUpiQEAinDbo/b8oriQCQR2qD/Pd+hB7Vq4OJfQxMzkKvYP7SM8MuPd2uU5P+Kk9zYtFUqGAiBb16d2Q==,LVo5GYwX7Arbn4Fly7U/ra9qKArJV8LEanLtF/477TWaRc13OhU1zLhTwf9Eq5Nj/irtKgyiD3LH8Pr0JiB14g==,es256,+presence:e3W5r5C5hrUuQpc4v9ujA7fzqJVg4YfMlucDqXO45A3PvxotkwBSpfJiUbrU0mvGAoTCBdiQOEmzGYpI3H3TYg==,yB2nAB/k1EhnOqXLza7z+V24+SRnQoJdD+EF3MnagxtqA3OvoQthIvCVi0HwM/GstsXDAq8kFdmmmd+sKS5f7w==,es256,+presence
        '';

        # https://developer.1password.com/docs/ssh/agent/advanced/#match-key-with-host
        ".ssh/id_ed25519.pub".text = public-ssh-key;

        ".zsh_aliases_work".text = ''
          alias 'asl'='aws --profile friday-staging sso login'
        '';

        ".zsh_envs_work".text = ''
          export GITHUB_TOKEN="op://Private/GitHub/token"
          export OP_ACCOUNT="DB4GTH3CEZFDBFA4RXBBFXCJBY"
        '';

        "Source/clone-repos.sh" = {
          executable = true;

          text = ''
            #!/usr/bin/env zsh

            CLONE_ROOT="''${HOME}/Source/Work"
            CLONE_SOURCE="git@github.com:${company}"

            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/credit-building.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/${company}.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-batch.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-ecs.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-harness.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-infrastructure.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-performance.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/friday-runbooks.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/fridaycardapp.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/gitops.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/joey-card.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/joey-sdk.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/merchant-rewards.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/self-service-api.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/self-service-web.git"
            git -C "''${CLONE_ROOT}" clone "''${CLONE_SOURCE}/terramate-live.git"
          '';
        };

        "Source/Work/devbox.json".text = ''
          {
            "env": {
              "AWS_PAGER": "",
              "AWS_SDK_LOAD_CONFIG": "true",
              "GITHUB_TOKEN": "op://Employee/GitHub/token"
            },
            "packages": [
              "awscli2@2.15",
              "grpcurl@latest",
              "k9s@latest",
              "kubectl@1.30",
              "kubernetes-helm@latest",
              "terraform@1.8.3",
              "terramate@0.8.4"
            ],
            "shell": {
              "init_hook": [
                "alias tff='terraform fmt -recursive'",
                "alias tmf='terramate fmt'",
                "alias tmg='terramate generate'",
                "echo 'Welcome to Devbox!'"
              ],
              "scripts": {}
            }
          }
        '';

        "Source/Work/work.code-workspace".text = ''
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
                      "path": "./credit-building"
                  },
                  {
                      "path": "./${company}"
                  },
                  {
                      "path": "./friday-batch"
                  },
                  {
                      "path": "./friday-ecs"
                  },
                  {
                      "path": "./friday-harness"
                  },
                  {
                      "path": "./friday-infrastructure"
                  },
                  {
                      "path": "./friday-performance"
                  },
                  {
                      "path": "./friday-runbooks"
                  },
                  {
                      "path": "./fridaycardapp"
                  },
                  {
                      "path": "./gitops"
                  },
                  {
                      "path": "./joey-card"
                  },
                  {
                      "path": "./joey-sdk"
                  },
                  {
                      "path": "./merchant-rewards"
                  },
                  {
                      "path": "./self-service-api"
                  },
                  {
                      "path": "./self-service-web"
                  },
                  {
                      "path": "./terramate-live"
                  }
              ],
              "settings": {
                  "diffEditor.ignoreTrimWhitespace": false,
                  "editor.bracketPairColorization.enabled": true,
                  "editor.defaultFormatter": "esbenp.prettier-vscode",
                  "editor.fontFamily": ${font-family},
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
                  "terminal.integrated.fontFamily": ${font-family},
                  "terminal.integrated.fontSize": 18,
                  "terminal.integrated.fontWeight": "normal",
                  "update.mode": "none",
                  "window.zoomLevel": 1
              }
          }
        '';
      };
    };

    programs.git = {
      extraConfig = {
        user.signingkey = public-ssh-key;
      };
    };
  };

  networking.timeServers = [
    "1.uk.pool.ntp.org"
    "2.uk.pool.ntp.org"
    "3.uk.pool.ntp.org"
  ];

  security = {
    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };

      u2f = {
        cue = true;
        enable = true;
      };
    };
  };

  services = {
    chrony.enableNTS = false;
    usbguard.enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "10min";
  };
}
