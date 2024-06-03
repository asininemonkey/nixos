{
  config,
  lib,
  pkgs,
  ...
}:

let
  home-cidr = "192.168.144.0/24";
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-${state-version}.tar.gz";
  state-version = "24.05";
  tailnet-cidr = "100.64.0.0/10";
  tailnet-name = "fable-blues.ts.net";
  tailnet-server = "intel-nuc";
in

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    loader.grub = {
      configurationLimit = 5;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  console.keyMap = "uk";

  environment = {
    defaultPackages = lib.mkForce [];

    shells = (with pkgs; [
      zsh
    ]);
  };

  home-manager.users.jcardoso = { config, ... }: {
    home = {
      file = {
        ".bash_history".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
        ".lesshst".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
        ".zsh_history".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
      };

      stateVersion = "${state-version}";
    };

    programs = {
      zsh = {
        enable = true;

        shellAliases = {
          clean = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
          ncu = "sudo nix-channel --update";
          nrs = "curl --location --silent 'https://raw.githubusercontent.com/asininemonkey/nixos/main/devices/${tailnet-server}.nix' | sudo tee '/etc/nixos/configuration.nix' > '/dev/null' && sudo nixos-rebuild switch";
          nso = "nix --extra-experimental-features nix-command store optimise";
        };
      };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];

  networking = {
    firewall = {
      allowedTCPPorts = [
        111  # NFS v3
        2049 # NFS v3/v4
        4045 # NFS v3
        4046 # NFS v3
        4047 # NFS v3
      ];

      allowedUDPPorts = [
        111  # NFS v3
        2049 # NFS v3/v4
        4045 # NFS v3
        4046 # NFS v3
        4047 # NFS v3
      ];

      checkReversePath = "loose";
      enable = true;
      
      trustedInterfaces = [
        "tailscale0"
      ];
    };
 
    hostName = tailnet-server;
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];

  programs.zsh.enable = true;

  security.sudo.execWheelOnly = true;

  services = {
    fstrim.enable = true;

    k3s = {
      enable = true;
      extraFlags = "--disable traefik --node-label intel.feature.node.kubernetes.io/gpu=true --tls-san ${tailnet-server}.${tailnet-name}"; # https://docs.k3s.io/cli/server
    };

    nfs.server = {
      enable = true;

      exports = ''
        /data/docker        ${tailnet-server}.${tailnet-name}(insecure,no_subtree_check,nohide,rw,sync)

        /data/emulation     ${home-cidr}(insecure,no_subtree_check,nohide,ro,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,ro,sync)
        /data/iso-images    ${home-cidr}(insecure,no_subtree_check,nohide,ro,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,ro,sync)
        /data/media         ${home-cidr}(insecure,no_subtree_check,nohide,ro,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,ro,sync)
        /data/miscellaneous ${home-cidr}(insecure,no_subtree_check,nohide,ro,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,ro,sync)
        /data/rips          ${home-cidr}(insecure,no_subtree_check,nohide,ro,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,ro,sync)
        /data/temporary     ${home-cidr}(insecure,no_subtree_check,nohide,rw,sync) ${tailnet-cidr}(insecure,no_subtree_check,nohide,rw,sync)
      '';

      lockdPort = 4045;  # NFS v3
      mountdPort = 4046; # NFS v3
      statdPort = 4047;  # NFS v3
    };

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

    sshd.enable = true;

    tailscale = {
      enable = true;

      extraUpFlags = [
        "--ssh"
      ];
    };
  };

  system = {
    activationScripts.nvd = {
      supportsDryActivation = true;

      text = ''
        "${pkgs.nvd}/bin/nvd" --nix-bin-dir "${pkgs.nix}/bin" diff /run/current-system "$systemConfig"
      '';
    };

    stateVersion = "${state-version}";
  };

  systemd.services.tailscaled.serviceConfig.BindPaths = "/data/tailscale:/var/lib/tailscale";

  time.timeZone = "Europe/London";

  users = {
    groups = {
      jcardoso.gid = 1000;
      media.gid = 5000;
    };

    users = {
      jcardoso = {
        description = "Jose Cardoso";

        extraGroups = [
          "media"
          "wheel"
        ];

        group = "jcardoso";
        initialPassword = "password";
        isNormalUser = true;
        shell = pkgs.zsh;
        uid = 1000;
      };

      media = {
        description = "Media Services";
        group = "media";
        isSystemUser = true;
        uid = 5000;
      };
    };
  };
}
