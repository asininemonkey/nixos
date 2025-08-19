{
  custom,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      checkReversePath = "loose";
      enable = true;

      trustedInterfaces = [
        "cni0"
        "docker0"
        "incusbr0"
        "tailscale0"
        "virbr0"
      ];
    };

    hostName = custom.host.name;

    networkmanager = {
      dispatcherScripts = [
        {
          source = pkgs.writeText "tailscale-performance" ''
            if [ "''${DEVICE_IFACE}" == "${custom.host.network.interface}" ] && [ "''${2}" == "up" ]
            then
              ${pkgs.ethtool.out}/bin/ethtool --features ''${DEVICE_IFACE} rx-gro-list off rx-udp-gro-forwarding on
              logger "Tailscale performance features enabled for ''${DEVICE_IFACE}"
            fi
          '';

          type = "basic";
        }
      ];

      enable = true;
    };

    nftables.enable = true;
  };
}
