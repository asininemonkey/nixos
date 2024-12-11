{
  config,
  lib,
  pkgs,
  ...
}:

let
  company = "dailypay";
  font-family = "Iosevka Nerd Font";
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

        ".config/1Password/ssh/agent.toml".text = ''
          # https://developer.1password.com/docs/ssh/agent/config/

          [[ssh-keys]]
          vault = "plz3luyabdtqejl5bd5uj3yeby"

          [[ssh-keys]]
          vault = "y5apus4m3nbefbwjnulilunaai"

          [[ssh-keys]]
          vault = "kmvqvcacsyp5v6ucrhyenm36ue"
        '';

        # pamu2fcfg --verbose
        # macbook-pro-work - 'D9HsHdTeRtAZXl7fNjGiqrXbsdMhbo+ao0jd4pjn0VsnfBUEiJvLd2lRlfYe+S884bkQCBuWwSbzPIuuif2MCg==,VMR3XOWY21cmYugQqnrmBnqHSpJ4UMdyAVCHh2rTGgGUbhLziCVgv8wRCHwe29Z5wTR05Bpcce598jb+V4Y3LQ==,es256,+presence'
        # msi-pro-work     - 'kdNTnXtsc/TPAmGK0BTB3s2jovOYtch2ofKTJpY3AWzVgnpXdy7UsCdU1ME3BD2bNsDxEKkSdRXKWUhraKm6qA==,I5x/SC7ABLFG2+TWBuZwsMox3qqbAwPNsY4aaeOn47KWM7zv2uK7D9YCDPY7KW1AbdIOhc4RmBkYkA93zoxi6A==,es256,+presence'
        ".config/Yubico/u2f_keys".text = ''
          jcardoso::D9HsHdTeRtAZXl7fNjGiqrXbsdMhbo+ao0jd4pjn0VsnfBUEiJvLd2lRlfYe+S884bkQCBuWwSbzPIuuif2MCg==,VMR3XOWY21cmYugQqnrmBnqHSpJ4UMdyAVCHh2rTGgGUbhLziCVgv8wRCHwe29Z5wTR05Bpcce598jb+V4Y3LQ==,es256,+presence:kdNTnXtsc/TPAmGK0BTB3s2jovOYtch2ofKTJpY3AWzVgnpXdy7UsCdU1ME3BD2bNsDxEKkSdRXKWUhraKm6qA==,I5x/SC7ABLFG2+TWBuZwsMox3qqbAwPNsY4aaeOn47KWM7zv2uK7D9YCDPY7KW1AbdIOhc4RmBkYkA93zoxi6A==,es256,+presence
        '';

        ".zsh_aliases_work".text = ''
          alias 'asl'='aws --profile friday-staging sso login'
          alias 'tspi'='sudo tailscale up --accept-routes --exit-node pi --operator jcardoso --reset --ssh'
        '';

        ".zsh_envs_work".text = ''
          export GITHUB_TOKEN="op://Private/GitHub/token"
          export OP_ACCOUNT="DB4GTH3CEZFDBFA4RXBBFXCJBY"
        '';

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
      };
    };

    programs.git = {
      extraConfig = {
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEe5fSnP76m3ui0RhuSLrGE6C1J99nFkWn7+lH/Wdpi";
      };
    };
  };

  networking.timeServers = [
    "1.uk.pool.ntp.org"
    "2.uk.pool.ntp.org"
    "3.uk.pool.ntp.org"
  ];

  services.chrony.enableNTS = false;

  # system.autoUpgrade = {
  #   enable = true;
  #   randomizedDelaySec = "10min";
  # };
}
