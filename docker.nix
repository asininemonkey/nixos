{
  config,
  lib,
  pkgs,
  ...
}:

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
          # environment:
          #   HCC_AMDGPU_TARGETS: "gfx900" # Required for Ryzen 5700G
          #   HSA_OVERRIDE_GFX_VERSION: "9.0.0" # Required for Ryzen 5700G
          image: ollama/ollama:0.1.24-rocm
          networks:
            general:
              ipv4_address: 172.20.0.10
          ports:
            - "127.0.0.1:11434:11434/tcp"
          restart: always
          volumes:
            - "ollama:/root/.ollama:rw"
        ollama-webui:
          container_name: ollama-webui
          depends_on:
            - ollama
          environment:
            OLLAMA_API_BASE_URL: "http://172.20.0.10:11434/api"
          image: ghcr.io/ollama-webui/ollama-webui:main
          networks:
            general:
              ipv4_address: 172.20.0.20
          ports:
            - "127.0.0.1:8080:8080/tcp"
          restart: always
          volumes:
            - "ollama-webui:/app/backend/data:rw"
        portainer:
          container_name: portainer
          image: portainer/portainer-ee
          networks:
            general:
              ipv4_address: 172.20.0.30
          ports:
            - "127.0.0.1:9000:9000/tcp"
          restart: always
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
              ipv4_address: 172.20.0.40
          restart: always
          volumes:
            - "/var/run/docker.sock:/var/run/docker.sock:ro"
      version: '3.8'
      volumes:
        ollama:
        ollama-webui:
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
