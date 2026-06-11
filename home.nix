
{ inputs, pkgs, lib, ... }:

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
#    ./configs/gnome-terminal.nix
    ./configs/xterm.nix
    ./configs/neovim.nix
    ./packages
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  home = {
    username = "oliverc";
    homeDirectory = "/home/oliverc";
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
    activation.dconfSettings = lib.mkForce (lib.hm.dag.entryAnywhere "");
  };

  home.file.".bashrc".text = ''
    # If running interactively, switch to zsh unless explicitly disabled
    if [[ $- == *i* ]] && [[ -z "$NO_ZSH" ]] && [[ -x "$HOME/.nix-profile/bin/zsh" ]]; then
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

  home.file.".vnc/xstartup" = {
    executable = true;
    text = ''
      #!/bin/sh
      unset SESSION_MANAGER
      unset DBUS_SESSION_BUS_ADDRESS
      vncconfig -nowin &
      exec $HOME/startwm.sh
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Terminal & tools
    tmux
    fzf
    fastfetch
    github-copilot-cli

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

    # Apps
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Dev
    uv
    verilator
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

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
        fetch = {
          prune = true;
        };
      };
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Oliver Cosgrove";
          email = "oliver.cosgrove@oriolenetworks.com";
        };
        revset-aliases = {
          "immutable_heads()" = "builtin_immutable_heads() ~ ((bookmarks() | remote_bookmarks()) & mine())";
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
