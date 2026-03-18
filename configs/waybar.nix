{ pkgs, ... }:
let
  powerStyle = pkgs.writeText "power-style.css" ''
    window {
      background-color: rgba(11, 14, 20, 0.9);
      border: 2px solid #f38ba8; /* Red/Pink border */
      border-radius: 12px;
      font-family: "FiraCode Nerd Font", monospace;
    }

    #input {
      min-height: 0px;
      height: 0px;
      margin: 0px;
      padding: 0px;
      border: none;
      opacity: 0;
      background-color: transparent;
    }

    #inner-box {
      margin: 10px; 
      background-color: transparent;
    }

    #entry {
      padding: 10px;
      margin: 2px 0px;
      color: #b3f2ff;
    }

    #entry:selected {
      background: linear-gradient(90deg, rgba(243, 139, 168, 0.2) 0%, rgba(243, 139, 168, 0.0) 100%);
      border-left: 2px solid #f38ba8;
      border-radius: 4px;
      font-weight: bold;
      color: #ffffff;
    }
  '';

  tempStyle = pkgs.writeText "temp-style.css" ''
    window {
      background-color: rgba(11, 14, 20, 0.95);
      border: 2px solid #00ffff; /* Cyan Border */
      border-radius: 12px;
      font-family: "FiraCode Nerd Font", monospace;
    }
    #input { opacity: 0; }
    #inner-box { margin: 10px; background-color: transparent; }
    
    #entry { 
      padding: 12px; 
      margin: 2px 0px; 
      color: #c0c5ce; 
    }

    #entry:selected {
      /* Cyan Gradient for selection */
      background: linear-gradient(90deg, rgba(0, 255, 255, 0.2) 0%, rgba(0, 255, 255, 0.0) 100%);
      border-left: 3px solid #00ffff;
      border-radius: 0px 4px 4px 0px;
      font-weight: bold;
      color: #ffffff;
    }
  '';

  powerMenu = pkgs.writeShellScriptBin "power-menu" ''
    options="󰐥 Power Off\n󰜉 Reboot\n󰤄 Suspend\n󰗼 Logout"

    selected=$(echo -e "$options" | ${pkgs.wofi}/bin/wofi --show dmenu \
      --style ${powerStyle} \
      --width 160 --height 180 \
      --location 3 --xoffset -10 --yoffset 10 \
      --columns 1 \
      --prompt "") # Empty prompt helps keep it clean

    case $selected in
        "󰐥 Power Off") systemctl poweroff ;;
        "󰜉 Reboot") systemctl reboot ;;
        "󰤄 Suspend") systemctl suspend ;;
        "󰗼 Logout") ${pkgs.hyprland}/bin/hyprctl dispatch exit ;;
    esac
  '';

  gpuScript = pkgs.writeShellScriptBin "gpu-info" ''
    # Query NVIDIA-SMI for usage, temp, memory, name, power, fan, and clocks
    info=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,name,power.draw,power.limit,fan.speed,clocks.current.graphics,clocks.current.memory --format=csv,noheader,nounits)
    
    # Parse comma-separated values
    IFS=',' read -r usage temp used total name power power_limit fan core_clock mem_clock <<< "$info"

    # Trim whitespace from all variables
    usage=$(echo "$usage" | xargs)
    temp=$(echo "$temp" | xargs)
    used=$(echo "$used" | xargs)
    total=$(echo "$total" | xargs)
    name=$(echo "$name" | xargs)
    power=$(echo "$power" | xargs)
    power_limit=$(echo "$power_limit" | xargs)
    fan=$(echo "$fan" | xargs)
    core_clock=$(echo "$core_clock" | xargs)
    mem_clock=$(echo "$mem_clock" | xargs)

    # Format Tooltip
    # Line 1: GPU Name
    # Line 2: Usage % @ Core Clock (Temperature)
    # Line 3: Memory Used / Total @ Mem Clock
    # Line 4: Power Draw / Limit (Fan Speed)
    tooltip="<b>$name</b>\nCore: $usage% @ ''${core_clock}MHz ($temp°C)\nMem:  $used / $total MiB @ ''${mem_clock}MHz\nPwr:  ''${power}W / ''${power_limit}W (Fan: $fan%)"

    # Output JSON for Waybar
    echo "{\"text\": \"$usage\", \"tooltip\": \"$tooltip\"}"
  '';

  monitorTempMenu = pkgs.writeShellScriptBin "monitor-temp-menu" ''
    options=" Warm (5000K)\n Standard (6500K)\n Cool (9300K)\n User Mode"
    
    # Location 1 = Top Left
    selected=$(echo -e "$options" | ${pkgs.wofi}/bin/wofi --show dmenu \
      --style ${tempStyle} \
      --width 220 --height 200 \
      --location 1 --xoffset 10 --yoffset 10 \
      --columns 1 --prompt "")

    case $selected in
        " Warm (5000K)")     ddcutil setvcp 14 0x04 ;;
        " Standard (6500K)") ddcutil setvcp 14 0x05 ;;
        " Cool (9300K)")     ddcutil setvcp 14 0x08 ;;
        " User Mode")        ddcutil setvcp 14 0x0b ;;
    esac
  '';

