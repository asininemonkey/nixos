{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${state-version}.tar.gz";
  state-version = "22.11";
in

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.grub = {
      configurationLimit = 10;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  console.keyMap = "uk";

  environment = {
    defaultPackages = lib.mkForce [];

    shells = (with pkgs; [
      zsh
    ]);

    systemPackages = with pkgs; [
      btop
      nano
      p7zip
      prettyping
      tmux
      tree
      unzip
      wget
    ];
  };

  hardware = {
    opengl.enable = true;
  };

  home-manager.users.jcardoso = {
    home = {
      file = {
        ".ssh/authorized_keys".text = ''
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYDHpVs4nKaLG+tnLUGH+4Ivnq9ELPW0S3W/uJhxNd/
        '';
      };

      stateVersion = "${state-version}";
    };

    programs = {
      zsh = {
        enable = true;

        shellAliases = {
          clean = "sudo nix-collect-garbage --delete-old";
          dig = "drill";
          dsp = "docker system prune --all --force --volumes";
          htop = "btop";
          installed = "nix-store --query --references /run/current-system/sw | sed \"s/^\\/nix\\/store\\/[[:alnum:]]\\{32\\}-//\" | \sort";
          ls = "ls --all --color=always -l";
          nrd = "sudo nixos-rebuild dry-activate";
          nrs = "sudo nixos-rebuild switch";
          ping = "prettyping";
          top = "btop";
          tree = "tree -aghpuCD";
        };
      };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  networking = {
    firewall = {
      checkReversePath = "loose";
      enable = true;
      
      trustedInterfaces = [
        "tailscale0"
      ];
    };
 
    hostName = "intel-nuc";
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];

  security.sudo.execWheelOnly = true;

  services = {
    openssh = {
      ciphers = [
        "aes256-gcm@openssh.com"
        "aes256-ctr"
      ];

      kbdInteractiveAuthentication = false;

      kexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "curve25519-sha256"
      ];

      macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-512"
      ];

      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    sshd.enable = true;

    tailscale.enable = true;
  };

  system.stateVersion = "${state-version}";

  time.timeZone = "Europe/London";

  users.users.jcardoso = {
    description = "Jose Cardoso";

    extraGroups = [
      "docker"
      "wheel"
    ];

    initialPassword = "password";

    isNormalUser = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYDHpVs4nKaLG+tnLUGH+4Ivnq9ELPW0S3W/uJhxNd/"
    ];

    shell = pkgs.zsh;
  };

  virtualisation = {
    docker = {
      autoPrune.dates = "daily";
      autoPrune.enable = true;
    };

    oci-containers = {
      backend = "docker";

      containers = {
        portainer = {
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.portainer.stripprefix.prefixes=/portainer"
            "--label=traefik.http.routers.portainer.entrypoints=web"
            "--label=traefik.http.routers.portainer.middlewares=portainer"
            "--label=traefik.http.routers.portainer.rule=PathPrefix(`/portainer`)"
            "--label=traefik.http.services.portainer.loadbalancer.server.port=9000"
          ];

          image = "portainer/portainer-ee";

          volumes = [
            "portainer:/data:rw"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        traefik = {
          environment = {
            TRAEFIK_API = "true";
            TRAEFIK_ENTRYPOINTS_WEB = "true";
            TRAEFIK_ENTRYPOINTS_WEB_ADDRESS = ":80";
            TRAEFIK_PROVIDERS_DOCKER = "true";
            TRAEFIK_PROVIDERS_DOCKER_EXPOSEDBYDEFAULT = "false";
          };

          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.traefik.stripprefix.prefixes=/traefik"
            "--label=traefik.http.routers.traefik.entrypoints=web"
            "--label=traefik.http.routers.traefik.middlewares=traefik"
            "--label=traefik.http.routers.traefik.rule=PathPrefix(`/api`) || PathPrefix(`/traefik`)"
            "--label=traefik.http.routers.traefik.service=api@internal"
          ];

          image = "traefik";

          ports = [
            "127.0.0.1:80:80/tcp"
          ];

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        whoami = {
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.whoami.stripprefix.prefixes=/whoami"
            "--label=traefik.http.routers.whoami.entrypoints=web"
            "--label=traefik.http.routers.whoami.middlewares=whoami"
            "--label=traefik.http.routers.whoami.rule=PathPrefix(`/whoami`)"
            "--label=traefik.http.services.whoami.loadbalancer.server.port=80"
          ];

          image = "traefik/whoami";
        };
      };
    };
  };
}
