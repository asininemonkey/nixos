{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    aircrack-ng
    cryptomator
    hashcat
    hcxtools
    lynis
    nmap
    popeye
    pwgen
  ];

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

    polkit.enable = true;
    rtkit.enable = true;

    sudo = {
      configFile = ''
        Defaults timestamp_timeout=5
      '';

      execWheelOnly = true;
    };

    wrappers = {
      ping6 = {
        capabilities = "cap_net_raw+p";
        group = "root";
        owner = "root";
        source = "${pkgs.inetutils.out}/bin/ping6";
      };
    };
  };
}
