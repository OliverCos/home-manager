{ pkgs, ... }:

let
  mod = "Mod4";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";
in
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        terminal = "kitty";

        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 9.0;
        };

        gaps = {
          inner = 0;
          outer = 0;
        };

        colors = {
          focused = {
            border = "#b08152";
            background = "#0f1218";
            text = "#c8d1dc";
            indicator = "#b08152";
            childBorder = "#b08152";
          };
          focusedInactive = {
            border = "#15191f";
            background = "#0f1218";
            text = "#7e8694";
            indicator = "#15191f";
            childBorder = "#15191f";
          };
          unfocused = {
            border = "#15191f";
            background = "#08090d";
            text = "#7e8694";
            indicator = "#15191f";
            childBorder = "#15191f";
          };
          urgent = {
            border = "#b85842";
            background = "#08090d";
            text = "#dbe4ec";
            indicator = "#b85842";
            childBorder = "#b85842";
          };
        };

        window = {
          titlebar = false;
          border = 1;
        };

        floating = {
          titlebar = false;
          border = 1;
        };

        bars = [{
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [ "JetBrainsMono Nerd Font" ];
            size = 10.0;
          };
          colors = {
            background = "#08090d";
            statusline = "#c8d1dc";
            separator = "#4a525e";
            focusedWorkspace = {
              border = "#b08152";
              background = "#b08152";
              text = "#08090d";
            };
            activeWorkspace = {
              border = "#0f1218";
              background = "#0f1218";
              text = "#c8d1dc";
            };
            inactiveWorkspace = {
              border = "#08090d";
              background = "#08090d";
              text = "#7e8694";
            };
            urgentWorkspace = {
              border = "#b85842";
              background = "#b85842";
              text = "#dbe4ec";
            };
          };
        }];

        keybindings = {
          # Focus
          "${mod}+Left" = "focus left";
          "${mod}+Right" = "focus right";
          "${mod}+Up" = "focus up";
          "${mod}+Down" = "focus down";

          # Move windows
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Down" = "move down";

          # Resize
          "${mod}+l" = "resize grow width 20 px";
          "${mod}+j" = "resize shrink width 20 px";
          "${mod}+i" = "resize shrink height 20 px";
          "${mod}+k" = "resize grow height 20 px";

          # Actions
          "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
          "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${mod}+q" = "kill";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+space" = "floating toggle";
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+r" = "restart";
          "${mod}+Shift+x" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 0f1218";
          "${mod}+b" = "exec --no-startup-id ${pkgs.blueman}/bin/blueman-manager";

          # Workspaces
          "${mod}+1" = "workspace ${ws1}";
          "${mod}+2" = "workspace ${ws2}";
          "${mod}+3" = "workspace ${ws3}";
          "${mod}+4" = "workspace ${ws4}";
          "${mod}+5" = "workspace ${ws5}";
          "${mod}+6" = "workspace ${ws6}";
          "${mod}+7" = "workspace ${ws7}";
          "${mod}+8" = "workspace ${ws8}";
          "${mod}+9" = "workspace ${ws9}";
          "${mod}+0" = "workspace ${ws10}";

          "${mod}+Shift+1" = "move container to workspace ${ws1}";
          "${mod}+Shift+2" = "move container to workspace ${ws2}";
          "${mod}+Shift+3" = "move container to workspace ${ws3}";
          "${mod}+Shift+4" = "move container to workspace ${ws4}";
          "${mod}+Shift+5" = "move container to workspace ${ws5}";
          "${mod}+Shift+6" = "move container to workspace ${ws6}";
          "${mod}+Shift+7" = "move container to workspace ${ws7}";
          "${mod}+Shift+8" = "move container to workspace ${ws8}";
          "${mod}+Shift+9" = "move container to workspace ${ws9}";
          "${mod}+Shift+0" = "move container to workspace ${ws10}";

          # Split direction
          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
        };

        assigns = {
          "${ws2}" = [{ class = "zen"; }];
          "${ws3}" = [{ class = "Code"; }];
        };

        startup = [
          { command = "${pkgs.feh}/bin/feh --bg-fill /home/oliver/Pictures/artimusii.jpg"; always = true; notification = false; }
          { command = "${pkgs.autorandr}/bin/autorandr --change"; always = true; notification = false; }
          { command = "${pkgs.xset}/bin/xset s 600 600"; always = true; notification = false; }
          { command = "${pkgs.xset}/bin/xset +dpms dpms 660 660 660"; always = true; notification = false; }
          { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pkgs.i3lock}/bin/i3lock --nofork -c 0f1218"; always = true; notification = false; }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; notification = false; }
          { command = "${pkgs.dunst}/bin/dunst"; notification = false; }
          { command = "${pkgs.kitty}/bin/kitty"; notification = false; }
        ];
      };
      extraConfig = ''
        for_window [urgent=latest] focus
      '';
    };
  };
}
