
{ inputs, pkgs, ... }:

{
  imports = [
    ./configs/kitty.nix
    ./configs/zsh.nix
    ./configs/btop.nix
    ./configs/fastfetch.nix
    ./configs/gtk.nix
    ./configs/gnome-terminal.nix
    ./configs/xterm.nix
  ];

  home = {
    username = "oliver";
    homeDirectory = "/home/oliver";
    stateVersion = "25.11";
    sessionPath = [ "/opt/2025.1/Vivado/bin" ];
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

  home.packages = with pkgs; [
    kitty
    tmux
    fzf
    glib
    (graphite-gtk-theme.override {
      colorVariants = [ "dark" ];
      tweaks = [ "rimless" "darker" ];
      themeVariants = [ "orange" ];
    })
    papirus-icon-theme
    fastfetch
    bibata-cursors
    nerd-fonts.jetbrains-mono
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
