{
  custom,
  pkgs,
  ...
}: let
  output = "DP-1";
in {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };

    "org/gnome/nautilus/preferences" = {
      show-delete-permanently = true;
    };
  };

  gtk = {
    enable = true;

    gtk3 = {
      bookmarks = [
        "davs://${custom.webdav.server}/ ${custom.webdav.name}"
        "davs://100.100.100.100:8080/ tailscale"
      ];

      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    iconTheme.name = "Papirus-Dark";
  };

  home = {
    file = {
      ".config/niri/config.kdl".text = ''
        // https://github.com/YaLTeR/niri/wiki/

        binds {
          Ctrl+Alt+Delete          repeat=false { quit; }

          Mod+B                    hotkey-overlay-title="Spawn Firefox" repeat=false { spawn "firefox"; }
          Mod+E                    hotkey-overlay-title="Spawn Zed" repeat=false { spawn "zeditor"; }
          Mod+N                    hotkey-overlay-title="Spawn Nautilus" repeat=false { spawn "nautilus"; }
          Mod+P                    hotkey-overlay-title="Spawn Bitwarden" repeat=false { spawn "bitwarden"; }
          Mod+S                    hotkey-overlay-title="Spawn Signal" repeat=false { spawn "signal-desktop"; }
          Mod+T                    hotkey-overlay-title="Spawn Ghostty" repeat=false { spawn "ghostty"; }
          Mod+Space                hotkey-overlay-title="Spawn Fuzzel" repeat=false { spawn "fuzzel"; }

          Mod+F1                   allow-inhibiting=false repeat=false { spawn "niri" "msg" "output" "${output}" "scale" "1.00"; }
          Mod+F2                   allow-inhibiting=false repeat=false { spawn "niri" "msg" "output" "${output}" "scale" "1.33"; }
          Mod+F3                   allow-inhibiting=false repeat=false { spawn "niri" "msg" "output" "${output}" "scale" "1.50"; }
          Mod+F4                   allow-inhibiting=false repeat=false { spawn "niri" "msg" "output" "${output}" "scale" "1.66"; }
          Mod+F5                   allow-inhibiting=false repeat=false { spawn "niri" "msg" "output" "${output}" "scale" "2.00"; }

          Mod+H                    allow-inhibiting=false repeat=false { show-hotkey-overlay; }
          Mod+L                    allow-inhibiting=false hotkey-overlay-title="Lock Screen" repeat=false { spawn "swaylock" "--daemonize"; }
          Mod+Q                    allow-inhibiting=false repeat=false { close-window; }

          Mod+Escape               repeat=false { toggle-keyboard-shortcuts-inhibit; }
          Mod+F                    repeat=false { toggle-window-floating; }
          Mod+M                    repeat=false { maximize-column; }
          Mod+O                    repeat=false { toggle-overview; }
          Mod+Print                repeat=false { screenshot show-pointer=false; }
          Mod+R                    repeat=false { switch-preset-column-width; }

          Mod+Ctrl+F               repeat=false { switch-focus-between-floating-and-tiling; }
          Mod+Ctrl+M               repeat=false { fullscreen-window; }
          Mod+Ctrl+Print           repeat=false { screenshot-screen; }

          Mod+Shift+Print          repeat=false { screenshot-window; }
          Mod+Shift+R              repeat=false { switch-preset-window-height; }

          Mod+1                    repeat=false { focus-workspace 1; }
          Mod+2                    repeat=false { focus-workspace 2; }
          Mod+Down                 repeat=false { focus-window-down; }
          Mod+End                  repeat=false { focus-column-last; }
          Mod+Home                 repeat=false { focus-column-first; }
          Mod+Left                 repeat=false { focus-column-left; }
          Mod+Page_Down            repeat=false { focus-workspace-down; }
          Mod+Page_Up              repeat=false { focus-workspace-up; }
          Mod+Right                repeat=false { focus-column-right; }
          Mod+Up                   repeat=false { focus-window-up; }

          Mod+WheelScrollDown      repeat=false { focus-column-right; }
          Mod+WheelScrollUp        repeat=false { focus-column-left; }

          Mod+Ctrl+1               repeat=false { move-column-to-workspace 1; }
          Mod+Ctrl+2               repeat=false { move-column-to-workspace 2; }
          Mod+Ctrl+Down            repeat=false { move-window-down; }
          Mod+Ctrl+End             repeat=false { move-column-to-last; }
          Mod+Ctrl+Home            repeat=false { move-column-to-first; }
          Mod+Ctrl+Left            repeat=false { move-column-left; }
          Mod+Ctrl+Page_Down       repeat=false { move-column-to-workspace-down; }
          Mod+Ctrl+Page_Up         repeat=false { move-column-to-workspace-up; }
          Mod+Ctrl+Right           repeat=false { move-column-right; }
          Mod+Ctrl+Up              repeat=false { move-window-up; }

          Mod+Ctrl+WheelScrollDown repeat=false { move-column-right; }
          Mod+Ctrl+WheelScrollUp   repeat=false { move-column-left; }

          XF86AudioRaiseVolume     allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
          XF86AudioLowerVolume     allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
          XF86AudioMute            allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        }

        cursor {
          hide-after-inactive-ms 5000
          hide-when-typing
          xcursor-size 32
          xcursor-theme "phinger-cursors-light"
        }

        environment {
          DISPLAY ":0"
        }

        hotkey-overlay {
          // hide-not-bound
          skip-at-startup
        }

        input {
          keyboard {
            repeat-delay 500
            repeat-rate 25

            xkb {
              layout "gb"
            }
          }
        }

        layout {
          always-center-single-column
          center-focused-column "on-overflow"
          default-column-width { proportion 0.66666; }

          focus-ring {
            active-color "#89b4fa"
            width 2
          }

          gaps 10

          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66666
          }

          preset-window-heights {
            proportion 0.33333
            proportion 0.5
            proportion 0.66666
          }

          struts {
            top -10
          }
        }

        output "${output}" {
          mode "3440x1440@119.991"
          scale 1.33
          variable-refresh-rate on-demand=true
        }

        prefer-no-csd
        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

        spawn-at-startup "bitwarden"
        spawn-at-startup "mako"
        spawn-at-startup "signal-desktop" "--start-in-tray"
        spawn-at-startup "swww" "img" "${custom.image.wall}"
        spawn-at-startup "waybar"
        spawn-at-startup "xwayland-satellite"

        window-rule {
          clip-to-geometry true
          geometry-corner-radius 10
        }
      '';
    };

    pointerCursor = {
      gtk.enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };
  };

  programs = {
    fuzzel = {
      enable = true;

      settings = {
        border = {
          radius = 5;
          width = 2;
        };

        colors = {
          # https://github.com/catppuccin/fuzzel/blob/main/themes/catppuccin-mocha/blue.ini
          background = "1e1e2edd";
          border = "89b4faff";
          counter = "7f849cff";
          input = "cdd6f4ff";
          match = "89b4faff";
          placeholder = "7f849cff";
          prompt = "bac2deff";
          selection = "585b70ff";
          selection-match = "89b4faff";
          selection-text = "cdd6f4ff";
          text = "cdd6f4ff";
        };

        main = {
          font = "${custom.font.sans.name}:size=${toString custom.font.sans.size}";
          inner-pad = 8;
          match-counter = true;
          use-bold = true;
        };
      };
    };

    swaylock = {
      enable = true;

      settings = {
        ignore-empty-password = true;
        image = custom.image.lock;
        indicator-caps-lock = true;
        indicator-radius = 75;
        indicator-thickness = 25;
        show-failed-attempts = true;
        show-keyboard-layout = true;

        # https://github.com/catppuccin/swaylock/blob/main/themes/mocha.conf
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        color = "1e1e2e";
        inside-caps-lock-color = "00000000";
        inside-clear-color = "00000000";
        inside-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-caps-lock-color = "00000000";
        line-clear-color = "00000000";
        line-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-caps-lock-color = "fab387";
        ring-clear-color = "f5e0dc";
        ring-color = "b4befe";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-caps-lock-color = "fab387";
        text-clear-color = "f5e0dc";
        text-color = "cdd6f4";
        text-ver-color = "89b4fa";
        text-wrong-color = "eba0ac";
      };
    };

    waybar = {
      enable = true;

      settings = {
        main = {
          clock = {
            calendar = {
              mode = "year";
              mode-mon-col = 4;
            };

            format = "{:%OI:%M:%S %p}";
            tooltip-format = "<tt>{calendar}</tt>";
          };

          cpu = {
            format = "{usage}% ";
            interval = 1;
            on-click = "ghostty -e btop --preset 1";
          };

          "custom/date" = {
            exec = "date +'%A, %B %-d, %Y'";
            interval = 1;
          };

          "custom/lock" = {
            format = "";
            on-click = "swaylock --daemonize";
          };

          "custom/shutdown" = {
            format = "󰤆";
            on-click = "systemctl poweroff";
          };

          "custom/suspend" = {
            format = "󰤄";
            on-click = "swaylock --daemonize && systemctl suspend";
          };

          "custom/time" = {
            exec = "date +'%-I:%M %p'";
            interval = 1;
          };

          idle_inhibitor = {
            format = "{icon}";

            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          layer = "top";

          memory = {
            format = "{percentage}% ";
            interval = 1;
            on-click = "ghostty -e btop --preset 2";
          };

          modules-center = [
            "custom/date"
            "custom/time"
            "idle_inhibitor"
          ];

          modules-left = [
            "niri/workspaces"
          ];

          modules-right = [
            "wireplumber"
            "cpu"
            "memory"
            "tray"
            "custom/lock"
            "custom/suspend"
            "custom/shutdown"
          ];

          position = "top";

          tray = {
            "icon-size" = 20;
            "spacing" = 10;
          };

          wireplumber = {
            format = "{volume}% {icon}";

            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };

            format-muted = "0% ";
            on-click = "pavucontrol";
          };
        };
      };

      style = ''
        /* https://github.com/catppuccin/waybar/blob/main/themes/mocha.css */
        @define-color base #1e1e2e;
        @define-color blue #89b4fa;
        @define-color crust #11111b;
        @define-color flamingo #f2cdcd;
        @define-color green #a6e3a1;
        @define-color lavender #b4befe;
        @define-color mantle #181825;
        @define-color maroon #eba0ac;
        @define-color mauve #cba6f7;
        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;
        @define-color peach #fab387;
        @define-color pink #f5c2e7;
        @define-color red #f38ba8;
        @define-color rosewater #f5e0dc;
        @define-color sapphire #74c7ec;
        @define-color sky #89dceb;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;
        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;
        @define-color teal #94e2d5;
        @define-color text #cdd6f4;
        @define-color yellow #f9e2af;

        * {
          font-family: ${custom.font.sans.name};
          font-size: ${toString custom.font.sans.size}px;
          min-height: 0;
        }

        #cpu,
        #custom-date,
        #custom-time,
        #idle_inhibitor,
        #memory,
        #tray,
        #wireplumber {
          background-color: @surface0;
          border-radius: 1rem;
          margin-bottom: 10px;
          margin-top: 10px;
          padding: 0.5rem 1rem;
        }

        #cpu,
        #idle_inhibitor,
        #memory,
        #wireplumber {
          padding-right: 1.5rem;
        }

        #custom-lock,
        #custom-shutdown,
        #custom-suspend {
          background-color: @surface0;
          margin-bottom: 10px;
          margin-top: 10px;
          padding-right: 1.25rem;
          padding: 0.5rem 1rem;
        }

        #cpu {
          color: @red;
          margin-left: 10px;
        }

        #custom-lock {
          border-radius: 1rem 0 0 1rem;
          margin-left: 10px;
        }

        #custom-shutdown {
          border-radius: 0 1rem 1rem 0;
          margin-right: 10px;
        }

        #custom-suspend {
          border-radius: 0;
        }

        #memory {
          color: @mauve;
          margin-left: 10px;
        }

        #custom-date {
          color: @teal;
        }

        #custom-time {
          color: @green;
          margin-left: 10px;
          margin-right: 10px;
        }

        #idle_inhibitor {
          color: @yellow;
        }

        #tray {
          margin-left: 10px;
        }

        #waybar {
          background: transparent;
          color: @text;
        }

        #wireplumber {
          color: @maroon;
        }

        #workspaces {
          background-color: @surface0;
          border-radius: 1rem;
          margin-bottom: 10px;
          margin-left: 10px;
          margin-top: 10px;
        }

        #workspaces button {
          border-radius: 1rem;
          color: @lavender;
          padding: 0.5rem;
        }

        #workspaces button.active {
          border-radius: 1rem;
          color: @sky;
        }

        #workspaces button:hover {
          border-radius: 1rem;
          color: @sapphire;
        }
      '';
    };
  };

  services = {
    mako = {
      enable = true;

      settings = {
        # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
        border-radius = 5;
        default-timeout = 10000;
        font = "${custom.font.sans.name} ${toString (custom.font.sans.size - 2)}";
        layer = "overlay";
        width = 400;

        # https://github.com/catppuccin/mako/blob/main/themes/catppuccin-mocha/catppuccin-mocha-blue
        background-color = "#1e1e2e";
        border-color = "#89b4fa";
        max-icon-size = 32;
        progress-color = "over #313244";
        text-color = "#cdd6f4";

        "urgency=critical" = {
          border-color = "#fab387";
          default-timeout = 60000;
        };

        "urgency=low" = {
          border-color = "#cdd6f4";
        };
      };
    };

    swayidle = {
      enable = true;

      events = [];
      timeouts = [
        {
          command = "${pkgs.swaylock}/bin/swaylock --daemonize";
          timeout = 150;
        }
        {
          command = "${pkgs.niri}/bin/niri msg output ${output} off";
          resumeCommand = "${pkgs.niri}/bin/niri msg output ${output} on";
          timeout = 300;
        }
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          timeout = 1800;
        }
      ];
    };

    swww.enable = true;
  };
}
