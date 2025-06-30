{
  custom,
  lib,
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

    file = {
      ".aws/credentials".text = ''
        [default]
        aws_access_key_id=test
        aws_secret_access_key=test
      '';

      ".config/wireplumber/wireplumber.conf.d/disable-devices.conf".text = ''
        monitor.alsa.rules = [
          {
            actions = {
              update-props = {
                device.disabled = true
              }
            }

            matches = [
              {
                device.name = "~alsa_card.pci-*"
              }
            ]
          }
        ]
      '';

      ".config/Yubico/u2f_keys".text = ''
        # pamu2fcfg --verbose
        jcardoso:rUeVf/icwSj3xHgke0d1YmK9+JP69H+d6sl4UPykbpGXhChFQkX3Vrn+XOGe1yZ15L1id8HcXwPgFaT26cRvMA==,Hh9Qc6JnS6UW6u+s6cDS5cbH4u21/OhCMDsPxegQCCrtqks3pCsUO6DlckWDWqJaon2bkSsdt9xcQNk03pHBig==,es256,+presence
      '';

      ".ssh/config".text = ''
        Host *
          IdentityAgent ~/.bitwarden-ssh-agent.sock
      '';
    };

    homeDirectory = "/home/${custom.user.name}";
    stateVersion = "25.05";
    username = custom.user.name;
  };

  imports = [
    ./desktop.nix
    ./firefox.nix
    ./ghostty.nix
    ./git.nix
    ./k9s.nix
    ./kubecolor.nix
    ./mangohud.nix
    ./zed-editor.nix
    ./zsh.nix
  ];

  xdg.desktopEntries = {
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

    "uuctl" = {
      name = "";
      noDisplay = true;
    };
  };
}
