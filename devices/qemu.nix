{ config, ... }:

{
  home-manager.users.jcardoso.xdg.desktopEntries.Alacritty = {
    actions.New = {
      exec = "env LIBGL_ALWAYS_SOFTWARE=true alacritty";
      name = "New Terminal";
    };

    categories = [
      "System"
      "TerminalEmulator"
    ];

    comment = "A fast, cross-platform, OpenGL terminal emulator";
    exec = "env LIBGL_ALWAYS_SOFTWARE=true alacritty";
    genericName = "Terminal";
    icon = "Alacritty";
    name = "Alacritty";

    settings = {
      StartupWMClass = "Alacritty";
    };
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };
}
