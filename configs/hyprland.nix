{ ... }:

{
  xdg.configFile."hypr/hyprland.lua".text = ''
    hl.on("hyprland.start", function ()
        hl.exec_cmd("noctalia-shell")
        hl.exec_cmd("hyprctl setcursor GoogleDot-Black 24")
        hl.exec_cmd("waypaper --restore")
    end)

    hl.monitor({
        output   = "HDMI-A-1",
        mode     = "2560x1440@144",
        position = "auto",
        scale    = "1.0",
    })

    hl.monitor({
        output   = "eDP-1",
        mode     = "preferred",
        position = "auto",
        scale    = "1",
    })

    hl.config({
        input = {
            kb_layout  = "us",
            follow_mouse = 1,
            accel_profile = "flat",
            sensitivity = -0.4,
        },
    })

    hl.device({
        name        = "asce1205:00-04f3:3313-touchpad",
        sensitivity = 0,
    })

    local mainMod = "SUPER"

    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
    hl.bind(mainMod .. " + W", hl.dsp.window.close())
    hl.bind("ALT + Space", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))

    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))

    for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + J",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + K",  hl.dsp.focus({ direction = "down" }))

    hl.bind(mainMod .. " + SHIFT + H",  hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + J",    hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + SHIFT + K",  hl.dsp.window.move({ direction = "down" }))

    hl.bind(mainMod .. " + M", hl.dsp.exit())

    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
    hl.bind("SUPER + TAB", hl.dsp.window.float({ action = "toggle" }))
  '';
}
