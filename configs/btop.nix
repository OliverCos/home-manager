{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { cudaSupport = true; };
    settings = {
      color_theme = "arc";
      theme_background = false;
      truecolor = false;
      
      # --- LAYOUT PRESETS ---
      # This specific string forces a layout reset where:
      # CPU is top-left/wide, PROC/MEM/NET are grouped, and GPU is distinctly separated.
      presets = "cpu:0:default,mem:0:default,net:0:default,proc:0:default,gpu:0:default";      # --- VISUALS ---
      graph_symbol = "braille";
      rounded_corners = true;
      proc_gradient = true;
      proc_colors = true;
      
      # Faster updates for that "live terminal" feel
      update_ms = 1000;

      # Ensure all modules are active
      shown_boxes = "cpu mem net proc gpu0";
    };
  };

  # THEME FILE (High Contrast Version)
xdg.configFile."btop/themes/arc.theme".text = ''
    # Arc Forerunner Protocol Theme
    # A high-contrast "Hard Light" interface

    # --- MAIN INTERFACE ---
    theme[main_bg]="#0b0e14"   # Deep Void
    theme[main_fg]="#b3f2ff"   # Soft Cyan Text
    theme[title]="#e0ffff"     # Icy White Titles
    theme[hi_fg]="#ffffff"     # Pure White Highlights

    # --- BOX OUTLINES (High Contrast) ---
    # Setting these to Icy White makes the borders pop against the black background
    theme[cpu_box]="#e0ffff" 
    theme[mem_box]="#e0ffff"
    theme[net_box]="#e0ffff"
    theme[proc_box]="#e0ffff"
    theme[div_line]="#e0ffff"

    # --- SELECTION & INACTIVE ---
    theme[selected_bg]="#00ffff" # Hard Light Selection
    theme[selected_fg]="#0b0e14" # Black Text on Cyan
    theme[inactive_fg]="#3a4655" # Dark Slate (Inactive)
    theme[meter_bg]="#1a1e29"    # Darker Grey for empty meter backgrounds

    # --- MISC TEXT ---
    theme[graph_text]="#00ffff"  # Cyan text on graphs
    theme[proc_misc]="#b3f2ff"   # Small details in Cyan

    # --- TEMPERATURE GRADIENT ---
    # Cyan (Cool) -> Teal -> White (Hot/Intensity)
    theme[temp_start]="#00ffff"
    theme[temp_mid]="#008b8b"
    theme[temp_end]="#ffffff"

    # --- CPU GRAPH (Data Stream) ---
    theme[cpu_start]="#008b8b"
    theme[cpu_mid]="#00ffff"
    theme[cpu_end]="#e0ffff"

    # --- MEMORY & DISK METERS ---
    # Free Space (Solid Cyan)
    theme[free_start]="#00ffff"
    theme[free_mid]="#00ffff"
    theme[free_end]="#00ffff"

    # Cached (Dark Grey/Slate - "Ghost Data")
    theme[cached_start]="#3a4655"
    theme[cached_mid]="#4a5665"
    theme[cached_end]="#5a6675"

    # Available (Teal Gradient)
    theme[available_start]="#008b8b"
    theme[available_mid]="#00ffff"
    theme[available_end]="#e0ffff"

    # Used (Cyan -> White Intensity)
    theme[used_start]="#00ffff"
    theme[used_mid]="#b3f2ff"
    theme[used_end]="#ffffff"

    # --- NETWORK GRAPHS ---
    # Download (Cyan/Bright)
    theme[download_start]="#008b8b"
    theme[download_mid]="#00ffff"
    theme[download_end]="#ffffff"

    # Upload (Teal/Darker)
    theme[upload_start]="#006666"
    theme[upload_mid]="#008b8b"
    theme[upload_end]="#00ffff"

    # --- PROCESS BOX ---
    theme[process_start]="#008b8b"
    theme[process_mid]="#00ffff"
    theme[process_end]="#e0ffff"
  '';
}