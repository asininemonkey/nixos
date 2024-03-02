{
  config,
  lib,
  pkgs,
  ...
}:

let
  # arcticons-sans = import ./packages/arcticons-sans/package.nix {
  #   inherit lib;

  #   fetchzip = pkgs.fetchzip;
  #   stdenvNoCC = pkgs.stdenvNoCC;
  # };
in

{
  boot.loader.grub = {
    configurationLimit = 10;
    device = "nodev";
    efiInstallAsRemovable = true;
    efiSupport = true;

    theme = pkgs.fetchFromGitHub {
      owner = "shvchk";
      repo = "fallout-grub-theme";
      rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
      sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
    };
  };

  console = {
    earlySetup = true;
    font = "ter-v32n";

    packages = with pkgs; [
      terminus_font
    ];

    useXkbConfig = true;
  };

  documentation.nixos.enable = false;

  environment = {
    defaultPackages = lib.mkForce [];

    gnome.excludePackages = with pkgs.gnome; [
      cheese
      epiphany
      geary
      gnome-calendar
      gnome-contacts
      gnome-music
      gnome-shell-extensions
      pkgs.gnome-connections
      pkgs.gnome-console
      pkgs.gnome-photos
      pkgs.gnome-text-editor
      pkgs.gnome-tour
      simple-scan
      totem
      yelp
    ];

    shells = (with pkgs; [
      zsh
    ]);

    systemPackages = (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then with pkgs; [
      cryptomator
      mullvad-vpn
      pcloud
      quickemu
      signal-desktop
    ] else []) ++ (with pkgs; [
      ascii-image-converter
      btop
      celluloid
      clinfo
      dconf2nix
      distrobox
      dive
      docker-credential-helpers
      epiphany
      exfat
      eza
      gh
      glow
      gnome-firmware
      gnome.dconf-editor
      gnome.ghex
      gnome.gnome-tweaks
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.appindicator
      gnomeExtensions.extension-list
      gnomeExtensions.just-perfection
      gnomeExtensions.lock-keys
      gnomeExtensions.noannoyance-fork
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.tiling-assistant
      gnomeExtensions.user-themes
      gnomeExtensions.vitals
      gnomeExtensions.window-list
      gnumake
      gpu-viewer
      hunspell
      hunspellDicts.en-gb-ise
      iftop
      immich-cli
      jq
      kubectl
      ldns
      libreoffice-fresh
      macchina
      mullvad
      nano
      ntfs3g
      nvme-cli
      obsidian
      p7zip
      packagekit
      papirus-icon-theme
      parted
      pciutils
      pwgen
      qpdf
      remmina
      speedtest-cli
      tmux
      tree
      unzip
      usbutils
      virt-viewer
      vlc
      wakelan
      wezterm
      wget
    ]) ++ (with pkgs.unstable; [
      geekbench
      k9s
      ollama
      trippy
    ]);
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Fantasque Sans Mono"
        ];

        sansSerif = [
          "Arcticons Sans"
        ];
      };
    };

    fontDir.enable = true;

    packages = with pkgs; ([
      fantasque-sans-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ]) ++ (with pkgs.unstable; [
      arcticons-sans
    ]);
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  networking = {
    firewall = {
      allowedTCPPorts = [
        6443 # k3s - api
        10250 # k3s - metrics-server
      ];

      checkReversePath = "loose";
      enable = true;
      
      trustedInterfaces = [
        "docker0"
        "tailscale0"
      ];
    };
 
    networkmanager.enable = true;
    nftables.enable = true;

    timeServers = [
      "nts.netnod.se"
      "time.cloudflare.com"
    ];
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];

  programs = {
    _1password.enable = true;

    _1password-gui = {
      enable = true;

      polkitPolicyOwners = [
        "jcardoso"
      ];
    };

    adb.enable = true;

    noisetorch.enable = true;

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

    zsh.enable = true;
  };

  security = {
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
        source = "${pkgs.unstable.trippy.out}/bin/trip";
      };
    };
  };

  services = {
    avahi.enable = false;

    chrony = {
      enable = true;
      enableNTS = true;

      extraConfig = ''
        makestep 1 -1
        maxdistance 31536000
      '';
    };

    fwupd.enable = true;
    iperf3.enable = true;

    k3s = {
      enable = true;
      package = pkgs.unstable.k3s;
    };

    mullvad-vpn.enable = true;

    openssh = {
      openFirewall = false;

      settings = {
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
      package = pkgs.unstable.tailscale;
    };

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      enable = true;

      excludePackages = with pkgs; [
        xterm
      ];

      layout = "gb";
    };
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

  time.timeZone = "Europe/London";

  users = {
    groups.jcardoso.gid = 1000;

    users.jcardoso = {
      description = "Jose Cardoso";

      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
      ];

      group = "jcardoso";
      initialPassword = "password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
