{ pkgs, ... }:

let
  graphiteTheme = pkgs.graphite-gtk-theme.override {
    tweaks = [ "rimless" "darker" ];
    colorVariants = [ "dark" ];
    themeVariants = [ "orange" ];
  };
in
{
  gtk = {
    enable = true;

    theme = {
      name = "Graphite-orange-Dark";
      package = graphiteTheme;
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
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  xdg.dataFile = {
    "themes/Graphite-orange-Dark".source = "${graphiteTheme}/share/themes/Graphite-orange-Dark";
    "icons/Papirus-Dark".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    "icons/Bibata-Modern-Ice".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
  };
}
