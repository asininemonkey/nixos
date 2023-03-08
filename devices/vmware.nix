{ config, pkgs, ... }:

{
  environment = {
    etc.vmware-tools.source = "${pkgs.unstable.open-vm-tools}/etc/vmware-tools/*";

    systemPackages = with pkgs.unstable; [
      open-vm-tools
    ];
  };

  home-manager.users.jcardoso = {
    home.file = {
      ".config/gtk-3.0/bookmarks".text = ''
        file:///mnt/hgfs VMware Shared Folders
      '';
    };

    programs.firefox.profiles.jcardoso.settings = {
      "browser.preferences.defaultPerformanceSettings.enabled" = false;
      "layers.acceleration.disabled" = true;
    };
  };

  security.wrappers.vmware-user-suid-wrapper = {
    group = "root";
    owner = "root";
    setuid = true;
    source = "${pkgs.unstable.open-vm-tools}/bin/vmware-user-suid-wrapper";
  };

  services.udev.packages = [
    pkgs.open-vm-tools
  ];

  systemd.mounts = [
    {
      description = "VMware vmblock Fuse Mount";
      options = "subtype=vmware-vmblock,default_permissions,allow_other";
      type = "fuse";
      unitConfig.ConditionVirtualization = "vmware";

      wantedBy = [
        "multi-user.target"
      ];

      what = "${pkgs.unstable.open-vm-tools}/bin/vmware-vmblock-fuse";
      where = "/run/vmblock-fuse";
    }
  ];

  systemd.services.vmware = {
    after = [
      "display-manager.service"
    ];

    description = "VMware Tools Daemon";
    serviceConfig.ExecStart = "${pkgs.unstable.open-vm-tools}/bin/vmtoolsd";
    unitConfig.ConditionVirtualization = "vmware";

    wantedBy = [
      "multi-user.target"
    ];
  };
}
