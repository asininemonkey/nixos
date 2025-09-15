{config, ...}: {
  boot.initrd.kernelModules = [
    "nvidia"
  ];

  console.earlySetup = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;

    # https://github.com/NixOS/nixpkgs/issues/429624
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
      settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
      sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
      usePersistenced = false;
      version = "580.65.06";
    };

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
