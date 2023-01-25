{ config, ... }:

{
  boot = {
    initrd = {
      luks.devices."crypt-nixos" = { # Must match 'cryptsetup open <device> <name>'!
        allowDiscards = true;
        device = "/dev/disk/by-uuid/xxx";
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
