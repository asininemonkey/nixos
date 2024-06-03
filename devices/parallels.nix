{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  systemd.services.prlshprint.wantedBy = lib.mkForce [];
}
