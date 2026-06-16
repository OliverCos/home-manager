{ ... }:

{
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    terminal = "gnome-terminal";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus-Dark";
    };
    theme = let
      inherit (builtins) toString;
    in builtins.toFile "artemis.rasi" ''
      * {
        bg:       #08090dcc;
        bg-alt:   #0f1218b3;
        fg:       #c8d1dc;
        fg-dim:   #7e8694;
        accent:   #b08152;
        accent-t: #b0815238;
        border-c: #b081528c;
        urgent:   #b85842;

        background-color: transparent;
        text-color:       @fg;
      }

      window {
        background-color: @bg;
        border:           1px solid;
        border-color:     @border-c;
        border-radius:    14px;
        width:            800px;
        padding:          0;
      }

      mainbox {
        children: [ inputbar, listview ];
        spacing: 0;
      }

      inputbar {
        background-color: @bg-alt;
        padding:          12px 18px;
        border:           0 0 1px 0;
        border-color:     @border-c;
        border-radius:    14px 14px 0 0;
        children:         [ prompt, entry ];
      }

      prompt {
        text-color: @accent;
        margin:     0 8px 0 0;
      }

      entry {
        placeholder:       "search the void...";
        placeholder-color: @fg-dim;
      }

      listview {
        lines:    8;
        columns:  2;
        padding:  8px;
        spacing:  4px;
        scrollbar: false;
      }

      element {
        padding:       10px 14px;
        border-radius: 10px;
      }

      element selected.normal {
        background-color: @accent-t;
        border:           1px solid;
        border-color:     @border-c;
        text-color:       #dbe4ec;
      }

      element-icon {
        size: 28px;
        margin: 0 12px 0 0;
      }

      element-text {
        vertical-align: 0.5;
      }
    '';
  };
}
