{ pkgs, ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = { top = 1; };
      };
      display = {
        separator = "   ";
        color = {
          keys = "36";
          title = "36";
        };
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "SYSTEM  ";
          keyColor = "36";
        }
        {
          type = "host";
          key = "MACHINE ";
          keyColor = "36";
        }
        {
          type = "kernel";
          key = "KERNEL  ";
          keyColor = "36";
        }
        {
          type = "uptime";
          key = "RUNTIME ";
          keyColor = "36";
        }
        {
          type = "packages";
          key = "MODULES ";
          keyColor = "36";
        }
        {
          type = "memory";
          key = "MEMORY  ";
          keyColor = "36";
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