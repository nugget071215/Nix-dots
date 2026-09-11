input {
    touchpad {
        tap
        natural-scroll
    }

    mouse {
        accel-profile "flat"
    }
}

output "eDP-1" {
    mode "1920x1200@60"

    scale 1

    transform "normal"
}

layout {
    gaps 12

    center-focused-column "never"

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
    }

    default-column-width { proportion 0.5; }

    focus-ring {
        width 4

        active-color "#89b4fa"

        inactive-color "#313244"
    }

    border {
        off

        width 4
        active-color "#ffc87f"
        inactive-color "#505050"

        urgent-color "#9b0000"
    }

    shadow {
        on

        softness 30

        spread 5

        offset x=0 y=5

        color "#0007"
    }

    // Struts shrink the area occupied by windows, similarly to layer-shell panels.
    // You can think of them as a kind of outer gaps. They are set in logical pixels.
    // Left and right struts will cause the next window to the side to always be visible.
    // Top and bottom struts will simply add outer gaps in addition to the area occupied by
    // layer-shell panels and regular gaps.
    struts {
        // left 64
        // right 64
        // top 64
        // bottom 64
    }
}

// Add lines like this to spawn processes at startup.
// Note that running niri as a session supports xdg-desktop-autostart,
// which may be more convenient to use.
// See the binds section below for more spawn examples.

// This line starts waybar, a commonly used bar for Wayland compositors.
spawn-at-startup "waybar"
spawn-at-startup "dms"
spawn-at-startup "dex" "--autostart" "--environment" "niri"
spawn-at-startup "waypaper" "--restore"
spawn-at-startup "xwayland-satellite"

// To run a shell command (with variables, pipes, etc.), use spawn-sh-at-startup:
// spawn-sh-at-startup "qs -c ~/source/qs/MyAwesomeShell"

hotkey-overlay {
    // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
    // skip-at-startup
}

// Uncomment this line to ask the clients to omit their client-side decorations if possible.
// If the client will specifically ask for CSD, the request will be honored.
// Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
// This option will also fix border/focus ring drawing behind some semitransparent windows.
// After enabling or disabling this, you need to restart the apps for this to take effect.
prefer-no-csd

// You can change the path where screenshots are saved.
// A ~ at the front will be expanded to the home directory.
// The path is formatted with strftime(3) to give you the screenshot date and time.
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

// You can also set this to null to disable saving screenshots to disk.
// screenshot-path null

// Animation settings.
// The wiki explains how to configure individual animations:
// https://niri-wm.github.io/niri/Configuration:-Animations
animations {
    // Uncomment to turn off all animations.
    // off

    // Slow down all animations by this factor. Values below 1 speed them up instead.
    // slowdown 3.0
}

// Window rules let you adjust behavior for individual windows.
// Find more information on the wiki:
// https://niri-wm.github.io/niri/Configuration:-Window-Rules

// Work around WezTerm's initial configure bug
// by setting an empty default-column-width.
window-rule {
    // This regular expression is intentionally made as specific as possible,
    // since this is the default config, and we want no false positives.
    // You can get away with just app-id="wezterm" if you want.
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}

// Open the Firefox picture-in-picture player as floating by default.
window-rule {
    // This app-id regular expression will work for both:
    // - host Firefox (app-id is "firefox")
    // - Flatpak Firefox (app-id is "org.mozilla.firefox")
    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    open-floating true
}

// Example: block out two password managers from screen capture.
// (This example rule is commented out with a "/-" in front.)
/-window-rule {
    match app-id=r#"^org\.keepassxc\.KeePassXC$"#
    match app-id=r#"^org\.gnome\.World\.Secrets$"#

    block-out-from "screen-capture"

    // Use this instead if you want them visible on third-party screenshot tools.
    // block-out-from "screencast"
}

// Example: enable rounded corners for all windows.
// (This example rule is commented out with a "/-" in front.)
/-window-rule {
    geometry-corner-radius 12
    clip-to-geometry true
}

