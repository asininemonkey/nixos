{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.flatpak.enable = true;

  system.activationScripts.flatpak = ''
    if [[ ''${NIXOS_ACTION} = 'switch' ]]
    then
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --prio 1 'flathub' 'https://flathub.org/repo/flathub.flatpakrepo'
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --prio 2 'appcenter' 'https://flatpak.elementary.io/repo.flatpakrepo'

      for APPLICATION in \
        'com.github.johnfactotum.Foliate' \
        'com.github.tchx84.Flatseal' \
        'com.mattjakeman.ExtensionManager' \
        'io.github.flattool.Warehouse' \
        'io.gitlab.news_flash.NewsFlash'
      do
        ${pkgs.flatpak}/bin/flatpak install --noninteractive --or-update 'flathub' "''${APPLICATION}"
      done

      if [[ "$(uname --machine)" == 'x86_64' ]]
      then
        ${pkgs.flatpak}/bin/flatpak install --noninteractive --or-update 'flathub' 'com.usebottles.bottles'
      fi

      ${pkgs.flatpak}/bin/flatpak uninstall --noninteractive --unused

      ${pkgs.gnused}/bin/sed --in-place 's/^min-free-space-size.*/min-free-space-size=8192MB/' /var/lib/flatpak/repo/config
    fi
  '';
}
