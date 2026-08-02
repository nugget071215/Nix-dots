{ config, pkgs, ... }:

{
  programs.swaylock = {
    enable = true;

    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      font = "JetBrainsMono Nerd Font";

      clock = true;
      timestr = "%I:%M %p";
      datestr = "%A, %B %d";

      indicator = true;
      indicator-radius = 120;
      indicator-thickness = 8;

      inside-color = "191724cc";
      inside-clear-color = "26233acc";
      inside-ver-color = "31748fcc";
      inside-wrong-color = "eb6f92cc";

      ring-color = "ebbcba";
      ring-clear-color = "9ccfd8";
      ring-ver-color = "31748f";
      ring-wrong-color = "eb6f92";

      text-color = "e0def4";

      effect-blur = "7x3";
      effect-vignette = "0.5:0.5";
    };
  };
}
