{ ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";

    # --- FADING ---
    fade = true;
    fadeSteps = [ 0.04 0.04 ];
    fadeDelta = 5;

    # --- SHADOWS ---
    shadow = true;
    shadowOffsets = [ (-12) (-12) ];
    shadowOpacity = 0.6;
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'i3bar'"
      "class_g = 'i3-frame'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    # --- OPACITY ---
    activeOpacity = 1.0;
    inactiveOpacity = 0.92;
    opacityRules = [
      "100:class_g = 'i3bar'"
      "100:name = 'i3lock'"
    ];

    # --- SETTINGS (blur + misc) ---
    settings = {
      # Shadow colour — matches the dark palette
      shadow-color = "#000000";

      # Blur background of transparent windows
      blur-method = "dual_kawase";
      blur-strength = 8;
      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = false;
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # GLX tuning
      use-damage = true;

      # Misc
      corner-radius = 10;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'i3bar'"
      ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = false;
      detect-client-opacity = true;
      detect-transient = true;
    };
  };
}
