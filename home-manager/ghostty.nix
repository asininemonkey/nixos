{custom, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      app-notifications = "no-clipboard-copy";
      bold-is-bright = true;
      clipboard-paste-protection = true;
      copy-on-select = "clipboard";
      cursor-style = "block";
      cursor-style-blink = true;

      custom-shader = builtins.fetchurl {
        sha256 = "sha256:1baj0lmqdgkwblg26qpfp7p5ixd2qkq77lqmlyxpfc9qk4lhib0c";
        url = "https://raw.githubusercontent.com/m-ahdal/ghostty-shaders/refs/heads/main/glow-rgbsplit-twitchy.glsl";
      };

      font-family = custom.font.mono.name;
      font-size = custom.font.mono.size;
      keybind = "ctrl+shift+k=clear_screen";
      theme = "catppuccin-mocha";
      window-height = 35;
      window-width = 155;
    };
  };
}
