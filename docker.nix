{ config, pkgs, ... }:

{
  environment.etc."docker/compose.yaml" = {
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
      services:
        ollama:
          container_name: ollama
          devices:
            - "/dev/dri:/dev/dri"
            - "/dev/kfd:/dev/kfd"
          image: ollama/ollama:0.1.24-rocm
          networks:
            general:
          ports:
            - "127.0.0.1:11434:11434/tcp"
          volumes:
            - "ollama:/root/.ollama:rw"
        portainer:
          container_name: portainer
          image: portainer/portainer-ee
          networks:
            general:
          ports:
            - "127.0.0.1:9000:9000/tcp"
          restart: on-failure
          volumes:
            - "portainer:/data:rw"
            - "/var/run/docker.sock:/var/run/docker.sock:ro"
        watchtower:
          container_name: watchtower
          environment:
            TZ: "Europe/London"
            WATCHTOWER_CLEANUP: "true"
            WATCHTOWER_POLL_INTERVAL: "3600"
          image: containrrr/watchtower
          networks:
            general:
          restart: on-failure
          volumes:
            - "/var/run/docker.sock:/var/run/docker.sock:ro"
      version: '3.8'
      volumes:
        ollama:
        portainer:
    '';
  };

  system.activationScripts.docker-amd64 = if pkgs.stdenv.hostPlatform.system != "x86_64-linux" then ''
    if [[ ''${NIXOS_ACTION} = "switch" ]]
    then
      ${pkgs.docker}/bin/docker run --privileged --rm tonistiigi/binfmt --install amd64
    fi
  '' else "";

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

  virtualisation.docker = {
    autoPrune.dates = "daily";
    autoPrune.enable = true;
    enable = true;
  };
}
