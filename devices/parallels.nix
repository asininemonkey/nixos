{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.unstable.linuxPackages_6_7;

  systemd.services.prlshprint.wantedBy = lib.mkForce [];
}