in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 38;
        margin-top = 2;
        margin-bottom = 0;
        margin-left = 10;
        margin-right = 10;
        spacing = 4;

        modules-left = [ "custom/logo" "custom/monitor-temp" "hyprland/workspaces" "mpris" ];
        modules-center = [ "clock" ];
        # Added 'custom/cava' next to the media player
        modules-right = [ "custom/cava" "custom/gpu-usage" "cpu" "memory" "disk" "bluetooth" "custom/power" ];

        # --- MODULES ---

        "custom/logo" = {
          format = "";
          tooltip = false;
          on-click = "wofi --show drun";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 30;
          separate-outputs = true;
        };

        "mpris" = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "";
            spotify = "";
            firefox = "";
          };
          status-icons = {
            paused = "";
          };
          max-length = 30;
        };

        "custom/cava" = {
          exec = "cava -p <(echo -e '[general]\\nframerate=60\\nbars=12\\n[output]\\nmethod=raw\\nraw_target=/dev/stdout\\ndata_format=ascii\\nascii_max_range=7') | sed -u 's/;//g;s/0/ /g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'";
          format = "{}";
          tooltip = false;
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
        };

        "custom/gpu-usage" = {
          exec = "${gpuScript}/bin/gpu-info";
          return-type = "json";
          format = "󰢮 {}%";
          on-click = "coolercontrol"; 
          interval = 5;
        };

        "custom/files" = {
          format = "";
          tooltip-format = "Open File Manager";
          on-click = "thunar"; # Make sure you install 'xfce.thunar'
        };

        "custom/monitor-temp" = {
            format = "";
            tooltip-format = "Select Color Temperature";
            on-click = "${monitorTempMenu}/bin/monitor-temp-menu";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = true;
          on-click = "kitty -e btop";
        };

        "memory" = {
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
          on-click = "kitty -e btop";
        };

        "disk" = {
          format = " {percentage_used}%";
          path = "/";
          tooltip-format = "{free} Free";
          on-click = "baobab";
        };

        "bluetooth" = {
          format = "";
          format-disabled = "󰂲";

          format-connected = "󰂱 {num_connections}";
          format-connected-battery = "󰂱 {num_connections}";

          tooltip-format = " {controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}";

          tooltip-format-enumerate-connected = "󰂄 {device_battery_percentage}% \t{device_alias}\t{device_address}";

          tooltip-format-enumerate-connected-battery = "󰂄 {device_battery_percentage}% \t{device_alias}\t{device_address}";

          on-click = "blueman-manager";
        };

        "privacy" = {
          icon-spacing = 4;
          icon-size = 14;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };

        "tray" = {
          spacing = 10;
        };

        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = "󰑣 Muted";
          format-icons = ["" "" ""];
          on-click = "pavucontrol";
        };

        "clock" = {
          interval = 60;
          format = " {:%H:%M}";
          # Improved Alt Format: Shows "Day Name, DD-MM-YYYY" (e.g., "Mon, 15-01-2024")
          format-alt = " {:%a, %d-%m-%Y}";
          
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#b3f2ff'><b>{}</b></span>";
              days = "<span color='#c0c5ce'><b>{}</b></span>";
              weeks = "<span color='#00ffff'><b>W{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
          
          actions = {
            on-click-right = "mode"; # Right click switches between Month/Year view
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "custom/power" = {
          format = "";
          on-click = "${powerMenu}/bin/power-menu"; 
          tooltip = false;
        };
      };
    };

    style = ''
      * {
          border: none;
          font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono";
          font-size: 13px;
          font-weight: bold;
          min-height: 0;
      }

      window#waybar {
          background-color: transparent;
      }

      @keyframes border-flow {
          0% { border-color: #00ffff; }
          33% { border-color: #c0c5ce; }
          66% { border-color: #00bfff; }
          100% { border-color: #00ffff; }
      }

      @keyframes power-flow {
          0% { border-color: #f38ba8; }
          50% { border-color: #fab387; } 
          100% { border-color: #f38ba8; }
      }

      /* --- UNIFIED PILL STYLE (DEFAULT) --- */
      /* This sets a balanced default for Clock, CPU, Memory, etc. */
      #custom-logo, 
      #custom-files,
      #custom-monitor-temp,
      #workspaces, 
      #window, 
      #mpris,
      #custom-cava,
      #custom-gpu-usage,
      #cpu, 
      #memory, 
      #disk, 
      #bluetooth, 
      #tray,
      #privacy,
      #wireplumber, 
      #clock, 
      #custom-power {
          background-color: rgba(11, 14, 20, 0.8);
          color: #b3f2ff;
          border: 2px solid #00ffff;
          border-radius: 1000px;
          
          animation-name: border-flow;
          animation-duration: 4s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;

          margin: 3px 3px; 
          
          /* STANDARD BALANCED PADDING for everything else */
          padding: 4px 12px;
      }

      /* --- TARGETED FIXES --- */

      /* 1. FORCE CIRCLES: Logo, Files, Temp, Power */
      /* By using symmetric padding (10px on both sides), these become circles. */
      #custom-logo, 
      #custom-files, 
      #custom-monitor-temp, 
      #custom-power {
          font-size: 18px;
          padding-right: 10px;
          min-width: 15px; /* Ensures narrower icons don't shrink the circle */
      }

      /* 2. COLORS & FONTS */
      
      #custom-logo {
          padding-left: 5px;
          padding-right: 11px;
      }

      #custom-monitor-temp {
          padding-left: 5px;
      }

      #custom-files {
          padding-left: 6px;
      }

      #custom-power {
          color: #f38ba8;
          padding-left: 6px;
          animation-name: power-flow;
      }

      /* 3. WORKSPACES: Fix "Too small a space" & "Center alignment" */
      #workspaces {
          padding-left: 2px;
          padding-right: 2px;
          padding-top: 0px;
          padding-bottom: 0px;
      }

      #workspaces button {
          color: #b3f2ff;
          /* Increased min-width to give breathing room */
          min-width: 20px; 
          margin: 0px 1px;
          
          /* Asymmetric padding to center the icon (Less Left, More Right) */
          padding-left: 0px;
          padding-right: 6px;
      }

      #workspaces button.active {
          background-color: rgba(0, 255, 255, 0.15);
          border-radius: 1000px;
          box-shadow: 0 0 2px 1px rgba(0, 255, 255, 0.15);
      }
      
      #workspaces button:hover {
          background-color: rgba(255, 255, 255, 0.1);
          border-radius: 1000px;
      }

      /* --- OTHER MODULES (Unchanged) --- */
      #custom-cava {
          font-family: "FiraCode Nerd Font", "Noto Color Emoji"; 
          padding-right: 16px; 
      }



      #tray, #privacy {
          padding: 4px 10px;
      }
    '';
  };
}
