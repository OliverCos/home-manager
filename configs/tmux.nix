{ pkgs, ... }:

let
  continuum = pkgs.tmuxPlugins.continuum;
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-b";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    escapeTime = 10;
    historyLimit = 50000;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator

      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-bind '-n M-f'
          set -g @floax-width '80%'
          set -g @floax-height '80%'
          set -g @floax-border-color '#b08152'
          set -g @floax-text-color '#c8d1dc'
          set -g @floax-title 'scratch'
          set -g @floax-change-path 'true'

          # floax.tmux sources utils.sh, which reads these before setting them.
          # Seed them here so the first load doesn't spew "unknown variable".
          set-environment -g FLOAX_WIDTH '80%'
          set-environment -g FLOAX_HEIGHT '80%'
          set-environment -g FLOAX_BORDER_COLOR '#b08152'
          set-environment -g FLOAX_TEXT_COLOR '#c8d1dc'
          set-environment -g FLOAX_TITLE 'scratch'
          set-environment -g FLOAX_CHANGE_PATH 'true'
        '';
      }

      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-preview-enabled 'true'
          set -g @sessionx-preview-location 'right'
          set -g @sessionx-preview-ratio '55%'
          set -g @sessionx-window-height '75%'
          set -g @sessionx-window-width '80%'
          set -g @sessionx-prompt 'session ❯ '
          set -g @sessionx-pointer '❯'
        '';
      }

      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];

    extraConfig = ''
      # --- Artemis palette ---
      # void #08090d  panel #0f1218  raise #15191f  edge #1f242e
      # muted #3a4250 inactive #4a525e subtle #7e8694
      # text #c8d1dc  bright #dbe4ec
      # amber #b08152 solar #f0b070  ocean #6b8db0  glow #8fb4d4
      # rust #b85842  moss #7da784  violet #8a7aa0

      # --- Terminal capabilities ---
      set -ga terminal-features ",xterm-kitty:RGB,*256col*:RGB"
      set -ga terminal-overrides ",*256col*:Tc,xterm-kitty:Tc"
      # Let kitty's graphics protocol and OSC sequences through tmux.
      set -g allow-passthrough on
      set -g focus-events on
      set -g set-clipboard on

      set -g renumber-windows on
      set -g set-titles on
      set -g set-titles-string "#S ❯ #W"
      set -g display-time 2000
      set -g display-panes-time 2000
      set -g status-interval 5
      setw -g pane-base-index 1

      # --- Keybindings ---
      bind C-b send-prefix
      bind r source-file ~/.config/tmux/tmux.conf \; display "config reloaded"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # vim-tmux-navigator owns C-h/j/k/l; these stay as a prefix-based fallback.
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1
      bind Space next-layout
      bind e setw synchronize-panes \; display "sync #{?pane_synchronized,on,off}"
      bind X kill-session

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel

      # --- Chrome ---
      # Rounded chips on the terminal background, mirroring kitty's tab bar.
      set -g status-position top
      set -g status-justify left
      set -g status-style "fg=#7e8694,bg=default"
      set -g status-left-length 40
      set -g status-right-length 120

      set -g status-left "#[fg=#1f242e,bg=default]#[fg=#b08152,bg=#1f242e,bold] #S #[fg=#1f242e,bg=default,nobold] "

      set -g status-right "#(${continuum}/share/tmux-plugins/continuum/scripts/continuum_save.sh)#{?client_prefix,#[fg=#b85842]#[fg=#08090d#,bg=#b85842#,bold] PREFIX #[fg=#b85842#,bg=default#,nobold],#(artemis-vcs --tmux '#{pane_current_path}')} #[fg=#1f242e]#[fg=#7e8694,bg=#1f242e] #h #[fg=#1f242e,bg=default] #[fg=#6b8db0]#[fg=#08090d,bg=#6b8db0,bold] %H:%M #[fg=#6b8db0,bg=default,nobold]"

      setw -g window-status-format "#[fg=#15191f,bg=default]#[fg=#7e8694,bg=#15191f] #I #W#{?window_zoomed_flag, ,} #[fg=#15191f,bg=default]"
      setw -g window-status-current-format "#[fg=#f0b070,bg=default]#[fg=#08090d,bg=#f0b070,bold] #I #W#{?window_zoomed_flag, ,} #[fg=#f0b070,bg=default,nobold]"
      setw -g window-status-separator " "
      setw -g window-status-activity-style "fg=#08090d,bg=#7da784"
      setw -g window-status-bell-style "fg=#08090d,bg=#b85842,bold"

      set -g pane-border-style "fg=#1f242e"
      set -g pane-active-border-style "fg=#b08152"
      # tmux has no rounded pane borders; single is the thinnest, least chunky
      # match for the rounded chrome everywhere else.
      set -g pane-border-lines single
      set -g pane-scrollbars modal
      set -g pane-scrollbars-style "bg=#15191f,fg=#4a525e"

      set -g message-style "fg=#08090d,bg=#b08152,bold"
      set -g message-command-style "fg=#c8d1dc,bg=#15191f"

      set -g mode-style "fg=#08090d,bg=#b08152"
      set -g copy-mode-match-style "fg=#08090d,bg=#8fb4d4"
      set -g copy-mode-current-match-style "fg=#08090d,bg=#f0b070"
      set -g copy-mode-mark-style "fg=#08090d,bg=#8a7aa0"

      set -g display-panes-colour "#4a525e"
      set -g display-panes-active-colour "#b08152"
      set -g clock-mode-colour "#b08152"
      set -g clock-mode-style 24

      set -g popup-border-style "fg=#b08152"
      set -g popup-border-lines rounded
      set -g popup-style "fg=#c8d1dc,bg=#0f1218"

      set -g menu-style "fg=#c8d1dc,bg=#0f1218"
      set -g menu-border-style "fg=#b08152"
      set -g menu-border-lines rounded
      set -g menu-selected-style "fg=#08090d,bg=#b08152,bold"

      # sessionx renders through fzf; keep its popup on-palette too.
      set -g @sessionx-additional-options "--color=fg:#c8d1dc,bg:#0f1218,hl:#b08152 --color=fg+:#dbe4ec,bg+:#1f242e,hl+:#f0b070 --color=info:#6b8db0,prompt:#8fb4d4,pointer:#b08152 --color=marker:#b08152,spinner:#b08152,header:#6b8db0 --color=border:#1f242e --border=rounded"

      # Continuum drives its save timer from a #(continuum_save.sh) job in
      # status-right. It only injects that itself when it believes no other
      # server is running, and any later status-right write would drop it, so
      # status-right carries the job directly and continuum loads afterwards.
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
      run-shell ${continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
