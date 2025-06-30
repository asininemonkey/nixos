{...}: {
  boot.initrd.kernelModules = [
    "nvidia"
  ];

  console.earlySetup = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
  };

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config.cudaSupport = true; # https://nixos.wiki/wiki/CUDA

  services = {
    xserver.videoDrivers = [
      "nvidia"
    ];
  };
}
