{
  custom,
  pkgs-unstable,
  ...
}: {
  services = {
    avahi.enable = false;

    chrony = {
      enable = true;
      enableNTS = true;

      extraConfig = ''
        makestep 1 -1
        maxdistance 31536000
      '';

      servers = [
        "nts.netnod.se"
        "time.cloudflare.com"
      ];
    };

    fprintd.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    iperf3.enable = true;

    openiscsi = {
      enable = true;
      name = "iqn.2025-07.org.nixos:${custom.host.name}";
    };

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
          custom.user.name
        ];

        AllowUsers = [
          custom.user.name
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
        "--operator ${custom.user.name}"
        "--ssh"
      ];

      package = pkgs-unstable.tailscale;
    };

    zerotierone = {
      enable = true;

      joinNetworks = [
        "0cccb752f74de851"
      ];
    };
  };
}
