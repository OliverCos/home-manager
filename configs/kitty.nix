{ ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      # --- FORERUNNER TYPOGRAPHY ---
      font_family = "FiraCode Nerd Font Mono";
      font_size = "12.0";
      # "Never" disable ligatures implies the advanced nature of the Domain
      disable_ligatures = "never"; 
      
      # --- THE VOID (BACKGROUND) ---
      # Slightly metallic deep grey/black, not pitch black
      background = "#080a0c"; 
      background_opacity = "0.80"; # Slightly more solid, like a physical terminal

      # --- LIVING METAL (FOREGROUND) ---
      # Forerunner structures are silver/grey. Text should reflect that.
      foreground = "#c0c5ce"; 
      
      # --- HARD LIGHT BORDER ---
      # This puts a thin glowing line around your terminal window
      window_border_width = "1pt";
      active_border_color = "#00ffff"; # Hard Light Cyan
      inactive_border_color = "#3a4655"; # Dormant Metal
      window_padding_width = 12;

      # --- CURSOR (FOCUS BEAM) ---
      cursor = "#00ffff";
      cursor_text_color = "#080a0c";
      cursor_shape = "beam"; # Looks like a scanning laser
      cursor_beam_thickness = "1.5";
      cursor_blink_interval = "0"; # Forerunners do not blink (static beam)

      # --- TAB BAR (DATA SHARDS) ---
      tab_bar_edge = "top"; # HUDs usually have headers
      tab_bar_style = "powerline";
      tab_powerline_style = "angled"; # Sharp angles match Forerunner architecture
      active_tab_foreground = "#080a0c";
      active_tab_background = "#00ffff"; 
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#00ffff";
      inactive_tab_background = "#0f1419";

      # --- COLOR PALETTE: "THE MANTLE" ---
      
      # Black: The Void / Dormant Metal
      color0  = "#15191f";
      color8  = "#3a4655";

      # Red: Rampancy / Logic Plague
      color1  = "#ff5555";
      color9  = "#ff3333";

      # Green: Installation Monitor / Reclaimer Status
      color2  = "#50fa7b";
      color10 = "#00ff99";

      # Yellow/Orange: Promethean / Construct
      color3  = "#ffb86c";
      color11 = "#ffaa00"; # Glowing Orange

      # Blue: Sentinels / The Domain
      color4  = "#8be9fd";
      color12 = "#00bfff"; 

      # Magenta: Slipspace Rupture
      color5  = "#bd93f9";
      color13 = "#ff79c6";

      # Cyan: Hard Light (Primary UI)
      color6  = "#00ffff";
      color14 = "#a6f5ff"; # Overcharged Hard Light

      # White: Pure Data / Living Metal
      color7  = "#e6e6e6";
      color15 = "#ffffff";

      # --- UX EXTRAS ---
      selection_foreground = "#000000";
      selection_background = "#00ffff"; # High contrast "Select"
      url_color = "#00ffff";
      url_style = "double"; # Double underline for links
    };
  };
}