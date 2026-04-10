{ pkgs, ... }: {

  # --- FZF (Artemis palette) ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    FZF_DEFAULT_OPTS = " \
      --color=fg:#c8d1dc,bg:#08090d,hl:#d49759 \
      --color=fg+:#dbe4ec,bg+:#1f242e,hl+:#f0b070 \
      --color=info:#6b8db0,prompt:#8fb4d4,pointer:#d49759 \
      --color=marker:#d49759,spinner:#d49759,header:#6b8db0 \
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
      local CL_AMBER="%F{#d49759}"
      local CL_TEXT="%F{#c8d1dc}"
      local CL_DIM="%F{#4a525e}"
      local CL_RUST="%F{#b85842}"
      local RST="%f"

      function artemis_git() {
        local ref
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo " ''${CL_DIM}⎇ ''${CL_AMBER}''${ref#refs/heads/}''${RST}"
      }

      # Line 1: orbit dot + cwd + git branch
      PROMPT="''${CL_DIM}◦ ''${CL_TEXT}%~\$(artemis_git)"$'\n'
      # Line 2: amber arrow on success, rust on error
      PROMPT+="%(?.''${CL_AMBER}.''${CL_RUST})❯ ''${RST}"

      RPROMPT="''${CL_DIM}[%T]''${RST}"

      alias cls="clear"
      alias monitor="btop"
      alias list="ls -la --color=auto"
    '';
  };
}
