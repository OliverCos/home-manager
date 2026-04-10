{ pkgs, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # --- VISUALS ---
      font = "JetBrainsMono Nerd Font 11";
      width = 380;
      height = 140;

      "background-color" = "#0f1218e6";
      "text-color" = "#c8d1dc";

      "border-color" = "#d49759";
      "border-size" = 1;
      "border-radius" = 14;

      padding = "18";
      margin = "14";

      icons = true;
      "icon-path" = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";

      # --- BEHAVIOR ---
      "default-timeout" = 5000;
      "ignore-timeout" = false;

      layer = "overlay";
    };

    extraConfig = ''
      [urgency=low]
      border-color=#3a4250
      text-color=#7e8694

      [urgency=normal]
      border-color=#d49759

      [urgency=critical]
      border-color=#b85842
      text-color=#dbe4ec
      default-timeout=0

      [category=mpd]
      border-color=#6b8db0
      default-timeout=2000
      group-by=category
    '';
  };
}
