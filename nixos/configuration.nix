{
  config,
  custom,
  lib,
  pkgs,
  ...
}: {
  boot = {
    extraModprobeConfig = ''
      options kvm ignore_msrs=1
    '';

    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv6.conf.all.forwarding" = 1;
    };

    kernelModules = [
      "sg" # Required by MakeMKV
    ];

    kernelPackages = pkgs.linuxPackages_6_16;

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        configurationLimit = 15;
        enable = true;
      };
    };

    supportedFilesystems = [
      "nfs"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  documentation.nixos.enable = false;

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [
          custom.font.mono.name
        ];

        sansSerif = [
          custom.font.sans.name
        ];
      };
    };

    fontDir.enable = true;

    packages = with pkgs; [
      custom.font.mono.package
      custom.font.sans.package
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.enable = true;

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

    sane.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  imports = [
    ./desktop-${custom.desktop}.nix
    ./disko.nix
    ./environment.nix
    ./flatpak.nix
    ./llms.nix
    ./networking.nix
    ./nvidia.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./unfree.nix
    ./virtualisation.nix
  ];

  nix.settings = {
    allowed-users = [
      "@wheel"
    ];

    # download-buffer-size = 1073741824; # Unsupported by Lix

    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  nixpkgs.hostPlatform = custom.host.system;

  system = {
    activationScripts.nvd = {
      supportsDryActivation = true;

      text = ''
        if [[ ''${NIXOS_ACTION} = 'switch' ]]
        then
          "${pkgs.nvd}/bin/nvd" --nix-bin-dir "${pkgs.nix}/bin" diff /run/current-system "$systemConfig"
        fi
      '';
    };

    stateVersion = "25.05";
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=2048";

    services.fprintd = {
      serviceConfig.Type = "simple";

      wantedBy = [
        "multi-user.target"
      ];
    };
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/London";
  };

  users = {
    groups."${custom.user.name}".gid = 1000;

    users."${custom.user.name}" = {
      description = custom.user.full;

      extraGroups = [
        "dialout"
        "docker"
        "input"
        "incus-admin"
        "libvirtd"
        "networkmanager"
        "scanner"
        "wheel"
      ];

      group = custom.user.name;
      initialPassword = "password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
