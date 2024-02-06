{ config, pkgs, ... }:

{
  # # https://github.com/nix-community/home-manager/issues/4879
  # home-manager.users.jcardoso = {
  #   manual.html.enable = false;
  #   manual.json.enable = false;
  #   manual.manpages.enable = false;
  # };

  # # https://github.com/nixos/nixpkgs/issues/244159
  # nixpkgs.overlays = [(
  #   let
  #     pinnedPkgs = import(pkgs.fetchFromGitHub {
  #       owner = "NixOS";
  #       repo = "nixpkgs";
  #       rev = "b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc";
  #       sha256 = "sha256-JVFoTY3rs1uDHbh0llRb1BcTNx26fGSLSiPmjojT+KY=";
  #     }) {};
  #   in
  #   final: prev: {
  #     docker = pinnedPkgs.docker;
  #   }
  # )];
}
