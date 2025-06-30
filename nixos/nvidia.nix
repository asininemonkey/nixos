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
    ];

    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nixpkgs.config.cudaSupport = true; # https://nixos.wiki/wiki/CUDA

  services = {
    ollama.acceleration = "cuda";

    xserver.videoDrivers = [
      "nvidia"
    ];
  };
}
