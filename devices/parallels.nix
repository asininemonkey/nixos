{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_6_10;

  services.usbguard.rules = ''
    # usbguard generate-policy

    allow hash "hU2Qj9gjC7b9d7JnIeeTgOMjWTeeXpFmWPoyxBfCHNo=" # FaceTime Camera
    allow hash "spJbV19Qg9bjuHWwDOuH8dsF++u5gTdSRfpoqq9iyW0=" # Virtual Keyboard
    allow hash "OGhQo+Gb5O93UGB/dRNcKjhACPLoAAt4T4B5/rPk1bA=" # Virtual Mouse
    allow hash "1LGSgcVGSUtUHjrsVJ68LNPZFebOXAh7+phPb6c83cw=" # Yubico Yubikey

    allow hash "3D6LGy36OP0yNOs2NQ0J5dv1l6nwBWxVLGeavx7zSJw=" # Host Controller
    allow hash "7wXCgcnhgInrvzPz2jrexNy/jAxMkcnX/wTV9gDjY20=" # Host Controller
    allow hash "mqLRZqGBKW0ruG8/Uc4jraK6qAbX/xhCXu2dNufVrIQ=" # Host Controller

    allow hash "1YgbhxvNdFvl7+HE9XgtTSiCCACxJIsxrezPzM+9Pys=" # Virtual HUB
  '';

  systemd.services.prlshprint.wantedBy = lib.mkForce [];
}
