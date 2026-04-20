
{ inputs, pkgs, ... }:

{
  imports = [
    ./configs/zsh.nix
    ./configs/btop.nix
    ./configs/fastfetch.nix
    ./configs/neovim.nix
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
  };
  xdg.cacheHome = "/scratch/oliverc/.cache";

  home.file.".bashrc".text = ''
    # If running interactively, switch to zsh
    if [[ $- == *i* ]] && [ -x "$HOME/.nix-profile/bin/zsh" ]; then
      export SHELL="$HOME/.nix-profile/bin/zsh"
      exec "$HOME/.nix-profile/bin/zsh" -l
    fi
  '';

  home.packages = with pkgs; [
    tmux
    fzf
    fastfetch
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
