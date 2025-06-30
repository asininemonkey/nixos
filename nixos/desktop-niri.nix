{
  custom,
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment.systemPackages =
    (with pkgs; [
      nautilus
    ])
    ++ (with pkgs-unstable; [
      xwayland-satellite
    ]);

  programs = {
    niri.enable = true;

    regreet = {
      enable = true;

      settings = {
        background = {
          fit = "Cover";
          path = custom.image.greet;
        };

        GTK.application_prefer_dark_theme = true;

        widget.clock = {
          format = "%A, %B %-d, %Y - %-I:%M %P";
        };
      };
    };
  };

  services = {
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
