{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    extraModprobeConfig = ''
      options kvm ignore_msrs=1
    '';

    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv6.conf.all.forwarding" = 1;
    };

    loader.grub = {
      configurationLimit = 10;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;

      theme = pkgs.fetchFromGitHub {
        owner = "shvchk";
        repo = "fallout-grub-theme";
        rev = "2c51d28701c03c389309e34585ca8ff2b68c23e9";
        sha256 = "sha256-iQU1Rv7Q0BFdsIX9c7mxDhhYaWemuaNRYs+sR1DF0Rc=";
      };
    };
  };

  console = {
    earlySetup = true;

    packages = with pkgs; [
      terminus_font
    ];

    useXkbConfig = true;
  };

  documentation.nixos.enable = false;

  environment = {
    defaultPackages = lib.mkForce [];

    shells = (with pkgs; [
      zsh
    ]);

    systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
      cider
      # cryptomator
      pcloud
      quickemu
      signal-desktop
    ] else []) ++ (with pkgs; [
      aha
      amazon-ecr-credential-helper
      ascii-image-converter
      awscli2
      btop
      clinfo
      devbox
      distrobox
      dive
      docker-credential-helpers
      dufs
      exfat
      eza
      fastfetch
      geekbench
      gh
      gitkraken
      glow
      glxinfo
      gnumake
      go
      gpu-viewer
      helm-ls # Zed Editor
      hunspell
      hunspellDicts.en-gb-ise
      iftop
      immich-cli
      iperf
      jq
      k9s
      kind
      kitty
      krita
      kubectl
      kubelogin-oidc
      kubernetes-helm
      ldns
      libreoffice-fresh
      lm_sensors
      lynis
      moonlight-qt
      nano
      nfs-utils
      nixd # Zed Editor
      nmap
      ntfs3g
      nvme-cli
      obsidian
      ollama
      p7zip
      packagekit
      papirus-icon-theme
      parted
      pciutils
      popeye
      pv
      pwgen
      qpdf
      speedtest-cli
      step-cli
      tailspin
      terramate
      tmux
      tree
      trippy
      unzip
      usbutils
      ventoy
      virt-viewer
      vlc
      vulkan-tools
      wakelan
      wayland-utils
      wget
      wl-clipboard
      yt-dlp
    ]) ++ (with pkgs.unstable; [
      ktailctl
    ]);

    variables = {
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka Nerd Font"
        ];

        sansSerif = [
          "Arcticons Sans"
        ];
      };
    };

    fontDir.enable = true;

    packages = with pkgs; ([
      (nerdfonts.override { fonts = [
        "Iosevka"
      ]; })

      arcticons-sans
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ]);
  };

  hardware = {
    graphics.enable = true;
    pulseaudio.enable = false;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  networking = {
    firewall = {
      checkReversePath = "loose";
      enable = true;

      trustedInterfaces = [
        "cni0"
        "docker0"
        "tailscale0"
      ];
    };

    networkmanager.enable = true;
    nftables.enable = true;
  };

  nix.settings = {
    allowed-users = [
      "@wheel"
    ];

    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    _1password.enable = true;

    _1password-gui = {
      enable = true;

      polkitPolicyOwners = [
        "jcardoso"
      ];
    };

    adb.enable = true;

    ssh.knownHostsFiles = with pkgs; [
      (writeText "github-host-keys" ''
        github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
      '')

      (writeText "gitlab-host-keys" ''
        gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
      '')
    ];

    virt-manager.enable = true;
    zsh.enable = true;
  };

  security = {
    pam = {
      services = {
        login = {
          fprintAuth = lib.mkForce true;
          u2fAuth = true;
        };

        sudo = {
          fprintAuth = true;
          u2fAuth = true;
        };
      };

      u2f = {
        enable = true;
        settings.cue = true;
      };
    };

    rtkit.enable = true;
    sudo.execWheelOnly = true;

    wrappers = {
      ping6 = {
        capabilities = "cap_net_raw+p";
        group = "root";
        owner = "root";
        source = "${pkgs.inetutils.out}/bin/ping6";
      };

      trip = {
        capabilities = "cap_net_raw+p";
        group = "root";
        owner = "root";
        source = "${pkgs.trippy.out}/bin/trip";
      };
    };
  };

  services = {
    avahi.enable = false;

    chrony = {
      enable = true;

      extraConfig = ''
        makestep 1 -1
        maxdistance 31536000
      '';
    };

    fprintd.enable = true;
    fwupd.enable = true;
    iperf3.enable = true;
    ollama.enable = true;

    openssh = {
      extraConfig = ''
        # https://cisofy.com/lynis/controls/SSH-7408/

        AllowAgentForwarding no
        AllowTcpForwarding no
        ClientAliveCountMax 2
        ListenAddress 127.0.0.1
        MaxAuthTries 3
        MaxSessions 2
        TCPKeepAlive no
      '';

      openFirewall = false;

      ports = [
        2222
      ];

      settings = {
        AllowGroups = [
          "jcardoso"
        ];

        AllowUsers = [
          "jcardoso"
        ];

        Ciphers = [
          "aes256-gcm@openssh.com"
          "aes256-ctr"
        ];

        KbdInteractiveAuthentication = false;

        KexAlgorithms = [
          "curve25519-sha256@libssh.org"
          "curve25519-sha256"
        ];

        LogLevel = "VERBOSE";

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-512"
        ];

        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    pipewire = {
      alsa.enable = true;
      enable = true;
      pulse.enable = true;
    };

    printing.enable = true;
    sshd.enable = true;

    tailscale = {
      enable = true;

      extraUpFlags = [
        "--advertise-exit-node"
        "--operator jcardoso"
        "--ssh"
      ];

      package = pkgs.unstable.tailscale;
    };

    xserver.xkb.layout = "gb";
  };

  system.activationScripts.nvd = {
    supportsDryActivation = true;

    text = ''
      if [[ ''${NIXOS_ACTION} = 'switch' ]]
      then
        "${pkgs.nvd}/bin/nvd" --nix-bin-dir "${pkgs.nix}/bin" diff /run/current-system "$systemConfig"
      fi
    '';
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

  time.timeZone = "Europe/London";

  users = {
    groups.jcardoso.gid = 1000;

    users.jcardoso = {
      description = "Jose Cardoso";

      extraGroups = [
        "dialout"
        "docker"
        "libvirtd"
        "networkmanager"
        "wheel"
      ];

      group = "jcardoso";
      initialPassword = "password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
  };
}
