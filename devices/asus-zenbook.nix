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

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".zsh_aliases_device".text = ''
        alias 'tsreset'='sudo tailscale up --accept-routes --operator jcardoso --reset --ssh'
      '';
    };

    programs.zed-editor.userSettings.assistant.default_model.model = "llama3.2:1b";
  };

  imports = [
    ../desktops/kde.nix
  ];

  nixpkgs.config.rocmSupport = true;
  services.fstrim.enable = true;
}
