{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = [
    ../desktops/gnome.nix
  ];

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "tailscale-performance" ''
        if [ "''${DEVICE_IFACE}" == "enp0s1" ] && [ "''${2}" == "up" ]
        then
          ${pkgs.ethtool.out}/bin/ethtool --features ''${DEVICE_IFACE} rx-gro-list off rx-udp-gro-forwarding on
          logger "Tailscale performance features enabled for ''${DEVICE_IFACE}"
        fi
      '';

      type = "basic";
    }
  ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };
}
