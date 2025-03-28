{
  pkgs,
  ...
}:

{
  environment.etc."docker/compose.yaml" = {
    mode = "0440";

    text = ''
      # https://docs.docker.com/compose/compose-file/
      ---
      networks:
        general:
          driver_opts:
            com.docker.network.bridge.name: br-d4r-general
          ipam:
            config:
              - subnet: 172.20.0.0/16
      services:
        portainer:
          container_name: portainer
          image: portainer/portainer-ee:2.26.1-alpine # https://hub.docker.com/r/portainer/portainer-ee/tags
          networks:
            general:
              ipv4_address: 172.20.0.10
          ports:
            - "127.0.0.1:9000:9000/tcp"
          restart: always
          volumes:
            - "portainer:/data:rw"
            - "/var/run/docker.sock:/var/run/docker.sock:ro"
      volumes:
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
