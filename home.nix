
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

  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://localhost:11434";
    ANTHROPIC_AUTH_TOKEN = "ollama";
    ANTHROPIC_API_KEY = "";
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
    CLAUDE_CODE_DISABLE_BACKGROUND_TASKS = "1";
  };

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
  ];
  
  services.playerctld.enable = true;
  
  services.blueman-applet.enable = true;

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "splogdes";
        email = "95136830+splogdes@users.noreply.github.com";
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
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

  programs.home-manager.enable = true;
}
