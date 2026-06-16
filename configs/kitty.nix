{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      # --- TYPOGRAPHY ---
      font_family = "JetBrainsMono Nerd Font";
      font_size = "12.5";
      disable_ligatures = "never";

      # --- BACKGROUND ---
      background = "#08090d";
      background_opacity = "0.85";

      # --- FOREGROUND ---
      foreground = "#c8d1dc";

      # --- WINDOW ---
      window_border_width = "0pt";
      window_padding_width = 16;
      hide_window_decorations = "yes";

      # --- CURSOR ---
      cursor = "#b08152";
      cursor_text_color = "#08090d";
      cursor_shape = "beam";
      cursor_beam_thickness = "1.5";
      cursor_blink_interval = "0";

      # --- TAB BAR ---
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_foreground = "#08090d";
      active_tab_background = "#b08152";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#7e8694";
      inactive_tab_background = "#0f1218";

      # --- ARTEMIS PALETTE ---

      # Black: void / mute
      color0  = "#15191f";
      color8  = "#3a4250";

      # Red: rust alert
      color1  = "#b85842";
      color9  = "#d27260";

      # Green: muted moss
      color2  = "#7da784";
      color10 = "#9bc7a3";

      # Yellow: amber
      color3  = "#b08152";
      color11 = "#f0b070";

      # Blue: ocean / atmosphere
      color4  = "#6b8db0";
      color12 = "#8fb4d4";

      # Magenta: dusty violet
      color5  = "#8a7aa0";
      color13 = "#a89cc4";

      # Cyan: glow blue (not neon)
      color6  = "#8fb4d4";
      color14 = "#b3d4ec";

      # White: text / cloud
      color7  = "#c8d1dc";
      color15 = "#dbe4ec";

      # --- UX EXTRAS ---
      selection_foreground = "#08090d";
      selection_background = "#b08152";
      url_color = "#8fb4d4";
      url_style = "single";
    };
  };
}
