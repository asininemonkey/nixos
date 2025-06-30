{...}: {
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    settings = let
      colour = {
        # https://colorkit.co/palette/ea3323-ff8b00-febb26-1eb253-017cf3-9c78fe/
        background = {
          one = "#ea3323";
          two = "#ff8b00";
          three = "#febb26";
          four = "#1eb253";
          five = "#017cf3";
          six = "#9c78fe";
        };

        foreground = "#000000";
      };
    in {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      blocks = [
        {
          alignment = "left";
          newline = true;

          segments = [
            {
              background = "${colour.background.one}";
              foreground = "${colour.foreground}";
              powerline_symbol = "";
              style = "powerline";
              template = " {{ if .Env.DEVBOX_SHELL_ENABLED }}  Devbox{{ end }} ";
              type = "text";
            }
            {
              background = "${colour.background.two}";
              foreground = "${colour.foreground}";
              powerline_symbol = "";

              properties = {
                time_format = "3:04:05 PM";
              };

              style = "powerline";
              template = "   {{ .CurrentDate | date .Format }} ";
              type = "time";
            }
            {
              background = "${colour.background.three}";
              foreground = "${colour.foreground}";
              powerline_symbol = "";
              style = "powerline";
              template = " {{ if .SSHSession }}  {{ else }}  {{ end }}{{ .UserName }}@{{ .HostName }} ";
              type = "session";
            }
            {
              background = "${colour.background.four}";
              foreground = "${colour.foreground}";
              powerline_symbol = "";

              properties = {
                folder_icon = " ";
                folder_separator_icon = "  ";
                home_icon = "󱂶 ";

                mapped_locations = {
                  "/etc/nixos" = " ";
                  "~/Documents" = "󱧷 ";
                  "~/Downloads" = "󱃩 ";
                  "~/Music" = "󱍚 ";
                  "~/Pictures" = "󱞋 ";
                  "~/Public" = "󱃭 ";
                  "~/Source" = "󰴊 ";
                  "~/Templates" = "󱋤 ";
                  "~/Videos" = "󱧻 ";
                };

                style = "agnoster";
              };

              style = "powerline";
              template = " {{ path .Path .Location }} ";
              type = "path";
            }
            {
              background = "${colour.background.five}";
              foreground = "${colour.foreground}";

              properties = {
                fetch_status = true;
                fetch_upstream_icon = true;
              };

              powerline_symbol = "";
              style = "powerline";
              template = " {{ .UpstreamIcon }} {{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
              type = "git";
            }
            {
              background = "${colour.background.six}";
              foreground = "${colour.foreground}";
              powerline_symbol = "";

              properties = {
                context_aliases = {
                  "arn:aws:eks:eu-west-1:1234567890:cluster/posh" = "posh";
                };
              };

              style = "powerline";
              template = " 󱃾  {{ .Context }}{{ if .Namespace }} :: {{ .Namespace }}{{ end }} ";
              type = "kubectl";
            }
          ];

          type = "prompt";
        }
        {
          alignment = "left";
          newline = true;

          segments = [
            {
              foreground_templates = [
                "{{ if eq .Code 0 }}cyan{{ else }}red{{ end }}"
              ];

              style = "plain";
              template = "❯ ";
              type = "text";
            }
          ];

          type = "prompt";
        }
      ];

      console_title_template = "{{ .Folder }}";

      transient_prompt = {
        background = "transparent";

        foreground_templates = [
          "{{ if eq .Code 0 }}cyan{{ else }}red{{ end }}"
        ];

        template = "❯ ";
      };

      version = 2;
    };

    # useTheme = "catppuccin";
  };
}
