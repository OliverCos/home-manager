{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        font = "JetBrainsMono Nerd Font 10";
        width = 380;
        height = 140;
        origin = "top-right";
        offset = "14x14";

        background = "#0f1218e6";
        foreground = "#c8d1dc";

        frame_color = "#b08152";
        frame_width = 1;
        corner_radius = 14;

        padding = 18;
        horizontal_padding = 18;
        separator_color = "frame";

        icon_position = "left";
        max_icon_size = 48;

        timeout = 5;
      };

      urgency_low = {
        frame_color = "#3a4250";
        foreground = "#7e8694";
        timeout = 5;
      };

      urgency_normal = {
        frame_color = "#b08152";
        timeout = 5;
      };

      urgency_critical = {
        frame_color = "#b85842";
        foreground = "#dbe4ec";
        timeout = 0;
      };
    };
  };
}
