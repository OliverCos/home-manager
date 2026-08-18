{ pkgs, ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "fedora_small";
        color = {
          "1" = "34";
          "2" = "37";
        };
        padding = { top = 1; right = 2; };
      };
      display = {
        separator = "   ";
        color = {
          keys = "33";
          title = "37";
        };
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "os    ";
          keyColor = "33";
        }
        {
          type = "host";
          key = "host  ";
          keyColor = "33";
        }
        {
          type = "kernel";
          key = "kernel";
          keyColor = "33";
        }
        {
          type = "uptime";
          key = "up    ";
          keyColor = "33";
        }
        {
          type = "packages";
          key = "pkgs  ";
          keyColor = "33";
        }
        {
          type = "cpu";
          key = "cpu   ";
          keyColor = "33";
        }
        {
          type = "gpu";
          key = "gpu   ";
          keyColor = "33";
        }
        {
          type = "memory";
          key = "mem   ";
          keyColor = "33";
        }
        {
          type = "display";
          key = "disp  ";
          keyColor = "33";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
