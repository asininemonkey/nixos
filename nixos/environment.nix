{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment = {
    etc."1password/custom_allowed_browsers" = {
      mode = "0444";

      text = ''
        chromium
        ungoogled-chromium
      '';
    };

    defaultPackages = lib.mkForce [];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages =
      (with pkgs; [
        (hiPrio papirus-icon-theme)

        amazon-ecr-credential-helper
        chiaki
        darktable
        devbox
        dive
        dmidecode
        docker-credential-helpers
        dufs
        esptool
        exfat
        eza
        freerdp
        geekbench
        glow
        gnumake
        gpu-viewer
        iperf
        kind
        kubectl
        kubelogin-oidc
        kubernetes-helm
        ldns
        libreoffice-fresh
        makemkv
        naps2
        nvme-cli
        obsidian # Move to Home Manager 25.11
        p7zip
        pamixer
        pavucontrol
        pciutils
        pcloud
        prusa-slicer
        pupdate
        pv
        qalculate-qt
        qpdf
        speedtest-cli
        sqlitestudio
        sublime-merge
        tailspin
        tree
        unzip
        usbutils
        vlc
        wakelan
        wayland-utils
        wget
        wl-clipboard-rs
      ])
      ++ (with pkgs-unstable; [
        bitwarden-cli
        bitwarden-desktop
        signal-desktop
      ]);

    variables = {
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    };
  };
}
