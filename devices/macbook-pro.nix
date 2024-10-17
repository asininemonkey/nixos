{
  config,
  lib,
  pkgs,
  ...
}:

let
  t2AppleAudioDSP = pkgs.fetchFromGitHub {
    owner = "lemmyg";
    repo = "t2-apple-audio-dsp";
    rev = "9422c57caeb54fde45121b9ea31628080da9d3bd";
    sha256 = "MgKBwE9k9zyltz6+L+VseSiQHS/fh+My0tNDpdllPNw=";
  };
in

{
  environment = {
    etc."monitors.xml" = {
      mode = "0444";

      text = ''
        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1.5</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>eDP-1</connector>
                  <vendor>APP</vendor>
                  <product>Color LCD</product>
                  <serial>0x00000000</serial>
                </monitorspec>
                <mode>
                  <width>3072</width>
                  <height>1920</height>
                  <rate>60.000</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      '';
    };

    systemPackages = (with pkgs; [
      amdgpu_top
      ladspaPlugins
      lsp-plugins
      rocmPackages.clr
    ]);
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    printers = {
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
  };

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/monitors.xml".source = config.lib.file.mkOutOfStoreSymlink "/etc/monitors.xml";
    };
  };

  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/apple/t2"
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

  systemd = {
    tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - /etc/monitors.xml"
    ];

    user.services.pipewire.environment = {
      LADSPA_PATH = "${pkgs.ladspaPlugins}/lib/ladspa";
    };
  };
}
