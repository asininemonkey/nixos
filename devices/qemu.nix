{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };
}
