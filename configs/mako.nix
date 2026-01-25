{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    # NEW STRUCTURE: Everything goes inside 'settings'
    settings = {
      # --- VISUALS ---
      font = "FiraCode Nerd Font 12";
      width = 350;
      height = 150;
      
      # Colors (Hyphens instead of CamelCase)
      "background-color" = "#0b0e14F0"; # Deep Void (94% Opacity)
      "text-color" = "#b3f2ff";         # Soft Cyan
      
      # Borders
      "border-color" = "#00ffff";       # Cyan Glow
      "border-size" = 2;
      "border-radius" = 10;
      
      # Layout
      padding = "15";
      margin = "10";
      
      # Icons
      icons = true;
      "icon-path" = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";      
      
      # --- BEHAVIOR ---
      "default-timeout" = 5000; # 5 seconds
      "ignore-timeout" = false;
      
      layer = "overlay";
    };

    # Extra config stays outside settings (or can be appended differently), 
    # but 'extraConfig' is still valid in most versions.
    extraConfig = ''
      [urgency=low]
      border-color=#3a4655
      text-color=#c0c5ce
      
      [urgency=normal]
      border-color=#00ffff
      
      [urgency=critical]
      border-color=#ff5555
      text-color=#ffffff
      default-timeout=0
      
      [category=mpd]
      border-color=#ffaa00
      default-timeout=2000
      group-by=category
    '';
  };
}