binds {
    Mod+Shift+Slash { show-hotkey-overlay; }

    Mod+Return hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }

    Alt+Space hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }

    Mod+W repeat=false { close-window; }

    Mod+Ctrl+F { fullscreen-window; }

    Mod+Shift+Space { toggle-window-floating; }

    Mod+Space { switch-focus-between-floating-and-tiling; }

    Mod+O repeat=false { toggle-overview; }

    Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }

    Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }

    XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
    XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
    XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

    XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
    XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
    XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
    XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }

    XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
    XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

    Mod+Left  { focus-column-left; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }
    Mod+Right { focus-column-right; }
    Mod+H     { focus-column-left; }
    Mod+J     { focus-window-down; }
    Mod+K     { focus-window-up; }
    Mod+L     { focus-column-right; }

    Mod+Shift+Left      { move-column-left; }
    Mod+Shift+Down      { move-window-down; }
    Mod+Shift+Up        { move-window-up; }
    Mod+Shift+Right     { move-column-right; }
    Mod+Shift+H         { move-column-left; }
    Mod+Shift+J         { move-window-down; }
    Mod+Shift+K         { move-window-up; }
    Mod+Shift+L         { move-column-right; }
    Mod+Shift+Semicolon { move-column-right; }

    Mod+Home      { focus-column-first; }
    Mod+End       { focus-column-last; }
    Mod+Ctrl+Home { move-column-to-first; }
    Mod+Ctrl+End  { move-column-to-last; }

    Mod+Page_Down      { focus-workspace-down; }
    Mod+Page_Up        { focus-workspace-up; }
    Mod+U              { focus-workspace-down; }
    Mod+I              { focus-workspace-up; }
    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
    Mod+Ctrl+U         { move-column-to-workspace-down; }
    Mod+Ctrl+I         { move-column-to-workspace-up; }

    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
    Mod+Shift+U         { move-workspace-down; }
    Mod+Shift+I         { move-workspace-up; }

    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

    Mod+WheelScrollRight      { focus-column-right; }
    Mod+WheelScrollLeft       { focus-column-left; }
    Mod+Ctrl+WheelScrollRight { move-column-right; }
    Mod+Ctrl+WheelScrollLeft  { move-column-left; }

    Mod+Shift+WheelScrollDown      { focus-column-right; }
    Mod+Shift+WheelScrollUp        { focus-column-left; }
    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }

    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }
    Mod+Shift+6 { move-column-to-workspace 6; }
    Mod+Shift+7 { move-column-to-workspace 7; }
    Mod+Shift+8 { move-column-to-workspace 8; }
    Mod+Shift+9 { move-column-to-workspace 9; }

    Mod+BracketLeft  { consume-or-expel-window-left; }
    Mod+BracketRight { consume-or-expel-window-right; }
    Mod+Comma        { consume-window-into-column; }
    Mod+Period       { expel-window-from-column; }

    Mod+R            { switch-preset-column-width; }
    Mod+Shift+R      { switch-preset-column-width-back; }
    Mod+Ctrl+Shift+R { switch-preset-window-height; }
    Mod+Ctrl+R       { reset-window-height; }
    Mod+F            { expand-column-to-available-width; }

    Mod+C     { center-column; }
    Mod+Ctrl+C { center-visible-columns; }

    Mod+Minus        { set-column-width "-10%"; }
    Mod+Equal        { set-column-width "+10%"; }
    Mod+Shift+Minus  { set-window-height "-10%"; }
    Mod+Shift+Equal  { set-window-height "+10%"; }

    Print       { screenshot; }
    Mod+Shift+S { screenshot; }
    Ctrl+Print  { screenshot-screen; }
    Alt+Print   { screenshot-window; }

    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

    // Quit (i3: Mod+Shift+E)
    Mod+Shift+E  { quit; }
}
