{
  pkgs,
  ...
}:

{
  environment.systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
  ] ++ (with pkgs.unstable; [
    cryptomator
  ]) else []) ++ (with pkgs; [
    aircrack-ng
    hashcat
    hcxtools
    popeye
    pwgen
  ]) ++ (with pkgs.unstable; [
  ]);
}
