
{ inputs, pkgs, ... }:

{
  imports = [
    ./configs/i3.nix
    ./configs/i3status-rust.nix
    ./configs/rofi.nix
    ./configs/dunst.nix
    ./configs/kitty.nix
    ./configs/zsh.nix
    ./configs/btop.nix
    ./configs/fastfetch.nix
    ./configs/gtk.nix
    ./configs/gnome-terminal.nix
    ./configs/xterm.nix
    ./configs/neovim.nix
  ];

  home = {
    username = "oliver";
    homeDirectory = "/home/oliver";
    stateVersion = "25.11";
    sessionPath = [ 
      "/opt/2025.1/Vivado/bin"
      "/opt/questasim/bin"
      "/opt/2025.1/Vitis/bin"
    ];
    sessionVariables = {
      ZSH_DISABLE_COMPFIX = "true";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      LANG = "en_US.UTF-8";
    };
  };
  xdg.cacheHome = "/scratch/oliver/.cache";

  home.file.".bashrc".text = ''
    # If running interactively, switch to zsh
    if [[ $- == *i* ]] && [ -x "$HOME/.nix-profile/bin/zsh" ]; then
      export SHELL="$HOME/.nix-profile/bin/zsh"
      exec "$HOME/.nix-profile/bin/zsh" -l
    fi
  '';

  home.file.".xprofile".text = ''
    [ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
  '';

  home.file."startwm.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      [ -f ~/.xprofile ] && . ~/.xprofile
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:/usr/share:/usr/local/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      export PATH="$HOME/.nix-profile/bin:$PATH"
      exec $HOME/.nix-profile/bin/i3
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Terminal & tools
    tmux
    fzf
    fastfetch

    # i3 ecosystem
    i3
    i3status-rust
    rofi
    dunst
    feh
    libnotify

    # Theming
    glib
    (graphite-gtk-theme.override {
      colorVariants = [ "dark" ];
      tweaks = [ "rimless" "darker" ];
      themeVariants = [ "orange" ];
    })
    papirus-icon-theme
    bibata-cursors
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only

    # Apps
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "OliverCos";
          email = "oliver.cosgrove@oriolenetworks.com";
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

  programs.home-manager.enable = true;
}
