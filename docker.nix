{ config, pkgs, ... }:

let
  tailnet-name = "fable-blues.ts.net";
in

{
  environment = {
    etc."traefik/traefik.yaml" = {
      mode = "0444";

      text = ''
        api: {}

        certificatesResolvers:
          tailscale:
            tailscale: {}

        entryPoints:
          web-secure:
            address: ":443"

        log:
          level: INFO

        providers:
          docker:
            exposedByDefault: false
          file:
            directory: "/etc/traefik/traefik.d"
      '';
    };

    etc."traefik/traefik.d/empty.yaml" = {
      mode = "0444";
      text = "";
    };
  };

  system.activationScripts.docker-amd64 = if pkgs.stdenv.hostPlatform.system != "x86_64-linux" then ''
    if [[ ''${NIXOS_ACTION} = "switch" ]]
    then
      ${pkgs.docker}/bin/docker run --privileged --rm tonistiigi/binfmt --install amd64
    fi
  '' else "";

  virtualisation = {
    docker = {
      autoPrune.dates = "daily";
      autoPrune.enable = true;
    };

    oci-containers = {
      backend = "docker";

      containers = {
        portainer = {
          image = "portainer/portainer-ee";

          ports = [
            "127.0.0.1:9000:9000/tcp"
          ];

          volumes = [
            "portainer:/data:rw"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        # traefik = {
        #   extraOptions = [
        #     "--label=traefik.enable=true"
        #     "--label=traefik.http.routers.traefik.entrypoints=web-secure"
        #     "--label=traefik.http.routers.traefik.rule=Host(`${config.networking.hostName}.${tailnet-name}`) && PathPrefix(`/api`) || PathPrefix(`/dashboard`)"
        #     "--label=traefik.http.routers.traefik.tls.certresolver=tailscale"
        #     "--label=traefik.http.routers.traefik.service=api@internal"
        #   ];

        #   image = "traefik:3.0";

        #   ports = [
        #     "0.0.0.0:443:443/tcp"
        #   ];

        #   volumes = [
        #     "/etc/traefik:/etc/traefik:ro"
        #     "/var/run/docker.sock:/var/run/docker.sock:ro"
        #     "/var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock:ro"
        #   ];
        # };

        watchtower = {
          environment = {
            TZ = "Europe/London";
            WATCHTOWER_CLEANUP = "true";
            WATCHTOWER_POLL_INTERVAL = "3600";
          };

          image = "containrrr/watchtower";

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        # whoami = {
        #   dependsOn = [
        #     "traefik"
        #   ];

        #   extraOptions = [
        #     "--label=traefik.enable=true"
        #     "--label=traefik.http.middlewares.whoami.stripprefix.prefixes=/whoami"
        #     "--label=traefik.http.routers.whoami.entrypoints=web-secure"
        #     "--label=traefik.http.routers.whoami.middlewares=whoami"
        #     "--label=traefik.http.routers.whoami.rule=Host(`${config.networking.hostName}.${tailnet-name}`) && PathPrefix(`/whoami`)"
        #     "--label=traefik.http.routers.whoami.tls.certresolver=tailscale"
        #     "--label=traefik.http.services.whoami.loadbalancer.server.port=80"
        #   ];

        #   image = "traefik/whoami";
        # };
      };
    };
  };
}
