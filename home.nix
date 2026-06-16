
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
    ./configs/xterm.nix
    ./configs/neovim.nix
    ./configs/autorandr.nix
    ./packages
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

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
    activation.dconfSettings = lib.mkForce (lib.hm.dag.entryAnywhere "");
  };

  home.file.".xprofile".text = ''
    [ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
  '';

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

    # Screen lock & display
    i3lock
    xss-lock
    autorandr
    xset

    # Keyring / secrets
    libsecret
    gnome-keyring
    seahorse
    polkit_gnome

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

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

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
