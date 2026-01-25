{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    
    settings = {
      # --- GENERAL SETTINGS ---
      general = {
        no_fade_in = false;
        grace = 0;              # No "grace period" - locks immediately
        disable_loading_bar = true;
        hide_cursor = true;
      };

      # --- BACKGROUND (Frosted Glass) ---
      background = [
        {
          path = "screenshot";  # Takes a screenshot of your desktop
          blur_passes = 3;      # 3 passes = Heavy Blur
          blur_size = 5;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # --- INPUT FIELD (The "Command Line") ---
      input-field = [
        {
          size = "250, 50";
          position = "0, -80";
          monitor = "";
          
          dots_size = 0.25;      # Small dots for "hidden" chars
          dots_spacing = 0.15; 
          dots_center = true;
          dots_rounding = -1;    # Makes dots perfectly round
          
          # Visuals
          outer_color = "rgba(0, 255, 255, 0.5)"; # Cyan Outline (Hard Light)
          inner_color = "rgba(11, 14, 20, 0.85)"; # Deep Void Background
          font_color = "rgb(179, 242, 255)";      # Forerunner Light Text
          
          fade_on_empty = false;
          placeholder_text = "<i>Enter Clearance Code...</i>"; # Thematic prompt
          hide_input = false;
          
          rounding = 20;         # Matches your Pill shape
          
          # Shadow/Glow
          check_color = "rgb(255, 170, 0)";       # Orange when checking (Promethean)
          fail_color = "rgb(255, 85, 85)";        # Red on failure (Rampancy)
          fail_text = "<i>ACCESS DENIED</i>";
        }
      ];

      # --- LABELS (The HUD Text) ---
      label = [
        # 1. TIME (Big Digital Clock)
        {
          text = "$TIME";
          color = "rgba(179, 242, 255, 1.0)";
          font_size = 90;
          font_family = "FiraCode Nerd Font Bold";
          
          position = "0, 100";
          halign = "center";
          valign = "center";
          
          shadow_passes = 2;     # Glow Effect
          shadow_size = 5;
          shadow_color = "rgba(0, 255, 255, 0.5)";
        }
        
        # 2. DATE (Subtext)
        {
          text = "cmd[update:1000] echo \"<b>$(date +'%A, %B %d')</b>\"";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 14;
          font_family = "FiraCode Nerd Font";
          
          position = "0, 30";
          halign = "center";
          valign = "center";
        }

        # 3. STATUS INDICATOR (The "Lock" Icon)
        {
          text = "  SYSTEM LOCKED";
          color = "rgba(0, 255, 255, 0.6)";
          font_size = 12;
          font_family = "FiraCode Nerd Font Mono";
          
          position = "0, -140";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}