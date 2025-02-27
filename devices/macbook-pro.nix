{
  pkgs,
  ...
}:

let
  t2AppleAudioDSP = pkgs.fetchFromGitHub {
    owner = "lemmyg";
    repo = "t2-apple-audio-dsp";
    rev = "046f41d69afe7c9c237ecffd86fd0004a1de4dcf";
    sha256 = "sha256-QQE5z/oVybETN11OTibazFrzL+4gRrnpXVFWrxXr4Kw=";
  };
in

{
  environment.systemPackages = (with pkgs; [
    amdgpu_top
    ladspaPlugins
    lsp-plugins
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
      ".config/monitors.xml".source = config.lib.file.mkOutOfStoreSymlink "/etc/monitors.xml";

      ".zsh_aliases_device".text = ''
        alias 'tsmsi'='sudo tailscale up --accept-routes --exit-node msi-pro-work --operator jcardoso --reset --ssh'
        alias 'tsreset'='sudo tailscale up --accept-routes --operator jcardoso --reset --ssh'
      '';
    };

    programs.plasma.powerdevil.AC = {
      autoSuspend.action = "nothing";
      powerButtonAction = "nothing";
    };
  };

  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/apple/t2"
    ../desktops/kde.nix
  ];

  networking = {
    interfaces.enp4s0f1u1.useDHCP = false;

    networkmanager = {
      dispatcherScripts = [
        {
          source = pkgs.writeText "tailscale-performance" ''
            if [ "''${DEVICE_IFACE}" == "wlp5s0" ] && [ "''${2}" == "up" ]
            then
              ${pkgs.ethtool.out}/bin/ethtool --features ''${DEVICE_IFACE} rx-gro-list off rx-udp-gro-forwarding on
              logger "Tailscale performance features enabled for ''${DEVICE_IFACE}"
            fi
          '';

          type = "basic";
        }
      ];

      unmanaged = [
        "enp4s0f1u1"
      ];
    };
  };

  services = {
    fstrim.enable = true;

    pipewire.configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-t2_headset_mic.conf" (builtins.readFile "${t2AppleAudioDSP}/config/10-t2_headset_mic.conf"))
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-t2_mic.conf" (builtins.readFile "${t2AppleAudioDSP}/config/10-t2_mic.conf"))
    ];
  };

  systemd.user.services.pipewire.environment = {
    LADSPA_PATH = "${pkgs.ladspaPlugins}/lib/ladspa";
  };
}
