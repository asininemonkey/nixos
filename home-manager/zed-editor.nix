{
  custom,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    alejandra
    helm-ls
    nil
    nixd
  ];

  programs.zed-editor = {
    enable = true;

    extensions = [
      "docker-compose"
      "dockerfile"
      "env"
      "git-firefly"
      "helm"
      "make"
      "nix"
      "sql"
      "terraform"
      "toml"
    ];

    package = pkgs-unstable.zed-editor;

    userSettings = {
      agent = {
        default_model = {
          model =
            if custom.host.name == "asrock-x570-linux"
            then "mistral:7b"
            else "tinyllama:1.1b";

          provider = "ollama";
        };

        version = "2";
      };

      buffer_font_family = custom.font.mono.name;
      buffer_font_size = custom.font.mono.size + 2;

      file_types = {
        Helm = [
          "**/helmfile.d/**/*.yaml"
          "**/helmfile.d/**/*.yml"
          "**/templates/**/*.tpl"
          "**/templates/**/*.yaml"
          "**/templates/**/*.yml"
        ];
      };

      lsp = {
        nil = {
          initialization_options = {
            formatting.command = ["alejandra"];
          };
        };
      };

      minimap.show = "always";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      terminal = {
        font_family = custom.font.mono.name;
        font_size = custom.font.mono.size + 2;
        line_height = "standard";
      };

      theme = {
        dark = "One Dark";
        light = "One Light";
        mode = "dark";
      };

      ui_font_family = custom.font.sans.name;
      ui_font_size = custom.font.mono.size + 2;
    };
  };
}
