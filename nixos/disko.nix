{
  disko.devices = {
    disk = {
      main = {
        content = {
          partitions = {
            boot = {
              content = {
                format = "vfat";
                mountOptions = ["umask=0077"];
                mountpoint = "/boot";
                type = "filesystem";
              };

              size = "1024M";
              type = "EF00";
            };

            root = {
              content = {
                format = "ext4";
                mountpoint = "/";
                type = "filesystem";
              };

              size = "100%";
            };
          };

          type = "gpt";
        };

        device = "/dev/disk/by-id/nvme-eui.6479a74c90201298";
        # device = "/dev/vda";
        type = "disk";
      };
    };
  };
}
