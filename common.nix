{ config, pkgs, ... }:

let
  nixos-unstable = builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz";
in

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.grub = { # https://nixos.org/manual/nixos/stable/options.html#opt-boot.loader.grub.enable
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
  };

  console.useXkbConfig = true;

  documentation.nixos.enable = false;

  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      cheese
      epiphany
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

    systemPackages = (with pkgs; [
      ascii-image-converter
      btop
      celluloid
      dconf2nix
      docker-compose
      ft2-clone
      gnome-firmware
      gnumake
      hunspell
      hunspellDicts.en-gb-ise
      inkscape
      jq
      ldns
      libreoffice-fresh
      macchina
      mullvad-vpn
      ntfs3g
      nvme-cli
      packagekit
      papirus-icon-theme
      prettyping
      signal-desktop
      speedtest-cli
      tmux
      tootle
      tree
      unzip
      wget
    ]) ++ (with pkgs.gnome; [
      dconf-editor
      gnome-tweaks
    ]) ++ (with pkgs.gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      extension-list
      gtile
      just-perfection
      lock-keys
      noannoyance-2
      quick-settings-tweaker
      removable-drive-menu
      simple-system-monitor
      tiling-assistant
      user-themes
      window-list
    ]) ++ (with pkgs.unstable; [
      asdf-vm
      quickemu
    ]);
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka"
        ];

        sansSerif = [
          "Vegur"
        ];
      };
    };

    fontDir.enable = true;

    fonts = with pkgs; [
      iosevka
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      vegur
    ];
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  networking = {
    firewall.checkReversePath = "loose";
    networkmanager.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;

    packageOverrides = pkgs: {
      unstable = import nixos-unstable {
        config = config.nixpkgs.config;
      };
    };
  };

  programs = {
    _1password-gui = {
      enable = true;

      polkitPolicyOwners = [
        "jcardoso"
      ];
    };
  };

  security = {
    rtkit.enable = true;
  };

  services = {
    avahi.enable = false;

    flatpak.enable = true;

    fwupd.enable = true;

    mullvad-vpn.enable = true;

    openssh = {
      ciphers = [
        "aes256-gcm@openssh.com"
        "aes256-ctr"
      ];

      kbdInteractiveAuthentication = false;

      kexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "curve25519-sha256"
      ];

      macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-512"
      ];

      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    pipewire = {
      alsa.enable = true;
      enable = true;
      pulse.enable = true;
    };

    printing.enable = true;

    sshd.enable = true;

    tailscale.enable = true;

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

  system.activationScripts.flatpak = ''
    if [[ ! -f /var/lib/flatpak/repo/flathub.trustedkeys.gpg ]]
    then
      ${pkgs.flatpak}/bin/flatpak repair
      ${pkgs.gnused}/bin/sed --in-place 's/^min-free-space-size.*/min-free-space-size=8192MB/' /var/lib/flatpak/repo/config
      ${pkgs.curl}/bin/curl --location --output /var/lib/flatpak/repo/flathub.trustedkeys.gpg --silent https://dl.flathub.org/repo/flathub.gpg

      echo '[remote "flathub"]'               >> /var/lib/flatpak/repo/config
      echo 'gpg-verify-summary=true'          >> /var/lib/flatpak/repo/config
      echo 'gpg-verify=true'                  >> /var/lib/flatpak/repo/config
      echo 'url=https://dl.flathub.org/repo/' >> /var/lib/flatpak/repo/config
    fi
  '';

  time.timeZone = "Europe/London";

  users.users.jcardoso = {
    description = "Jose Cardoso";

    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];

    initialPassword = "password";

    isNormalUser = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYDHpVs4nKaLG+tnLUGH+4Ivnq9ELPW0S3W/uJhxNd/"
    ];

    shell = pkgs.zsh;
  };

  virtualisation = {
    docker = {
      autoPrune.dates = "daily";
      autoPrune.enable = true;
    };

    oci-containers = {
      backend = "docker";

      containers = {
        portainer = {
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.portainer.stripprefix.prefixes=/portainer"
            "--label=traefik.http.routers.portainer.entrypoints=web"
            "--label=traefik.http.routers.portainer.middlewares=portainer"
            "--label=traefik.http.routers.portainer.rule=PathPrefix(`/portainer`)"
            "--label=traefik.http.services.portainer.loadbalancer.server.port=9000"
          ];

          image = "portainer/portainer-ee";

          volumes = [
            "portainer:/data:rw"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        traefik = {
          environment = {
            TRAEFIK_API = "true";
            TRAEFIK_ENTRYPOINTS_WEB = "true";
            TRAEFIK_ENTRYPOINTS_WEB_ADDRESS = ":80";
            TRAEFIK_PROVIDERS_DOCKER = "true";
            TRAEFIK_PROVIDERS_DOCKER_EXPOSEDBYDEFAULT = "false";
          };

          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.traefik.stripprefix.prefixes=/traefik"
            "--label=traefik.http.routers.traefik.entrypoints=web"
            "--label=traefik.http.routers.traefik.middlewares=traefik"
            "--label=traefik.http.routers.traefik.rule=PathPrefix(`/api`) || PathPrefix(`/traefik`)"
            "--label=traefik.http.routers.traefik.service=api@internal"
          ];

          image = "traefik";

          ports = [
            "127.0.0.1:80:80/tcp"
          ];

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
        };

        whoami = {
          extraOptions = [
            "--label=traefik.enable=true"
            "--label=traefik.http.middlewares.whoami.stripprefix.prefixes=/whoami"
            "--label=traefik.http.routers.whoami.entrypoints=web"
            "--label=traefik.http.routers.whoami.middlewares=whoami"
            "--label=traefik.http.routers.whoami.rule=PathPrefix(`/whoami`)"
            "--label=traefik.http.services.whoami.loadbalancer.server.port=80"
          ];

          image = "traefik/whoami";
        };
      };
    };
  };
}
