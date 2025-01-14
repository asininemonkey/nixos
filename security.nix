{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
  ] else []) ++ (with pkgs; [
    aircrack-ng
    hashcat
    hcxtools
    pwgen
  ]) ++ (with pkgs.unstable; [
  ]);
}
