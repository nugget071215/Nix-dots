{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        height = 64;

        margin-top = 8;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "clock"
        ];

        modules-center = [
          "ext/workspaces"
        ];

        modules-right = [
          "battery"
        ];

        clock = {
          format = "{:%I%M %p}";
          tooltip = false;
        };

        battery = {
          format = "{capacity}%";
          tooltip = false;
        };

        "ext/workspaces" = {
          format = "{name}";
          disable-scroll = true;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 28px;
      }

      window#waybar {
        background: rgba(25,23,36,0.8);
        border-radius: 14
      }

      #clock,
      #battery {
        background: rgba(31, 29, 46, 0.9);
        color: #e0def4;

        padding: 0px 18px;
        margin: 8px;

        border-radius: 14px;
      }

      #workspaces {
        background: rgba(25, 23, 36, 0.8);

        padding: 6px 12px;
        margin: 8px;

        border-radius: 18px;
      }

      #workspaces button {
        background: transparent;

        color: #e0def4;

        border-radius: 14px;

        min-width: 14px;
        min-height: 14px;

        padding: 0px 4px;

        transition: all 200ms ease;
      }

      #workspaces button.active {
        background: #eb6f92;

        color: #191724;

        min-width: 32px;
      }

      #workspaces button:hover {
        background: #26233a;
      }
    '';
  };
}
