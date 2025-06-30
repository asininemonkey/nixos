{
  custom,
  pkgs,
  ...
}: {
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      akonadi
      breeze-icons
      drkonqi
      elisa
      kate
      khelpcenter
      konsole
      plasma-browser-integration
    ];

    systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${custom.image.greet}
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
