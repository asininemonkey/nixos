{pkgs, ...}: {
  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  console.earlySetup = true;

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  nixpkgs.config.rocmSupport = true;
}
