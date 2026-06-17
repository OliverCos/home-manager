{ pkgs, ... }:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        icons = "none";
        theme = "native";
        settings = {
          theme = {
            overrides = {
              idle_bg = "#08090d";
              idle_fg = "#c8d1dc";
              info_bg = "#08090d";
              info_fg = "#8fb4d4";
              good_bg = "#08090d";
              good_fg = "#7da784";
              warning_bg = "#08090d";
              warning_fg = "#b08152";
              critical_bg = "#08090d";
              critical_fg = "#b85842";
              separator_bg = "#08090d";
              separator_fg = "#4a525e";
              separator = " ┃ ";
            };
          };
        };
        blocks = [
          {
            block = "cpu";
            format = "  $utilization ";
            interval = 5;
          }
          {
            block = "memory";
            format = "  $mem_used_percents ";
            interval = 5;
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "used";
            format = "  $percentage ";
            interval = 30;
          }
          {
            block = "time";
            format = "$timestamp.datetime(f:'%Y-%m-%d %H:%M')";
            interval = 60;
          }
        ];
      };
    };
  };
}
