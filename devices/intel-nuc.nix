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

  home-manager.users.jcardoso = { config, ... }: {
    home = {
      file = {
        ".ssh/authorized_keys".text = ''
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYDHpVs4nKaLG+tnLUGH+4Ivnq9ELPW0S3W/uJhxNd/
        '';

        ".zsh_history".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
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
        filebrowser = {
          dependsOn = [
            "traefik"
          ];

          environment = {
            FB_ADDRESS = "0.0.0.0";
            FB_BASEURL = "/files";
            FB_NOAUTH = "true";
          };

          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.filebrowser.stripprefix.prefixes=/files"
            "--label=traefik.http.routers.filebrowser.entrypoints=web"
            "--label=traefik.http.routers.filebrowser.middlewares=filebrowser"
            "--label=traefik.http.routers.filebrowser.rule=PathPrefix(`/files`)"
            "--label=traefik.http.services.filebrowser.loadbalancer.server.port=80"
          ];

          image = "filebrowser/filebrowser";

          volumes = [
            "/data/media/movies:/srv/movies:ro"
            "/data/media/television:/srv/television:ro"
            "/data/roms:/srv/roms:ro"
            "/data/temporary:/srv/temporary:ro"
          ];
        };

        gostatic = {
          dependsOn = [
            "traefik"
          ];

          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.gostatic.stripprefix.prefixes=/"
            "--label=traefik.http.routers.gostatic.entrypoints=web"
            "--label=traefik.http.routers.gostatic.middlewares=gostatic"
            "--label=traefik.http.routers.gostatic.rule=PathPrefix(`/`)"
            "--label=traefik.http.services.gostatic.loadbalancer.server.port=8043"
          ];

          image = "pierrezemb/gostatic";

          volumes = [
            "/data/temporary:/srv/http/temporary:ro"
          ];
        };

        initialise = {
          entrypoint = "/bin/sh -c 'chown -v 5000:5000 /media/movies /media/television /media/unsorted && chmod -v 0755 /media/movies /media/television /media/unsorted'";
          image = "alpine";

          volumes = [
            "/data/media/movies:/media/movies:rw"
            "/data/media/television:/media/television:rw"
            "/data/media/unsorted:/media/unsorted:rw"
          ];
        };

        plex = {
          environment = {
            ADVERTISE_IP = "http://192.168.144.220:32400/";
            ALLOWED_NETWORKS = "100.64.0.0/10,172.16.0.0/12,192.168.144.0/24";
            PLEX_GID = "5000";
            PLEX_UID = "5000";
            TZ = "Europe/London";
          };

          extraOptions = [
            "--cap-add=SYS_RAWIO"
            "--device=/dev/dri:/dev/dri"
          ];

          image = "plexinc/pms-docker";

          ports = [
            "0.0.0.0:32400:32400/tcp"
          ];

          volumes = [
            "/data/docker/media/plex:/config:rw"
            "/data/media/movies:/media/movies:ro"
            "/data/media/television:/media/television:ro"
          ];
        };

        portainer = {
          dependsOn = [
            "traefik"
          ];

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
            "/data/docker/miscellaneous/portainer:/data:rw"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        radarr = {
          environment = {
            PGID = "5000";
            PUID = "5000";
            TZ = "Europe/London";
          };

          extraOptions = [
            "--link=sabnzbd:sabnzbd"
          ];

          image = "linuxserver/radarr";

          ports = [
            "0.0.0.0:7878:7878/tcp"
          ];

          volumes = [
            "/data/docker/media/radarr:/config:rw"
            "/data/media/movies:/media/movies:rw"
            "/data/media/unsorted:/media/unsorted:rw"
          ];
        };

        sabnzbd = {
          environment = {
            PGID = "5000";
            PUID = "5000";
            TZ = "Europe/London";
          };

          image = "linuxserver/sabnzbd";

          ports = [
            "0.0.0.0:8080:8080/tcp"
          ];

          volumes = [
            "/data/docker/media/sabnzbd:/config:rw"
            "/data/media/unsorted:/media/unsorted:rw"
          ];
        };

        sonarr = {
          environment = {
            PGID = "5000";
            PUID = "5000";
            TZ = "Europe/London";
          };

          extraOptions = [
            "--link=sabnzbd:sabnzbd"
          ];

          image = "linuxserver/sonarr";

          ports = [
            "0.0.0.0:8989:8989/tcp"
          ];

          volumes = [
            "/data/docker/media/sonarr:/config:rw"
            "/data/media/television:/media/television:rw"
            "/data/media/unsorted:/media/unsorted:rw"
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
            "0.0.0.0:80:80/tcp"
          ];

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        whoami = {
          dependsOn = [
            "traefik"
          ];

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
