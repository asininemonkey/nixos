{
  config,
  ...
}:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-${state-version}.tar.gz";
  nixos-unstable = fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
  state-version = "24.11";
in

{
  home-manager.users.jcardoso.home.stateVersion = "${state-version}";

  imports = [
    (home-manager + "/nixos")
    ./ai.nix
    ./common.nix
    ./crypt.nix
    ./device-configuration.nix
    ./docker.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./home-manager.nix
    ./security.nix
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import nixos-unstable {
      config = config.nixpkgs.config;
    };
  };

  system.stateVersion = "${state-version}";
}
