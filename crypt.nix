{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd = {
      luks.devices."crypt-nixos" = { # Must match 'cryptsetup open <device> <name>'!
        allowDiscards = true;
        keyFile = "/etc/crypto_keyfile.bin";
      };

      secrets = {
        "/etc/crypto_keyfile.bin" = null;
      };
    };

    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      grub.enableCryptodisk = true;
    };
  };
}
