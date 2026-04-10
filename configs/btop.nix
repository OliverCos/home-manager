{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop.override { cudaSupport = true; };
    settings = {
      color_theme = "artemis";
      theme_background = true;
      truecolor = true;

      presets = "cpu:0:default,mem:0:default,net:0:default,proc:0:default,gpu:0:default";
      graph_symbol = "braille";
      rounded_corners = true;
      proc_gradient = true;
      proc_colors = true;

      update_ms = 1000;

      shown_boxes = "cpu mem net proc gpu0";
    };
  };

  xdg.configFile."btop/themes/artemis.theme".text = ''
    # Artemis — lofi/space theme
    # Dusty blues, amber accents, cloud whites on deep void

    # --- MAIN INTERFACE ---
    theme[main_bg]="#08090d"
    theme[main_fg]="#c8d1dc"
    theme[title]="#dbe4ec"
    theme[hi_fg]="#d49759"

    # --- BOX OUTLINES (dim ocean blue) ---
    theme[cpu_box]="#3a5b7a"
    theme[mem_box]="#3a5b7a"
    theme[net_box]="#3a5b7a"
    theme[proc_box]="#3a5b7a"
    theme[div_line]="#1f242e"

    # --- SELECTION & INACTIVE ---
    theme[selected_bg]="#d49759"
    theme[selected_fg]="#08090d"
    theme[inactive_fg]="#4a525e"
    theme[meter_bg]="#15191f"

    # --- MISC TEXT ---
    theme[graph_text]="#8fb4d4"
    theme[proc_misc]="#7e8694"

    # --- TEMPERATURE GRADIENT (cool → hot) ---
    theme[temp_start]="#6b8db0"
    theme[temp_mid]="#d49759"
    theme[temp_end]="#b85842"

    # --- CPU GRAPH (data stream) ---
    theme[cpu_start]="#3a5b7a"
    theme[cpu_mid]="#8fb4d4"
    theme[cpu_end]="#dbe4ec"

    # --- MEMORY & DISK METERS ---
    # Free (dim ocean)
    theme[free_start]="#3a5b7a"
    theme[free_mid]="#6b8db0"
    theme[free_end]="#8fb4d4"

    # Cached (muted slate)
    theme[cached_start]="#3a4250"
    theme[cached_mid]="#4a525e"
    theme[cached_end]="#5a6270"

    # Available (glow blue)
    theme[available_start]="#6b8db0"
    theme[available_mid]="#8fb4d4"
    theme[available_end]="#b3d4ec"

    # Used (amber → solar)
    theme[used_start]="#6b8db0"
    theme[used_mid]="#d49759"
    theme[used_end]="#f0b070"

    # --- NETWORK GRAPHS ---
    # Download (cool blue)
    theme[download_start]="#3a5b7a"
    theme[download_mid]="#8fb4d4"
    theme[download_end]="#dbe4ec"

    # Upload (amber, direction = warmth)
    theme[upload_start]="#a85b2e"
    theme[upload_mid]="#d49759"
    theme[upload_end]="#f0b070"

    # --- PROCESS BOX ---
    theme[process_start]="#6b8db0"
    theme[process_mid]="#8fb4d4"
    theme[process_end]="#d49759"
  '';
}
