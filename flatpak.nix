{
  pkgs,
  ...
}:

{
  services.flatpak.enable = true;

  system.activationScripts.flatpak = ''
    if [[ ''${NIXOS_ACTION} = 'switch' ]] && ping -c 3 -W 3 1.1.1.1
    then
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --prio 1 'flathub' 'https://flathub.org/repo/flathub.flatpakrepo'

      for APPLICATION in \
        'com.github.tchx84.Flatseal' \
        'io.github.flattool.Warehouse'
      do
        ${pkgs.flatpak}/bin/flatpak install --noninteractive --or-update 'flathub' "''${APPLICATION}"
      done

      if [[ "$(uname --machine)" == 'x86_64' ]]
      then
        for APPLICATION in \
          'com.usebottles.bottles'
        do
          ${pkgs.flatpak}/bin/flatpak install --noninteractive --or-update 'flathub' "''${APPLICATION}"
        done
      fi

      ${pkgs.flatpak}/bin/flatpak uninstall --noninteractive --unused

      ${pkgs.gnused}/bin/sed --in-place 's/^min-free-space-size.*/min-free-space-size=8192MB/' /var/lib/flatpak/repo/config
    fi
  '';
}
