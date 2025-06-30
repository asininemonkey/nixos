{
  custom,
  pkgs,
  ...
}: {
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      akonadi
      breeze-icons
      elisa
      kate
      konsole
      plasma-browser-integration
    ];

    systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${custom.image.sddm}
      '')
    ];
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;

      wayland = {
        compositor = "kwin";
        enable = true;
      };
    };
  };
}
