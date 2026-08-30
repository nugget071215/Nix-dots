{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Rose Pine";
      font-size = 15;
      background-opacity = 1.0;
      background-blur = "macos-glass-regular";
      font-family = "Maple Mono";
    };
  };
}
