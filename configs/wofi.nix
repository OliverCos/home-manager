{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      # --- LAYOUT ---
      width = 800;
      height = "25%";
      columns = 2;
      location = "center";

      # --- BEHAVIOR ---
      show = "drun";
      prompt = "search the void…";
      filter_rate = 100;
      allow_images = true;
      image_size = 28;
      no_actions = true;
      single_click = true;
      insensitive = true;
    };

    style = ''
      /* Main Window */
      window {
          margin: 0px;
          border: 1px solid rgba(212, 151, 89, 0.55);
          background-color: rgba(8, 9, 13, 0.78);
          font-family: "JetBrainsMono Nerd Font", monospace;
          border-radius: 20px;
      }

      /* Search Bar */
      #input {
          margin: 18px;
          padding: 12px 18px;
          border: 1px solid rgba(143, 180, 212, 0.35);
          border-radius: 14px;
          background-color: rgba(15, 18, 24, 0.7);
          color: #dbe4ec;
          font-weight: 500;
      }

      #input:focus {
          border: 1px solid rgba(212, 151, 89, 0.55);
      }

      #inner-box {
          margin: 6px 14px;
          background-color: transparent;
      }

      #outer-box {
          margin: 4px;
          background-color: transparent;
      }

      #scroll {
          margin: 0px;
          border: none;
      }

      #text {
          margin: 6px 10px;
          border: none;
          color: #c8d1dc;
      }

      /* Entries */
      #entry {
          margin: 3px 8px;
          padding: 10px 14px;
          border-radius: 12px;
          border: 1px solid transparent;
      }

      /* Selected Entry */
      #entry:selected {
          background: linear-gradient(90deg, rgba(212, 151, 89, 0.22) 0%, rgba(212, 151, 89, 0.0) 100%);
          border: 1px solid rgba(212, 151, 89, 0.55);
          border-radius: 12px;
          outline: none;
      }

      #text:selected {
          color: #dbe4ec;
          font-weight: 600;
          text-shadow: 0px 0px 4px rgba(212, 151, 89, 0.4);
      }

      #img {
          margin-right: 14px;
          background-color: transparent;
      }
    '';
  };
}
