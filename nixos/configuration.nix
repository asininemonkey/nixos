{
  config,
  custom,
  lib,
  pkgs,
  pkgs-unstable,
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

    kernelPackages = pkgs.linuxPackages_6_14;

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

  environment = {
    etc."1password/custom_allowed_browsers" = {
      mode = "0444";

      text = ''
        chromium
        ungoogled-chromium
      '';
    };

    defaultPackages = lib.mkForce [];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages =
      (with pkgs; [
        (hiPrio papirus-icon-theme)

        amazon-ecr-credential-helper
        chiaki
        darktable
        devbox
        dive
        dmidecode
        docker-credential-helpers
        dufs
        esptool
        exfat
        eza
        freerdp
        geekbench
        glow
        gnumake
        gpu-viewer
        iperf
        kind
        kubectl
        kubelogin-oidc
        kubernetes-helm
        ldns
        libreoffice-fresh
        makemkv
        nvme-cli
        obsidian # Move to Home Manager 25.11
        p7zip
        pamixer
        pavucontrol
        pciutils
        pcloud
        prusa-slicer
        pupdate
        pv
        qalculate-qt
        qpdf
        speedtest-cli
        sqlitestudio
        sublime-merge
        tailspin
        tree
        unzip
        usbutils
        vlc
        wakelan
        wayland-utils
        wget
        wl-clipboard-rs
      ])
      ++ (with pkgs-unstable; [
        bitwarden-cli
        bitwarden-desktop
        signal-desktop
      ]);

    variables = {
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    };
  };

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
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  imports = [
    ./desktop-${custom.desktop}.nix
    ./disko.nix
    ./flatpak.nix
    ./llms.nix
    ./nvidia.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./unfree.nix
    ./virtualisation.nix
  ];

  networking = {
    firewall = {
      checkReversePath = "loose";
      enable = true;

      trustedInterfaces = [
        "cni0"
        "docker0"
        "incusbr0"
        "tailscale0"
        "virbr0"
      ];
    };

    hostName = custom.host.name;

    networkmanager = {
      dispatcherScripts = [
        {
          source = pkgs.writeText "tailscale-performance" ''
            if [ "''${DEVICE_IFACE}" == "${custom.host.network.interface}" ] && [ "''${2}" == "up" ]
            then
              ${pkgs.ethtool.out}/bin/ethtool --features ''${DEVICE_IFACE} rx-gro-list off rx-udp-gro-forwarding on
              logger "Tailscale performance features enabled for ''${DEVICE_IFACE}"
            fi
          '';

          type = "basic";
        }
      ];

      enable = true;
    };

    nftables.enable = true;
  };

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
        "wheel"
      ];

      group = custom.user.name;
      initialPassword = "password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
