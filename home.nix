
{ inputs, pkgs, lib, ... }:

{
  imports = [
    ./configs/kitty.nix
    ./configs/zsh.nix
    ./configs/btop.nix
    ./configs/fastfetch.nix
    ./configs/gtk.nix
    ./configs/xterm.nix
    ./configs/neovim.nix
    ./configs/fpga-desktop.nix
    ./packages
  ];

  # This machine is RHEL 9 (non-NixOS) running GNOME. Let home-manager integrate
  # with the system session (XDG dirs, PATH, etc.).
  targets.genericLinux.enable = true;

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
      MTI_VCO_MODE = "64";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      LANG = "en_US.UTF-8";
    };
    # GNOME owns dconf here; don't let home-manager drive it (no D-Bus over SSH).
    activation.dconfSettings = lib.mkForce (lib.hm.dag.entryAnywhere "");
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Terminal & tools
    tmux
    fzf
    fastfetch
    github-copilot-cli
    libnotify
    ripgrep
    fd

    # Theming (GTK apps, icons, cursors, fonts)
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
    guvcview

    # Dev
    uv
    verilator
    verible
    elan
    clang-tools # clangd language server (C/C++ IntelliSense in VS Code)
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
          "immutable_heads()" = "builtin_immutable_heads() | (trunk().. & ~mine())";
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
