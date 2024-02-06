{ pkgs, ... }:

let
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) {};
in

{
  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
  ];

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [ # nix-alien-find-libs <binary>
      libgcc.lib
    ];
  };
}
