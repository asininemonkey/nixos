{custom, ...}: {
  home.file = {
    ".config/go/telemetry/mode".text = "off 2025-01-01";

    ".config/sublime-merge/Packages/User/Preferences.sublime-settings".text = builtins.toJSON {
      editor_path = "zeditor";
      font_face = custom.font.mono.name;
      font_size = custom.font.mono.size;
      hardware_acceleration = "opengl";
      signature_error_highlighting = "no_signature";
      theme = "Merge Dark.sublime-theme";
      time_format = "12h";
      update_check = false;
    };

    ".config/sublime-text/Packages/User/Preferences.sublime-settings".text = builtins.toJSON {
      font_face = custom.font.mono.name;
      font_size = custom.font.mono.size;
      hardware_acceleration = "opengl";
      theme = "Default Dark.sublime-theme";
      update_check = false;
    };

    ".config/wireplumber/wireplumber.conf.d/disable-devices.conf".text = ''
      monitor.alsa.rules = [
        {
          actions = {
            update-props = {
              device.disabled = true
            }
          }

          matches = [
            {
              device.name = "~alsa_card.pci-*"
            }
          ]
        }
      ]
    '';

    ".config/Yubico/u2f_keys".text = ''
      # pamu2fcfg --verbose
      ${custom.user.name}:rUeVf/icwSj3xHgke0d1YmK9+JP69H+d6sl4UPykbpGXhChFQkX3Vrn+XOGe1yZ15L1id8HcXwPgFaT26cRvMA==,Hh9Qc6JnS6UW6u+s6cDS5cbH4u21/OhCMDsPxegQCCrtqks3pCsUO6DlckWDWqJaon2bkSsdt9xcQNk03pHBig==,es256,+presence
    '';

    ".hidden".text = "Public";

    "Documents/Backups/Enhancer for YouTube.json".text = builtins.toJSON {
      settings = {
        controlbar = {
          active = false;
        };

        controls = [
          "cards-end-screens"
          "cinema-mode"
          "screenshot"
          "video-filters"
        ];

        controlsvisible = true;
        darktheme = true;
        defaultvolume = true;
        disableautoplay = true;
        hiderelated = true;
        hideshorts = true;
        miniplayerposition = "_top-right";
        newestcomments = true;
        qualityembeds = "hd720";
        qualityembedsfullscreen = "hd1080";
        qualityplaylists = "hd1080";
        qualityplaylistsfullscreen = "hd2160";
        qualityvideos = "hd1080";
        qualityvideosfullscreen = "hd2160";
        selectquality = true;
        selectqualityfullscreenoff = true;
        selectqualityfullscreenon = true;
        volume = 75;
      };

      version = "2.0.130.1";
    };

    "Documents/Source/Go/devbox.json".text = builtins.toJSON {
      env = {
        GOBIN = "\${DEVBOX_PROJECT_ROOT}/.go/bin";
        GOCACHE = "\${DEVBOX_PROJECT_ROOT}/.go/cache";
        GOENV = "\${DEVBOX_PROJECT_ROOT}/.go/env";
        GOPATH = "\${DEVBOX_PROJECT_ROOT}/.go";
      };

      packages = [
        "go@latest"
      ];

      shell = {
        init_hook = [
          "export PATH=\${PATH}\${PATH:+:}\${GOBIN}"
        ];

        scripts = {};
      };
    };

    "Documents/Virtual Machines/quickemu/nixos-minimal.clean" = {
      executable = true;

      text = ''
        #!/usr/bin/env bash

        if [ ! -d nixos-minimal ]
        then
          mkdir nixos-minimal

          curl \
            --location \
            --output 'nixos-minimal/latest-nixos-minimal-x86_64-linux.iso' \
            'https://releases.nixos.org/nixos/25.05/nixos-25.05.805852.29e290002bff/nixos-minimal-25.05.805852.29e290002bff-x86_64-linux.iso'
        fi

        rm --force nixos-minimal/.lock
        rm --force nixos-minimal/*.fd
        rm --force nixos-minimal/*.qcow2
        rm --force nixos-minimal/*.sock*
        rm --force nixos-minimal/nixos-minimal.*
      '';
    };

    "Documents/Virtual Machines/quickemu/nixos-minimal.conf" = {
      executable = true;

      text = ''
        #!/run/current-system/sw/bin/quickemu --vm
        cpu_cores="4"
        disk_img="nixos-minimal/disk.qcow2"
        disk_size="64G"
        guest_os="linux"
        iso="nixos-minimal/latest-nixos-minimal-x86_64-linux.iso"
        preallocation="metadata"
      '';
    };

    "Documents/Virtual Machines/quickemu/windows-11.clean" = {
      executable = true;

      text = ''
        #!/usr/bin/env bash

        if [ ! -d windows-11 ]
        then
          mkdir windows-11

          curl \
            --location \
            --output 'windows-11/latest-windows-11.iso' \
            'https://${custom.webdav.server}/iso-images/windows/Win11_24H2_English_International_x64.iso'

          curl \
            --location \
            --output 'windows-11/virtio-win.iso' \
            'https://${custom.webdav.server}/iso-images/windows/virtio-win-0.1.266.iso'
        fi

        rm --force windows-11/.lock
        rm --force windows-11/*.fd
        rm --force windows-11/*.qcow2
        rm --force windows-11/*.sock*
        rm --force windows-11/tpm2*.*
        rm --force windows-11/windows-11.*
      '';
    };

    "Documents/Virtual Machines/quickemu/windows-11.conf" = {
      executable = true;

      text = ''
        #!/run/current-system/sw/bin/quickemu --vm
        cpu_cores="4"
        disk_img="windows-11/disk.qcow2"
        disk_size="64G"
        fixed_iso="windows-11/virtio-win.iso"
        guest_os="windows"
        iso="windows-11/latest-windows-11.iso"
        preallocation="metadata"
        secureboot="on"
        tpm="on"
      '';
    };
  };
}
