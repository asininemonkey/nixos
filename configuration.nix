{ config, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${state-version}.tar.gz";
  state-version = "22.11";
in

{
  home-manager.users.jcardoso = {
    home.stateVersion = "${state-version}";
  };

  imports = [
    (import "${home-manager}/nixos")
    ./common.nix
    ./crypt.nix
    ./hardware-configuration.nix
    ./home-manager.nix
    ./devices/xxxdevicexxx.nix
    ./profiles/xxxprofilexxx.nix
  ];

  networking.hostName = "xxxdevicexxx-xxxprofilexxx";

  system.stateVersion = "${state-version}";
}
