{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      # --- LAYOUT SETTINGS ---
      width = 800;       # Wider to fit 2 columns comfortably
      height = "25%";    # Shorter vertical footprint
      columns = 2;       # Enable 2-column mode
      location = "center";
      
      # --- BEHAVIOR ---
      show = "drun";
      prompt = "Search Protocol...";
      filter_rate = 100;
      allow_images = true;
      image_size = 24;
      no_actions = true;
      single_click = true;
      insensitive = true;
    };

    style = ''
      /* Main Window */
      window {
          margin: 0px;
          border: 2px solid #00ffff;
          background-color: rgba(11, 14, 20, 0.8);
          font-family: "FiraCode Nerd Font", monospace;
          border-radius: 24px;
      }

      /* Search Bar - Spans full width */
      #input {
          margin: 15px;
          padding: 10px 15px;
          border: 2px solid #00ffff;
          border-radius: 100px;
          background-color: rgba(26, 26, 26, 0.7);
          color: #b3f2ff;
          font-weight: bold;
      }

      #inner-box {
          margin: 5px;
          background-color: transparent;
      }

      #outer-box {
          margin: 5px;
          background-color: transparent;
      }

      #scroll {
          margin: 0px;
          border: none;
      }

      #text {
          margin: 5px;
          border: none;
          color: #b3f2ff;
      }

      /* Entries - Now in columns */
      #entry {
          margin: 2px 10px; /* Slightly reduced side margin for columns */
          padding: 10px;
          border-radius: 10px;
          border: 1px solid transparent;
      }

      /* Selected Entry */
      #entry:selected {
          background: linear-gradient(90deg, rgba(0, 255, 255, 0.2) 0%, rgba(0, 255, 255, 0.0) 100%);
          border: 1px solid #00ffff;
          border-radius: 10px;
          outline: none;
      }

      #text:selected {
          color: #ffffff;
          font-weight: bold;
          text-shadow: 0px 0px 5px rgba(0, 255, 255, 0.8);
      }

      #img {
          margin-right: 15px;
          background-color: transparent;
      }
    '';
  };
}