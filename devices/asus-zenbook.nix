{ config, pkgs, ... }:

{
  boot = {
    initrd.kernelModules = [
      "amdgpu" # Required by 'console.earlySetup'
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    printers = {
      ensureDefaultPrinter = "Brother_HL-L8260CDW";

      ensurePrinters = [
        {
          description = "Brother HL-L8260CDW";
          deviceUri = "ipp://192.168.144.10/ipp";
          location = "Study";
          model = "everywhere";
          name = "Brother_HL-L8260CDW";
        }
      ];
    };
  };

  services.fstrim.enable = true;
}
