{
  custom,
  pkgs,
  pkgs-unstable,
  ...
}: let
  sddm-sugar-dark = pkgs.sddm-sugar-dark.override {
    themeConfig = {
      Background = "\"${custom.image.sddm}\"";
      DateFormat = "\"dddd, MMMM d, yyyy\"";
      HeaderText = "\"Welcome\"";
      HourFormat = "\"h:mm a\"";
    };
  };
in {
  environment.systemPackages =
    (with pkgs; [
      nautilus
      sddm-sugar-dark
    ])
    ++ (with pkgs-unstable; [
      xwayland-satellite
    ]);

  programs.niri.enable = true;

  services = {
    displayManager.sddm = {
      enable = true;

      extraPackages = with pkgs; [
        libsForQt5.qt5.qtgraphicaleffects
        libsForQt5.qt5.qtvirtualkeyboard
      ];

      # package = pkgs.kdePackages.sddm; # Qt 6

      settings = {
        General = {
          InputMethod = "qtvirtualkeyboard";
        };
      };

      theme = "sugar-dark";
      wayland.enable = true;
    };

    gvfs.enable = true;

    xserver = {
      enable = true;

      excludePackages = with pkgs; [
        xterm
      ];

      xkb.layout = "gb";
    };
  };
}
