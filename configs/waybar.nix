{
  "layer": "top",
  "position": "top",
  "height": 34,

  "modules-left": [
    "custom/launcher",
    "ext/workspaces"
  ],

  "modules-center": [
    "clock"
  ],

  "modules-right": [
    "pulseaudio",
    "network",
    "power-profiles-daemon",
    "tray"
  ],

  "custom/launcher": {
    "format": "󰣇",
    "on-click": "fuzzel"
  },

  "hyprland/workspaces": {
    "format": "{name}",
    "on-click": "activate"
  },

  "clock": {
    "format": "󰥔  {:%a %b %d  •  %I:%M %p}",
    "tooltip-format": "<big>{:%A, %B %d, %Y}</big>"
  },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰝟 muted",
    "format-icons": {
      "default": ["󰕿", "󰖀", "󰕾"]
    }
  },

  "network": {
    "format-wifi": "󰖩 {essid}",
    "format-ethernet": "󰈀 ethernet",
    "format-disconnected": "󰖪 offline"
  },

  "power-profiles-daemon": {
    "format": "{icon} {capacity}%",
    "format-icons": ["󰂎", "󰁺", "󰁼", "󰁾", "󰂀"]
  },

  "tray": {
    "spacing": 8
  }
}
