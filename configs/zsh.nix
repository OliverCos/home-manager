{ pkgs, ... }: {

  # --- FZF (Artemis palette) ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = " \
      --color=fg:#c8d1dc,bg:#08090d,hl:#b08152 \
      --color=fg+:#dbe4ec,bg+:#1f242e,hl+:#f0b070 \
      --color=info:#6b8db0,prompt:#8fb4d4,pointer:#b08152 \
      --color=marker:#b08152,spinner:#b08152,header:#6b8db0 \
      --color=border:#1f242e \
      --border='rounded' --padding='1' --margin='1' \
      --prompt='search ❯ ' \
      --marker='' --pointer='' \
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
      theme = "";
    };

    initContent = ''
      # --- Artemis prompt ---

      setopt PROMPT_SUBST

      local CL_BLUE="%F{#8fb4d4}"
      local CL_AMBER="%F{#b08152}"
      local CL_TEXT="%F{#c8d1dc}"
      local CL_DIM="%F{#4a525e}"
      local CL_RUST="%F{#b85842}"
      local RST="%f"

      function artemis_vcs() {
        local info
        info=$(artemis-vcs) || return
        [[ -n $info ]] || return
        echo " ''${CL_DIM}''${info[1]} ''${CL_AMBER}''${info:2}''${RST}"
      }

      # Line 1: orbit dot + cwd + vcs
      PROMPT="''${CL_DIM}◦ ''${CL_TEXT}%~\$(artemis_vcs)"$'\n'
      # Line 2: amber arrow on success, rust on error
      PROMPT+="%(?.''${CL_AMBER}.''${CL_RUST})❯ ''${RST}"

      RPROMPT="''${CL_DIM}[%T]''${RST}"

      alias cls="clear"
      alias monitor="btop"
      alias list="ls -la --color=auto"
    '';
  };
}
