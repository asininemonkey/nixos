{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users.jcardoso = { config, ... }: {
    home.file = {
      ".config/wireplumber/wireplumber.conf.d/virtual-machine-audio-fix.conf".text = ''
        monitor.alsa.rules = [
          {
            actions = {
              update-props = {
                api.alsa.headroom = 8192
                api.alsa.period-size = 1024
                session.suspend-timeout-seconds = 0
              }
            }
            matches = [
              {
                node.name = "~alsa_output.*"
              }
            ]
          }
        ]
      '';
    };

    programs.plasma = {
      configFile.kscreenlockerrc = {
        Daemon.Autolock = false;
      };

      powerdevil.AC = {
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
        powerButtonAction = "nothing";
        turnOffDisplay.idleTimeout = "never";
      };
    };
  };

  imports = [
    ../desktops/kde.nix
  ];

  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };
}
