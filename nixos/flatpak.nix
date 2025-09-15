{lib, ...}: {
  services.flatpak = {
    enable = true;

    packages = [
      {
        appId = "com.github.tchx84.Flatseal";
        origin = "flathub";
      }
      {
        appId = "com.jeffser.Alpaca";
        origin = "flathub";
      }
      {
        appId = "com.usebottles.bottles";
        origin = "flathub";
      }
      {
        appId = "io.github.flattool.Warehouse";
        origin = "flathub";
      }
      {
        appId = "io.github.kolunmi.Bazaar";
        origin = "flathub";
      }
      {
        appId = "io.kinvolk.Headlamp";
        origin = "flathub";
      }
      {
        appId = "me.amankhanna.opendeck";
        origin = "flathub";
      }
    ];

    remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    uninstallUnmanaged = true;
    update.auto.enable = true;
  };
}
