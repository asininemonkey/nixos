{
  pkgs,
  ...
}:

let
  company = "xxx";
in

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
    slack
  ] else []) ++ (with pkgs; [
    docker-buildx
    docker-compose
    gcc
    gnupg
    gnutls
  ]);

  home-manager.users.jcardoso = { lib, ... }: {
    home = {
      activation = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.activation
        docker-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
          ''${DRY_RUN_CMD} mkdir --parents ''${VERBOSE_ARG} "''${HOME}/.docker"

          ''${DRY_RUN_CMD} cat << EOF > "''${HOME}/.docker/config.json"
          {
            "auths": {
              "https://index.docker.io/v1/": {}
            },
            "credHelpers": {
              "xxx.dkr.ecr.xxx.amazonaws.com": "ecr-login"
            },
            "credsStore": "secretservice"
          }
          EOF
        '';
      };

      file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
        ".aws/credentials".text = ''
        [default]
        aws_access_key_id=test
        aws_secret_access_key=test
        '';

        ".config/1Password/ssh/agent.toml".text = ''
          # https://developer.1password.com/docs/ssh/agent/config/

          [[ssh-keys]]
          vault = "xxx"

          [[ssh-keys]]
          vault = "xxx"

          [[ssh-keys]]
          vault = "xxx"
        '';

        # pamu2fcfg --verbose
        # vmware-work - 'g/q+egDG7kLgmMxSovyn+M5sR1j7YYwsJ/F9bpYGGc+K3LhQEA/JWPVevFK5JaVw0G+2pPWI1vSiULF2fozmow==,HbTZs5JcPGqmfPUx5SHYhENJDi8qKkj1pyVdV1N8oi2WCkMlYP2hym04A9nnd9yLN0OH7XTRBJqtgA4Vab58Ig==,es256,+presence'
        ".config/Yubico/u2f_keys".text = ''
          jcardoso::g/q+egDG7kLgmMxSovyn+M5sR1j7YYwsJ/F9bpYGGc+K3LhQEA/JWPVevFK5JaVw0G+2pPWI1vSiULF2fozmow==,HbTZs5JcPGqmfPUx5SHYhENJDi8qKkj1pyVdV1N8oi2WCkMlYP2hym04A9nnd9yLN0OH7XTRBJqtgA4Vab58Ig==,es256,+presence
        '';

        ".zsh_aliases_work".text = ''
          alias 'asl'='aws --profile friday-staging sso login'
          alias 'tspi'='sudo tailscale up --accept-routes --exit-node pi --operator jcardoso --reset --ssh'
        '';

        ".zsh_envs_work".text = ''
          export GITHUB_TOKEN="op://Employee/GitHub/token"
          export OP_ACCOUNT="xxx"
        '';

        "Source/Work/devbox.json".text = ''
          {
            "env": {
              "AWS_PAGER": "",
              "AWS_SDK_LOAD_CONFIG": "true",
              "GITHUB_TOKEN": "op://Employee/GitHub/token"
            },
            "packages": [
              "awscli2@latest",
              "k9s@latest",
              "kubectl@latest",
              "kubernetes-helm@latest",
              "terraform@latest",
              "terramate@latest"
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
        user.signingkey = "ssh-ed25519 xxx";
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
