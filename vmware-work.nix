{ config, ... }:

{
  imports = [
    ./vmware.nix
    ./work.nix
  ];

  networking.hostName = "vmware-work";
}
