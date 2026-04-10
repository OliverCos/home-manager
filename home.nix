
{ inputs, pkgs, ... }:

{
  imports = [
    ./configs/hyprland.nix
    ./configs/hyprlock.nix
    ./configs/hypridle.nix
    ./configs/kitty.nix
    ./configs/wofi.nix
    ./configs/waybar.nix
    ./configs/zsh.nix
    ./configs/mako.nix
    ./configs/btop.nix
    ./configs/fastfetch.nix
  ];

  home.username = "splogdes";
  home.homeDirectory = "/home/splogdes";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    waybar
    wofi
    hyprpaper
    mako
    libnotify
    kitty
    hyprpolkitagent
    hyprlock
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    vscode
    spotify
    duf
    tmux
    seahorse
    fzf
    cava
    grimblast
    swappy
    pavucontrol
    bibata-cursors
    (graphite-gtk-theme.override {
      colorVariants = [ "dark" ];
      tweaks = [ "rimless" "darker" ];
      themeVariants = [ "default" ];
    })
    papirus-icon-theme
    nwg-look
    glib
    fastfetch
    playerctl
    nvidia-vaapi-driver
    signal-desktop
    baobab
    gparted
    thunar
    python3
    ddcutil
    obsidian
    claude-code
    (symlinkJoin {
      name = "picoscope-wrapped";
      paths = [ picoscope ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/picoscope \
          --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      '';
    })
    # ckan is for kerbal space program mod management
    ckan
  ];
  
  services.playerctld.enable = true;
  
  services.blueman-applet.enable = true;

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "splogdes";
          email = "95136830+splogdes@users.noreply.github.com";
        };
        push = {
          autoSetupRemote = true;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "";
          path = "/home/splogdes/Pictures/wallpaper.png";
        }
      ];
      preload = [
        "/home/splogdes/Pictures/wallpaper.png"
      ];
      splash = false;
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  gtk = {
      enable = true;
      
      theme = {
        name = "Graphite-Dark";
        package = pkgs.graphite-gtk-theme.override {
            tweaks = [ "rimless" "darker" ];
            colorVariants = [ "dark" ];
        };
      };

      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4 = {
        extraConfig.gtk-application-prefer-dark-theme = 1;
        theme = null;
      };
    };

  programs.home-manager.enable = true;
}
