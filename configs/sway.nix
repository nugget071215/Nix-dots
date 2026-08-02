{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    kitty
    fuzzel
    mako
    swaybg
    wl-clipboard
    grim
    slurp
    playerctl

    inputs.swayfx.packages.${pkgs.system}.swayfx
  ];

  xdg.configFile."sway/config".text = ''
    #################
    # SwayFX Config #
    #################

    set $mod Mod4

    # Appearance
    font pango:JetBrainsMono Nerd Font 10

    # Terminal
    set $term kitty

    # Launcher
    set $menu noctalia-shell ipc call launcher toggle

    #################
    # Startup
    #################

    exec_always noctalia-shell

    #################
    # Keybinds
    #################

    bindsym $mod+Return exec $term
    bindsym Mod1+Space exec $menu

    bindsym $mod+w kill

    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+e exec swaynag \
      -t warning \
      -m "Exit Sway?" \
      -B "Yes" "swaymsg exit"


    #################
    # Movement
    #################

    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right


    #################
    # Workspaces
    #################

    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5

    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3


    #################
    # Layout
    #################

    default_border pixel 2

    gaps inner 8
    gaps outer 12

    smart_gaps on
    smart_borders on


    #################
    # SwayFX Effects
    #################

    blur enable
    blur_radius 8
    blur_passes 3

    shadows enable
    shadow_blur_radius 15
    shadow_color #000000aa

    corner_radius 10

    default_dim_inactive 0.05


    #################
    # Floating
    #################

    floating_modifier $mod normal


    #################
    # Media Keys
    #################

    bindsym $mod+bracketleft exec pamixer -i 5
    bindsym $mod+bracketright exec pamixer -d 5
    bindsym XF86AudioMute exec pamixer -t
  '';
}
