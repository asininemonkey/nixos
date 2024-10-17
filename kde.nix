{
  config,
  pkgs,
  ...
}:

let
  plasma-manager = pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "plasma-manager";
    rev = "9d851cebffd92ad3d2c69cc4df7a2c9368b78f73";
    sha256 = "sha256-GMZubGvIEZIpHhb3sw7GIK7hFtHGBijsXQbR8TBAF+U=";
  };
in

{
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      breeze-icons
      kate
      konsole
      plasma-browser-integration
    ];
  };

  home-manager.users.jcardoso = { config, ... }: {
    imports = [
      (plasma-manager + "/modules")
    ];
    
    # https://nix-community.github.io/plasma-manager/options.xhtml
    programs.plasma = {
      configFile = {
        kwinrc.Xwayland.Scale = 1.25;
      };

      enable = true;
      overrideConfig = true;

      workspace = {
        iconTheme = "Papirus-Dark";
        lookAndFeel = "org.kde.breezedark.desktop";
      };
    };
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
