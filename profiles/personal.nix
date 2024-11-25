{
  config,
  lib,
  pkgs,
  ...
}:

let
  font-family = "Iosevka Nerd Font";
in

{
  environment.systemPackages = with pkgs; [
    chiaki
    darktable
    mangohud
    pupdate
  ];

  home-manager.users.jcardoso = { config, lib, ... }: {
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
              "134474400229.dkr.ecr.eu-west-1.amazonaws.com": "ecr-login"
            },
            "credsStore": "secretservice"
          }
          EOF
        '';
      };

      file = { # https://nix-community.github.io/home-manager/options.xhtml#opt-home.file
        ".config/1Password/ssh/agent.toml".text = ''
          # https://developer.1password.com/docs/ssh/agent/config/

          [[ssh-keys]]
          vault = "kmvqvcacsyp5v6ucrhyenm36ue"
        '';

        ".config/MangoHud/MangoHud.conf".text = ''
          cpu_stats
          fps
          frametime
          frame_timing
          gpu_stats
        '';

        ".zsh_aliases_personal".text = ''
        '';

        ".zsh_envs_personal".text = ''
          export AWS_ACCESS_KEY_ID="op://Personal/awhb35qeiidqikaej6ub2ftphm/username"
          export AWS_REGION="eu-west-1"
          export AWS_SECRET_ACCESS_KEY="op://Personal/awhb35qeiidqikaej6ub2ftphm/credential"
          export OP_ACCOUNT="JMEFUTV6DJDCBNLIUHRSTFIXOM"
        '';
      };
    };

    programs.git = {
      extraConfig = {
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQowLl5Bzn87ig+Gs7Ze5kWODRTdHiD+V8sOCwOx16Z";
      };
    };
  };

  networking.timeServers = [
    "nts.netnod.se"
    "time.cloudflare.com"
  ];

  programs.steam.enable = true;
  services.chrony.enableNTS = true;
}
