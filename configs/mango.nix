{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.mangowm.packages.${pkgs.system}.default
  ];

  xdg.configFile."mango/config.conf".text = ''
      
    exec-once=quickshell
    exec-once=swayidle -w
    exec-once=waypaper --restore

    monitorrule=name:^HDMI-A-1$,width:2560,height:1440,refresh:144,x:1920,y:0
    monitorrule=name:^eDP-1$,width:1920,height:1200,x:0,y:0

    blur=1
    blur_layer=0
    blur_optimized=1
    blur_params_num_passes = 2
    blur_params_radius = 5
    blur_params_noise = 0.02
    blur_params_brightness = 0.9
    blur_params_contrast = 0.9
    blur_params_saturation = 1.2

    shadows = 1
    layer_shadows = 0
    shadow_only_floating = 1
    shadows_size = 10
    shadows_blur = 15
    shadows_position_x = 0
    shadows_position_y = 0
    shadowscolor= 0x000000ff

    border_radius=4
    no_radius_when_single=0
    focused_opacity=1.0
    unfocused_opacity=1.0

    animations=1
    layer_animations=1
    animation_type_open=slide
    animation_type_close=slide
    animation_fade_in=1
    animation_fade_out=1
    tag_animation_direction=1
    zoom_initial_ratio=0.4
    zoom_end_ratio=0.8
    fadein_begin_opacity=0.5
    fadeout_begin_opacity=0.8
    animation_duration_move=500
    animation_duration_open=400
    animation_duration_tag=350
    animation_duration_close=800
    animation_duration_focus=0
    animation_curve_open=0.46,1.0,0.29,1
    animation_curve_move=0.46,1.0,0.29,1
    animation_curve_tag=0.46,1.0,0.29,1
    animation_curve_close=0.08,0.92,0,1
    animation_curve_focus=0.46,1.0,0.29,1
    animation_curve_opafadeout=0.5,0.5,0.5,0.5
    animation_curve_opafadein=0.46,1.0,0.29,1

    scroller_structs=20
    scroller_default_proportion=0.8
    scroller_focus_center=0
    scroller_prefer_center=0
    edge_scroller_pointer_focus=1
    edge_scroller_focus_allow_speed=0.0
    scroller_default_proportion_single=1.0
    scroller_proportion_preset=0.5,0.8,1.0

    new_is_master=1
    default_mfact=0.55
    default_nmaster=1
    smartgaps=0

    dwindle_smart_split=0
    dwindle_drop_simple_split=1
    dwindle_manual_split=0
    dwindle_hsplit=1
    dwindle_vsplit=1
    dwindle_preserve_split=0

    hotarea_size=10
    enable_hotarea=0
    ov_tab_mode=0
    ov_no_resize=1
    overviewgappi=5
    overviewgappo=30

    no_border_when_single=0
    axis_bind_apply_timeout=100
    focus_on_activate=1
    idleinhibit_ignore_visible=0
    sloppyfocus=1
    warpcursor=1
    focus_cross_monitor=0
    focus_cross_tag=0
    enable_floating_snap=0
    snap_distance=30
    cursor_size=24
    drag_tile_to_tile=1
    drag_tile_small=1
    
    repeat_rate=25
    repeat_delay=600
    numlockon=0
    xkb_rules_layout=us

    disable_trackpad=0
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=0
    disable_while_typing=1
    left_handed=0
    middle_button_emulation=0
    swipe_min_threshold=1

    mouse_natural_scrolling=0
    mouse_accel_profile=1 
    mouse_accel_speed=-0.5

    gappih=5
    gappiv=5
    gappoh=10
    gappov=10
    scratchpad_width_ratio=0.8
    scratchpad_height_ratio=0.9
    borderpx=4
    rootcolor=0x201b14ff
    bordercolor=0x444444ff
    dropcolor=0x8FBA7C55
    splitcolor=0xEB441EFF
    focuscolor=0xc9b890ff
    maximizescreencolor=0x89aa61ff
    urgentcolor=0xad401fff
    scratchpadcolor=0x516c93ff
    globalcolor=0xb153a7ff
    overlaycolor=0x14a57cff

    tagrule=id:1,layout_name:tile
    tagrule=id:2,layout_name:tile
    tagrule=id:3,layout_name:tile
    tagrule=id:4,layout_name:tile
    tagrule=id:5,layout_name:tile
    tagrule=id:6,layout_name:tile
    tagrule=id:7,layout_name:tile
    tagrule=id:8,layout_name:tile
    tagrule=id:9,layout_name:tile

    bind=SUPER,R,reload_config

    bind=SUPER,Return,spawn,kitty
    bind=ALT,Space,spawn,fuzzel

    bind=SUPER,W,killclient
    bind=SUPER+SHIFT,E,quit

    bind=SUPER,H,focusdir,left
    bind=SUPER,L,focusdir,right
    bind=SUPER,J,focusdir,up
    bind=SUPER,K,focusdir,down

    bind=SUPER+SHIFT,H,exchange_client,left
    bind=SUPER+SHIFT,L,exchange_client,right
    bind=SUPER+SHIFT,J,exchange_client,up
    bind=SUPER+SHIFT,K,exchange_client,down

    bind=SUPER,Tab,togglefloating

    bind=SUPER,F,togglefullscreen

    bind=SUPER,N,switch_layout

    bind=SUPER,1,view,1,0
    bind=SUPER,2,view,2,0
    bind=SUPER,3,view,3,0
    bind=SUPER,4,view,4,0
    bind=SUPER,5,view,5,0
    bind=SUPER,6,view,6,0
    bind=SUPER,7,view,7,0
    bind=SUPER,8,view,8,0
    bind=SUPER,9,view,9,0

    bind=SUPER+SHIFT,1,tag,1,0
    bind=SUPER+SHIFT,2,tag,2,0
    bind=SUPER+SHIFT,3,tag,3,0
    bind=SUPER+SHIFT,4,tag,4,0
    bind=SUPER+SHIFT,5,tag,5,0
    bind=SUPER+SHIFT,6,tag,6,0
    bind=SUPER+SHIFT,7,tag,7,0
    bind=SUPER+SHIFT,8,tag,8,0
    bind=SUPER+SHIFT,9,tag,9,0

    mousebind=SUPER,btn_left,moveresize,curmove
    mousebind=SUPER,btn_right,moveresize,curresize

    bind=SUPER+SHIFT,S,spawn,hypshot -m region

    bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+
    bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-
    bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle

    bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl s +5%
    bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl s 5%-

    bind=SUPER,comma,focusmon,left
    bind=SUPER,period,focusmon,right

    bind=SUPER+SHIFT,comma,tagmon,left
    bind=SUPER+SHIFT,period,tagmon,right

    bind=SUPER,minus,adjust_mfact,-0.05
    bind=SUPER,equal,adjust_mfact,+0.05
    
    bind=SUPER+SHIFT,B,spawn,quickshell
    bind=SUPER+SHIFT+C,spawn,qs ipc call notifications toggle
  '';
}
