{ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Graphite-orange-Dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      visible-name = "Artemis";
      use-theme-colors = false;
      foreground-color = "#c8d1dc";
      background-color = "#08090d";
      cursor-colors-set = true;
      cursor-foreground-color = "#08090d";
      cursor-background-color = "#d49759";
      cursor-shape = "ibeam";
      cursor-blink-mode = "off";
      cell-height-scale = 0.9;
      cell-width-scale = 1.0;
      palette = [
        "#15191f" "#b85842" "#7da784" "#d49759"
        "#6b8db0" "#8a7aa0" "#8fb4d4" "#c8d1dc"
        "#3a4250" "#d27260" "#9bc7a3" "#f0b070"
        "#8fb4d4" "#a89cc4" "#b3d4ec" "#dbe4ec"
      ];
      font = "JetBrainsMono Nerd Font Mono 12";
      use-system-font = false;
      use-theme-transparency = false;
      use-transparent-background = false;
      scrollbar-policy = "never";
    };
  };
}
