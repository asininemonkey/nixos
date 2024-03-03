{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain-name = "josecardoso.net";
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  immich-version = "v1.97.0";
  nixos-unstable = fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
  state-version = "23.11";
  tailnet-name = "fable-blues.ts.net";
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

    etc."docker/compose.yaml" = {
      mode = "0440";

      text = ''
        # https://docs.docker.com/compose/compose-file/compose-file-v3/
        ---
        networks:
          general:
            driver_opts:
              com.docker.network.bridge.name: br-d4r-general
            ipam:
              config:
                - subnet: 172.20.0.0/16
          immich:
            driver_opts:
              com.docker.network.bridge.name: br-d4r-immich
            ipam:
              config:
                - subnet: 172.21.0.0/16
          media:
            driver_opts:
              com.docker.network.bridge.name: br-d4r-media
            ipam:
              config:
                - subnet: 172.22.0.0/16
          trusted:
            driver_opts:
              com.docker.network.bridge.name: br-d4r-trusted
            ipam:
              config:
                - subnet: 172.23.0.0/16
          vpn:
            driver_opts:
              com.docker.network.bridge.name: br-d4r-vpn
            ipam:
              config:
                - subnet: 172.24.0.0/16
        services:
          caddy:
            command:
              - "caddy"
              - "file-server"
              - "--access-log"
              - "--browse"
            container_name: caddy
            depends_on:
              - traefik
            image: caddy
            labels:
              traefik.enable: "true"
              traefik.http.routers.caddy.entrypoints: "web-secure"
              traefik.http.routers.caddy.rule: "Host(`caddy.${domain-name}`)"
              traefik.http.services.caddy.loadbalancer.server.port: "80"
            networks:
              general:
            restart: on-failure
            volumes:
              - "/data/emulation:/srv/emulation:ro"
              - "/data/iso-images:/srv/iso-images:ro"
              - "/data/macos:/srv/macos:ro"
              - "/data/media/movies:/srv/media/movies:ro"
              - "/data/media/television:/srv/media/television:ro"
              - "/data/miscellaneous:/srv/miscellaneous:ro"
              - "/data/rips:/srv/rips:ro"
              - "/data/temporary:/srv/temporary:ro"
          dashdot:
            container_name: dashdot
            depends_on:
              - traefik
            environment:
              DASHDOT_ACCEPT_OOKLA_EULA: "true"
              DASHDOT_ALWAYS_SHOW_PERCENTAGES: "true"
              DASHDOT_ENABLE_CPU_TEMPS: "true"
              DASHDOT_SHOW_DASH_VERSION: "icon_hover"
              DASHDOT_SPEED_TEST_INTERVAL: "360"
            image: mauricenino/dashdot
            labels:
              traefik.enable: "true"
              traefik.http.routers.dashdot.entrypoints: "web-secure"
              traefik.http.routers.dashdot.rule: "Host(`dashdot.${domain-name}`)"
              traefik.http.services.dashdot.loadbalancer.server.port: "3001"
            networks:
              general:
            privileged: true
            restart: on-failure
            volumes:
              - "/:/mnt/host:ro"
          gluetun:
            cap_add:
              - NET_ADMIN
            container_name: gluetun
            devices:
              - "/dev/net/tun:/dev/net/tun"
            env_file:
              - /data/docker/gluetun-protonvpn.env
            environment:
              VPN_ENDPOINT_PORT: "51820"
              VPN_PORT_FORWARDING: "on"
              VPN_PORT_FORWARDING_PROVIDER: "protonvpn"
              VPN_SERVICE_PROVIDER: "custom"
              VPN_TYPE: "wireguard"
            image: qmcgaw/gluetun
            networks:
              vpn:
            ports:
              - "0.0.0.0:7878:7878/tcp" # radarr
              - "0.0.0.0:8080:8080/tcp" # sabnzbd
              - "0.0.0.0:8090:8090/tcp" # qbittorrent
              - "0.0.0.0:8989:8989/tcp" # sonarr
              - "0.0.0.0:9696:9696/tcp" # prowlarr
            restart: on-failure
            volumes:
              - "/data/docker/gluetun:/tmp/gluetun:rw"
          gluetun-qbittorrent-port-manager:
            container_name: gluetun-qbittorrent-port-manager
            depends_on:
              - gluetun
            environment:
              QBITTORRENT_PASS: "adminadmin"
              QBITTORRENT_PORT: "8090"
              QBITTORRENT_SERVER: "127.0.0.1"
              QBITTORRENT_USER: "admin"
            image: snoringdragon/gluetun-qbittorrent-port-manager
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/gluetun:/tmp/gluetun:ro"
          homarr:
            container_name: homarr
            depends_on:
              - traefik
            environment:
              DEFAULT_COLOR_SCHEME: "dark"
              DISABLE_ANALYTICS: "true"
              TZ: "Europe/London"
            image: ghcr.io/ajnart/homarr
            labels:
              traefik.enable: "true"
              traefik.http.routers.homarr.entrypoints: "web-secure"
              traefik.http.routers.homarr.rule: "Host(`${domain-name}`)"
              traefik.http.services.homarr.loadbalancer.server.port: "7575"
            networks:
              trusted:
            restart: on-failure
            volumes:
              - "/data/docker/homarr/configs:/app/data/configs:rw"
              - "/data/docker/homarr/data:/data:rw"
              - "/data/docker/homarr/icons:/app/public/icons:rw"
              - "/var/run/docker.sock:/var/run/docker.sock:ro"
          immich-machine-learning:
            container_name: immich-machine-learning
            image: ghcr.io/immich-app/immich-machine-learning:${immich-version}
            networks:
              immich:
                ipv4_address: 172.21.0.10
            restart: on-failure
            volumes:
              - "/data/docker/immich/machine-learning:/cache:rw"
          immich-microservices:
            command:
              - "start.sh"
              - "microservices"
            container_name: immich-microservices
            depends_on:
              - immich-postgres
              - immich-redis
            devices:
              - "/dev/dri:/dev/dri"
            environment:
              DB_DATABASE_NAME: "immich"
              DB_HOSTNAME: "172.21.0.30"
              DB_PASSWORD: "immich"
              DB_USERNAME: "immich"
              IMMICH_MACHINE_LEARNING_URL: "http://172.21.0.10:3003"
              REDIS_HOSTNAME: "172.21.0.40"
            image: ghcr.io/immich-app/immich-server:${immich-version}
            networks:
              immich:
                ipv4_address: 172.21.0.20
            restart: on-failure
            volumes:
              - "/data/docker/immich/upload:/usr/src/app/upload:rw"
              - "/etc/localtime:/etc/localtime:ro"
          immich-postgres:
            container_name: immich-postgres
            environment:
              POSTGRES_DB: "immich"
              POSTGRES_PASSWORD: "immich"
              POSTGRES_USER: "immich"
            image: tensorchord/pgvecto-rs:pg14-v0.2.0
            networks:
              immich:
                ipv4_address: 172.21.0.30
            restart: on-failure
            volumes:
              - "/data/docker/immich/postgres:/var/lib/postgresql/data:rw"
          immich-redis:
            container_name: immich-redis
            image: redis:7
            networks:
              immich:
                ipv4_address: 172.21.0.40
            restart: on-failure
          immich-server:
            command:
              - "start.sh"
              - "immich"
            container_name: immich-server
            depends_on:
              - immich-postgres
              - immich-redis
              - traefik
            environment:
              DB_DATABASE_NAME: "immich"
              DB_HOSTNAME: "172.21.0.30"
              DB_PASSWORD: "immich"
              DB_USERNAME: "immich"
              REDIS_HOSTNAME: "172.21.0.40"
            image: ghcr.io/immich-app/immich-server:${immich-version}
            labels:
              traefik.enable: "true"
              traefik.http.routers.immich.entrypoints: "web-secure"
              traefik.http.routers.immich.rule: "Host(`immich.${domain-name}`)"
              traefik.http.services.immich.loadbalancer.server.port: "3001"
            networks:
              immich:
                ipv4_address: 172.21.0.50
            restart: on-failure
            volumes:
              - "/data/docker/immich/upload:/usr/src/app/upload:rw"
              - "/etc/localtime:/etc/localtime:ro"
          kasm:
            container_name: kasm
            depends_on:
              - traefik
            devices:
              - "/dev/dri:/dev/dri"
            environment:
              KASM_PORT: "8443" # https://www.kasmweb.com/docs/latest/how_to/reverse_proxy.html#update-zones
            image: lscr.io/linuxserver/kasm
            labels:
              traefik.enable: "true"
              traefik.http.routers.kasm.entrypoints: "web-secure"
              traefik.http.routers.kasm.rule: "Host(`kasm.${domain-name}`)"
              traefik.http.services.kasm.loadbalancer.server.port: "8443"
              traefik.http.services.kasm.loadbalancer.server.scheme: "https"
            networks:
              general:
            privileged: true
            ports:
              - "0.0.0.0:3000:3000/tcp"
            restart: on-failure
            volumes:
              - "/data/docker/kasm/opt:/opt:rw"
              - "/data/docker/kasm/profiles:/profiles:rw"
              - "/data/emulation/roms/extracted:/mnt/host/emulation/roms:ro"
              - "/data/media/movies:/mnt/host/media/movies:ro"
              - "/data/media/television:/mnt/host/media/television:ro"
              - "/data/rips:/mnt/host/rips:ro"
              - "/data/temporary:/mnt/host/temporary:rw"
          ocis:
            container_name: ocis
            depends_on:
              - traefik
            environment:
              OCIS_URL: "https://owncloud.${domain-name}"
              PROXY_TLS: "false"
            image: owncloud/ocis
            labels:
              traefik.enable: "true"
              traefik.http.routers.ocis.entrypoints: "web-secure"
              traefik.http.routers.ocis.rule: "Host(`owncloud.${domain-name}`)"
              traefik.http.services.ocis.loadbalancer.server.port: "9200"
            networks:
              trusted:
            restart: on-failure
            volumes:
              - "/data/docker/ocis/config:/etc/ocis:rw"
              - "/data/docker/ocis/data:/var/lib/ocis:rw"
          overseerr:
            container_name: overseerr
            depends_on:
              - traefik
            environment:
              TZ: "Europe/London"
            image: sctx/overseerr
            labels:
              traefik.enable: "true"
              traefik.http.routers.overseerr.entrypoints: "web-secure"
              traefik.http.routers.overseerr.rule: "Host(`overseerr.${domain-name}`)"
              traefik.http.services.overseerr.loadbalancer.server.port: "5055"
            networks:
              media:
            restart: on-failure
            volumes:
              - "/data/docker/overseerr:/app/config:rw"
          plex:
            cap_add:
              - SYS_RAWIO
            container_name: plex
            devices:
              - "/dev/dri:/dev/dri"
            environment:
              ADVERTISE_IP: "https://192.168.144.200:32400/"
              ALLOWED_NETWORKS: "100.64.0.0/10,172.22.0.0/16,192.168.144.0/24"
              PLEX_GID: "5000"
              PLEX_UID: "5000"
              TZ: "Europe/London"
            image: plexinc/pms-docker
            networks:
              media:
                ipv4_address: 172.22.0.10
            ports:
              - "0.0.0.0:1900:1900/udp"
              - "0.0.0.0:8324:8324/tcp"
              - "0.0.0.0:32400:32400/tcp"
              - "0.0.0.0:32410:32410/udp"
              - "0.0.0.0:32412-32414:32412-32414/udp"
              - "0.0.0.0:32469:32469/tcp"
            restart: on-failure
            volumes:
              - "/data/docker/plex:/config:rw"
              - "/data/media/movies:/media/movies:ro"
              - "/data/media/television:/media/television:ro"
              - "/data/rips:/rips:ro"
          portainer:
            container_name: portainer
            depends_on:
              - traefik
            image: portainer/portainer-ee
            labels:
              traefik.enable: "true"
              traefik.http.routers.portainer.entrypoints: "web-secure"
              traefik.http.routers.portainer.rule: "Host(`portainer.${domain-name}`)"
              traefik.http.services.portainer.loadbalancer.server.port: "9000"
            networks:
              general:
            restart: on-failure
            volumes:
              - "/data/docker/portainer:/data:rw"
              - "/var/run/docker.sock:/var/run/docker.sock:ro"
          prowlarr:
            container_name: prowlarr
            depends_on:
              - gluetun
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
            image: lscr.io/linuxserver/prowlarr
            labels:
              traefik.enable: "true"
              traefik.http.routers.prowlarr.entrypoints: "web-secure"
              traefik.http.routers.prowlarr.rule: "Host(`prowlarr.${domain-name}`)"
              traefik.http.services.prowlarr.loadbalancer.server.port: "9696"
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/prowlarr:/config:rw"
          qbittorrent:
            container_name: qbittorrent
            depends_on:
              - gluetun
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
              WEBUI_PORT: "8090"
            image: lscr.io/linuxserver/qbittorrent
            labels:
              traefik.enable: "true"
              traefik.http.routers.qbittorrent.entrypoints: "web-secure"
              traefik.http.routers.qbittorrent.rule: "Host(`qbittorrent.${domain-name}`)"
              traefik.http.services.qbittorrent.loadbalancer.server.port: "8090"
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/qbittorrent:/config/qBittorrent/BT_backup:rw"
              - "/data/media/unsorted:/media/unsorted:rw"
              - "/etc/docker/configurations/qbittorrent.conf:/config/qBittorrent.conf:ro"
          radarr:
            container_name: radarr
            depends_on:
              - gluetun
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
            image: lscr.io/linuxserver/radarr
            labels:
              traefik.enable: "true"
              traefik.http.routers.radarr.entrypoints: "web-secure"
              traefik.http.routers.radarr.rule: "Host(`radarr.${domain-name}`)"
              traefik.http.services.radarr.loadbalancer.server.port: "7878"
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/radarr:/config:rw"
              - "/data/media/movies:/media/movies:rw"
              - "/data/media/unsorted:/media/unsorted:rw"
          sabnzbd:
            container_name: sabnzbd
            depends_on:
              - gluetun
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
            image: lscr.io/linuxserver/sabnzbd
            labels:
              traefik.enable: "true"
              traefik.http.routers.sabnzbd.entrypoints: "web-secure"
              traefik.http.routers.sabnzbd.rule: "Host(`sabnzbd.${domain-name}`)"
              traefik.http.services.sabnzbd.loadbalancer.server.port: "8080"
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/sabnzbd:/config:rw"
              - "/data/media/unsorted:/media/unsorted:rw"
          sonarr:
            container_name: sonarr
            depends_on:
              - gluetun
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
            image: lscr.io/linuxserver/sonarr:develop
            labels:
              traefik.enable: "true"
              traefik.http.routers.sonarr.entrypoints: "web-secure"
              traefik.http.routers.sonarr.rule: "Host(`sonarr.${domain-name}`)"
              traefik.http.services.sonarr.loadbalancer.server.port: "8989"
            network_mode: "container:gluetun"
            restart: on-failure
            volumes:
              - "/data/docker/sonarr:/config:rw"
              - "/data/media/television:/media/television:rw"
              - "/data/media/unsorted:/media/unsorted:rw"
          tautulli:
            container_name: tautulli
            depends_on:
              - plex
              - traefik
            environment:
              PGID: "5000"
              PUID: "5000"
              TZ: "Europe/London"
            image: ghcr.io/tautulli/tautulli
            labels:
              traefik.enable: "true"
              traefik.http.routers.tautulli.entrypoints: "web-secure"
              traefik.http.routers.tautulli.rule: "Host(`tautulli.${domain-name}`)"
              traefik.http.services.tautulli.loadbalancer.server.port: "8181"
            networks:
              media:
            restart: on-failure
            volumes:
              - "/data/docker/tautulli:/config:rw"
          traefik:
            container_name: traefik
            environment:
              AWS_POLLING_INTERVAL: "5"
              AWS_PROPAGATION_TIMEOUT: "600"
            image: traefik:3.0
            labels:
              traefik.enable: "true"
              traefik.http.routers.traefik.entrypoints: "web-secure"
              traefik.http.routers.traefik.rule: "Host(`traefik.${domain-name}`)"
              traefik.http.routers.traefik.service: "api@internal"
            networks:
              general:
              immich:
              media:
              trusted:
              vpn:
            ports:
              - "0.0.0.0:443:443/tcp"
            restart: on-failure
            volumes:
              - "/data/docker/traefik/acme.json:/acme.json:rw"
              - "/etc/traefik:/etc/traefik:ro"
              - "/var/run/docker.sock:/var/run/docker.sock:ro"
              - "/var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock:ro"
          watchtower:
            container_name: watchtower
            environment:
              TZ: "Europe/London"
              WATCHTOWER_CLEANUP: "true"
              WATCHTOWER_SCHEDULE: "0 0 4 * * *"
            image: containrrr/watchtower
            networks:
              general:
            restart: on-failure
            volumes:
              - "/var/run/docker.sock:/var/run/docker.sock:ro"
        version: '3.8'
      '';
    };

    etc."docker/configurations/qbittorrent.conf" = {
      mode = "0444";

      text = ''
        [BitTorrent]
        Session\AddExtensionToIncompleteFiles=true
        Session\AnonymousModeEnabled=true
        Session\DefaultSavePath=/media/unsorted/qbittorrent/complete
        Session\Encryption=1
        # Session\GlobalMaxSeedingMinutes=60
        Session\MaxActiveDownloads=3
        Session\MaxActiveTorrents=3
        Session\MaxActiveUploads=3
        Session\MaxRatioAction=3
        Session\QueueingSystemEnabled=true
        Session\TempPath=/media/unsorted/qbittorrent/incomplete
        Session\TempPathEnabled=true

        [Core]
        AutoDeleteAddedTorrentFile=IfAdded

        [LegalNotice]
        Accepted=true

        [Preferences]
        General\CloseToTrayNotified=true
        General\Locale=en_GB
        WebUI\AuthSubnetWhitelist=100.64.0.0/10,172.16.0.0/12,192.168.144.0/24
        WebUI\AuthSubnetWhitelistEnabled=true
        WebUI\LocalHostAuth=false
      '';
    };

    etc."traefik/traefik.yaml" = {
      mode = "0444";

      text = ''
        api: {}

        certificatesResolvers:
          letsencrypt:
            acme:
              # caserver: "https://acme-staging-v02.api.letsencrypt.org/directory"
              dnsChallenge:
                provider: "route53"
                resolvers:
                  - "1.1.1.1:53"
                  - "1.0.0.1:53"
              email: "domains@${domain-name}"
              keyType: "EC384"

        entryPoints:
          web-secure:
            address: ":443"
            http:
              tls:
                certResolver: "letsencrypt"
                domains:
                  - main: "${domain-name}"
                    sans:
                      - "*.${domain-name}"

        log:
          level: "DEBUG"

        providers:
          docker:
            exposedByDefault: false

        serversTransport:
          insecureSkipVerify: true

        tls:
          stores:
            default:
              defaultGeneratedCert:
                domain:
                  main: "${domain-name}"
                  sans:
                    - "*.${domain-name}"
                resolver: "letsencrypt"
      '';
    };

    shells = (with pkgs; [
      zsh
    ]);

    systemPackages = (with pkgs; [
      btop
      eza
      iftop
      intel-gpu-tools
      internetarchive
      ldns
      nano
      p7zip
      tmux
      tree
      trippy
      unzip
      wakelan
      wget
      yt-dlp
    ]) ++ (with pkgs.unstable; [
      immich-cli
    ]);
  };

  home-manager.users.jcardoso = { config, ... }: {
    home = {
      file = {
        ".bash_history".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
        ".lesshst".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
        ".zsh_history".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";

        "scripts/clean-roms.sh" = {
          executable = true;

          text = ''
            #!/usr/bin/env zsh

            for TYPE in \
              Argentina \
              Asia \
              Australia \
              Beta \
              'Beta ?' \
              Brazil \
              Canada \
              China \
              De \
              Demo \
              Es \
              Fr \
              France \
              Germany \
              Italy \
              Japan \
              'Japan, Korea' \
              Korea \
              Mexico \
              Netherlands \
              Pirate \
              Program \
              Proto \
              Russia \
              Sample \
              'Sega Channel' \
              Spain \
              'Steam Version' \
              Sweden \
              Taiwan \
              Unl \
              'Virtual Console'
            do
              find /data/emulation/roms/extracted -name "*(''${TYPE})*" -delete -print | sort
            done

            find /data/emulation/roms/extracted -empty -type d -delete -print | sort
          '';
        };

        "scripts/reset-permissions.sh" = {
          executable = true;

          text = ''
            #!/usr/bin/env zsh

            for DIRECTORY in \
              emulation \
              iso-images \
              macos \
              media \
              miscellaneous \
              private \
              rips \
              temporary
            do
              find "/data/''${DIRECTORY}" -type d -print0 | xargs -0 sudo chmod 0775
              find "/data/''${DIRECTORY}" -type f -print0 | xargs -0 sudo chmod 0664

              find "/data/''${DIRECTORY}" -name '*.sh' -print0 | xargs -0 sudo chmod 0775

              if [[ "''${DIRECTORY}" == "media" || "''${DIRECTORY}" == "rips" ]]
              then
                sudo chown --recursive '5000:5000' "/data/''${DIRECTORY}"
              else
                sudo chown --recursive 'nobody:jcardoso' "/data/''${DIRECTORY}"
              fi
            done
          '';
        };
      };

      stateVersion = "${state-version}";
    };

    programs = {
      zsh = {
        enable = true;

        envExtra = ''
          export EXA_ICON_SPACING="2"
        '';

        shellAliases = {
          clean = "sudo nix-collect-garbage --delete-old";
          dig = "drill";
          dsc = "docker stop $(docker ps --quiet)";
          dsp = "docker system prune --all --force --volumes";
          failed = "systemctl list-units --state failed";
          htop = "btop";
          installed = "nix-store --query --references /run/current-system/sw | sed \"s/^\\/nix\\/store\\/[[:alnum:]]\\{32\\}-//\" | \sort";
          ls = "eza --git --git-repos --group --group-directories-first --icons --time-style long-iso";
          nrs = "curl --location --silent 'https://raw.githubusercontent.com/asininemonkey/nixos/main/devices/intel-nuc.nix' | sudo tee '/etc/nixos/configuration.nix' > '/dev/null' && sudo nix-channel --update && sudo nixos-rebuild switch";
          nso = "nix --extra-experimental-features nix-command store optimise";
          ping = "trip";
          top = "btop";
          tracepath = "trip";
          tree = "tree -aghpuCD";
          wake = "wakelan -m a8:a1:59:72:aa:0e";
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
        "br-d4r-ocis"
        "br-d4r-trusted"
        "tailscale0"
      ];
    };
 
    hostName = "intel-nuc";
    nftables.enable = true;
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    unstable = import nixos-unstable {
      config = config.nixpkgs.config;
    };
  };

  programs.zsh.enable = true;

  security = {
    sudo.execWheelOnly = true;

    wrappers = {
      ping6 = {
        capabilities = "cap_net_raw+p";
        group = "root";
        owner = "root";
        source = "${pkgs.inetutils.out}/bin/ping6";
      };

      trip = {
        capabilities = "cap_net_raw+p";
        group = "root";
        owner = "root";
        source = "${pkgs.trippy.out}/bin/trip";
      };
    };
  };

  services = {
    fstrim.enable = true;
    iperf3.enable = true;

    openssh = {
      openFirewall = false;

      settings = {
        AllowUsers = [
          "jcardoso"
        ];

        Ciphers = [
          "aes256-gcm@openssh.com"
          "aes256-ctr"
        ];

        KbdInteractiveAuthentication = false;

        KexAlgorithms = [
          "curve25519-sha256@libssh.org"
          "curve25519-sha256"
        ];

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-512"
        ];

        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    samba = {
      enable = true;

      extraConfig = ''
        # https://www.samba.org/samba/docs/current/man-html/vfs_fruit.8.html
        fruit:delete_empty_adfiles = Yes
        fruit:encoding = native
        fruit:metadata = stream
        fruit:nfs_aces = No
        fruit:resource = xattr
        fruit:wipe_intentionally_left_blank_rfork = Yes
        
        # https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
        client min protocol = SMB2_10
        map to guest = Bad User
        server min protocol = SMB2_10
        vfs objects = catia fruit streams_xattr
      '';

      openFirewall = true;

      shares = {
        emulation = {
          "guest ok" = "Yes";
          "path" = "/data/emulation";
        };

        iso-images = {
          "guest ok" = "Yes";
          "path" = "/data/iso-images";
        };

        macos = {
          "guest ok" = "Yes";
          "path" = "/data/macos";
        };

        media = {
          "guest ok" = "Yes";
          "path" = "/data/media";
        };

        miscellaneous = {
          "guest ok" = "Yes";
          "path" = "/data/miscellaneous";
        };

        rips = {
          "guest ok" = "Yes";
          "path" = "/data/rips";
        };

        temporary = {
          "create mask" = "0664";
          "directory mask" = "0775";
          "force group" = "jcardoso";
          "force user" = "nobody";
          "guest ok" = "Yes";
          "path" = "/data/temporary";
          "read only" = "No";
        };
      };
    };

    sshd.enable = true;

    tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
    };
  };

  system = {
    activationScripts.nvd = {
      supportsDryActivation = true;

      text = ''
        "${pkgs.nvd}/bin/nvd" --nix-bin-dir "${pkgs.nix}/bin" diff /run/current-system "$systemConfig"
      '';
    };

    stateVersion = "${state-version}";
  };

  systemd.services.docker-compose = {
    after = [
      "docker.service"
      "docker.socket"
    ];

    path = [
      pkgs.docker-compose
    ];

    script = "docker-compose --file /etc/docker/compose.yaml up";

    wantedBy = [
      "multi-user.target"
    ];
  };

  time.timeZone = "Europe/London";

  users = {
    groups = {
      jcardoso.gid = 1000;
      media.gid = 5000;
    };

    users = {
      jcardoso = {
        description = "Jose Cardoso";

        extraGroups = [
          "docker"
          "media"
          "wheel"
        ];

        group = "jcardoso";
        initialPassword = "password";
        isNormalUser = true;
        shell = pkgs.zsh;
        uid = 1000;
      };

      media = {
        description = "Media Services";
        group = "media";
        isSystemUser = true;
        uid = 5000;
      };
    };
  };

  virtualisation.docker = {
    autoPrune.dates = "daily";
    autoPrune.enable = true;
    enable = true;
  };
}
