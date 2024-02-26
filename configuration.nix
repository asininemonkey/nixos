{
  config,
  lib,
  pkgs,
  ...
}:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  nixos-unstable = fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
  state-version = "23.11";
in

{
  home-manager.users.jcardoso.home.stateVersion = "${state-version}";

  imports = [
    (import "${home-manager}/nixos")
    ./common.nix
    ./crypt.nix
    ./device-configuration.nix
    ./docker.nix
    ./flatpak.nix
    ./hardware-configuration.nix
    ./home-manager.nix
    ./issues.nix
    ./nix-alien.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;

      packageOverrides = pkgs: with pkgs; {
        unstable = import nixos-unstable {
          config = config.nixpkgs.config;
        };
      };

      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };

    overlays = [
      (self: super: {
        inherit (import nixos-unstable {
          config = config.nixpkgs.config;
        }) gnomeExtensions;
      })
    ];
  };

  system.stateVersion = "${state-version}";
}
