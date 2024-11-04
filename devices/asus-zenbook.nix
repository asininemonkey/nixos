{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd.kernelModules = [
      "amdgpu" # Required by 'console.earlySetup'
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = (with pkgs; [
    amdgpu_top
  ]);

  hardware.printers = {
    ensureDefaultPrinter = "Brother_HL-L8260CDW";

    ensurePrinters = [
      {
        description = "Brother HL-L8260CDW";
        deviceUri = "ipp://192.168.144.11/ipp";
        location = "Study";
        model = "everywhere";
        name = "Brother_HL-L8260CDW";
      }
    ];
  };

  imports = [
    ../desktops/gnome.nix
  ];

  nixpkgs.config.rocmSupport = true;
  services.fstrim.enable = true;
}
