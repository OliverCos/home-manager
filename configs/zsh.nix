{ pkgs, ... }: {
  
  # --- HOLOGRAPHIC SEARCH (FZF) ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # FZF Styles: Hard Light Border & Promethean Highlights
  home.sessionVariables = {
    FZF_DEFAULT_OPTS = " \
      --color=fg:#c0c5ce,bg:#0b0e14,hl:#00ffff \
      --color=fg+:#ffffff,bg+:#1a1e24,hl+:#00ffff \
      --color=info:#ffaa00,prompt:#00ffff,pointer:#00ffff \
      --color=marker:#ffaa00,spinner:#ffaa00,header:#00ffff \
      --border='rounded' --padding='1' --margin='1' \
      --prompt='Search Protocol > ' \
      --marker='' --pointer='' \
    ";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "fzf" ];
      theme = ""; # We use a custom HUD protocol below
    };

    # 'initContent' is the standard way to append to .zshrc in Home Manager
    initContent = ''
      # --- The Arc: Forerunner Terminal Protocol ---
      
      # Enable substitution so functions like $(git) update in real-time
      setopt PROMPT_SUBST

      # --- COLOR PALETTE (Hex Codes for TrueColor) ---
      local CL_CYAN="%F{#00ffff}"   # Hard Light
      local CL_SILVER="%F{#c0c5ce}" # Living Metal
      local CL_GREY="%F{#3a4655}"   # Dormant
      local CL_ORANGE="%F{#ffaa00}" # Promethean (Warnings)
      local CL_RED="%F{#ff5555}"    # Rampancy (Errors)
      local RST="%f"

      # --- GIT HUD MODULE ---
      # Returns formatted branch name if inside a repo
      function arcade_git_hud() {
        local ref
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        # Branch icon + Name in Cyan
        echo "''${CL_CYAN} ''${ref#refs/heads/}"
      }

      # --- PROMPT LOGIC ---
      #  (Hexagon Anchor)
      # %n@%m (User@Host)
      # %~ (Current Directory)
      # %(?.cyan.red) (Status Indicator: Cyan=OK, Red=Error)

      # 1. The Anchor (Hexagon)
      PROMPT="''${CL_CYAN} "
      
      # 2. Identity (Silver)
      PROMPT+="''${CL_SILVER}%n@%m "
      
      # 3. Separator (Cyan)
      PROMPT+="''${CL_CYAN}:: "
      
      # 4. Directory (Silver, bold)
      PROMPT+="%B''${CL_SILVER}%~%b "
      
      # 5. Status Arrow (Changes color on error)
      PROMPT+="%(?.''${CL_CYAN}.''${CL_RED}) ''${RST}"

      # --- RIGHT PROMPT (HUD Info) ---
      # Shows Git Branch and Time on the far right
      RPROMPT='$(arcade_git_hud) ''${CL_GREY}[%T]''${RST}'

      # --- ALIAS PROTOCOLS ---
      alias cls="clear"
      alias monitor="btop"
      alias list="ls -la --color=auto"
    '';
  };
}