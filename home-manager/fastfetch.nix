{...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " ";
      };

      logo = {
        height = 20;
        padding.left = 4;
        source = "/etc/nixos/logo.png";
        type = "kitty-direct";
        width = 46;
      };

      modules = [
        "break"
        {
          key = "╭─ 󰌢 ";
          keyColor = "red";
          type = "host";
        }
        {
          key = "├─ 󰻠 ";
          keyColor = "red";
          type = "cpu";
        }
        {
          key = "├─ 󰍛 ";
          keyColor = "red";
          type = "gpu";
        }
        {
          key = "├─ 󰍹 ";
          keyColor = "red";
          type = "display";
        }
        {
          key = "├─  ";
          keyColor = "red";
          type = "disk";
        }
        {
          key = "╰─ 󰑭 ";
          keyColor = "red";
          type = "memory";
        }
        "break"
        {
          key = "╭─  ";
          keyColor = "green";
          type = "shell";
        }
        {
          key = "├─  ";
          keyColor = "green";
          type = "terminal";
        }
        {
          key = "├─  ";
          keyColor = "green";
          type = "de";
        }
        {
          key = "├─  ";
          keyColor = "green";
          type = "wm";
        }
        {
          key = "├─ 󰧨 ";
          keyColor = "green";
          type = "lm";
        }
        {
          key = "├─ 󰉼 ";
          keyColor = "green";
          type = "theme";
        }
        {
          key = "╰─ 󰀻 ";
          keyColor = "green";
          type = "icons";
        }
        "break"
        {
          format = "{1}@{2}";
          key = "╭─  ";
          keyColor = "blue";
          type = "title";
        }
        {
          key = "├─  ";
          keyColor = "blue";
          type = "os";
        }
        {
          format = "{1} {2}";
          key = "├─  ";
          keyColor = "blue";
          type = "kernel";
        }
        {
          key = "├─ 󰅐 ";
          keyColor = "blue";
          type = "uptime";
        }
        {
          compact = true;
          key = "╰─ 󰩟 ";
          keyColor = "blue";
          type = "localip";
        }
        "break"
      ];
    };
  };
}
