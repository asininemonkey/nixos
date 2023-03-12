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
    ./hardware-configuration.nix
  ];

  networking.hostName = "intel-nuc";

  system.stateVersion = "${state-version}";
}
