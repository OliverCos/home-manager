{ pkgs, ... }:

let
  colloidTheme = pkgs.colloid-gtk-theme.override {
    tweaks = [ "rimless" "black" ];
    colorVariants = [ "dark" ];
    themeVariants = [ "orange" ];
  };
in
{
  gtk = {
    enable = true;

    theme = {
      name = "Colloid-Orange-Dark";
      package = colloidTheme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.theme = null;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  xdg.dataFile = {
    "themes/Colloid-Orange-Dark".source = "${colloidTheme}/share/themes/Colloid-Orange-Dark";
    "icons/Papirus-Dark".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    "icons/Bibata-Modern-Ice".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
  };
}
