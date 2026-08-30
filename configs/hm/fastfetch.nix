{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " ";
      };

      logo = {
        type = "none";
      };

      modules = [
        {
          type = "custom";
          key = " ";
          format = "{#bright_blue}"+ builtins.readFile ./logo.txt + "{#}";
        }

        "os"
        "kernel"
        "wm"
        "shell"
        "cpu"
        "gpu"
        "memory"
      ];
    };
  };
}
