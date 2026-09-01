{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ─────────────────────────────────────────────────────────────
  # Nix
  # ─────────────────────────────────────────────────────────────

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  # ─────────────────────────────────────────────────────────────
  # Boot
  # ─────────────────────────────────────────────────────────────

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ─────────────────────────────────────────────────────────────
  # Networking / Localization
  # ─────────────────────────────────────────────────────────────

  networking.hostName = "minty";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ─────────────────────────────────────────────────────────────
  # X11 / KDE Plasma
  # ─────────────────────────────────────────────────────────────

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.printing.enable = true;

  # ─────────────────────────────────────────────────────────────
  # Audio
  # ─────────────────────────────────────────────────────────────

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Custom laptop audio fix
  systemd.services.fix-audio = {
    description = "Fixes audio on my laptop";

    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];

    path = with pkgs; [
      kmod
      i2c-tools
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      modprobe i2c-dev

      i2c_bus=0
      echo "Using I2C bus: $i2c_bus"

      count=0

      for value in 0x3d 0x38; do
          val=$((count % 2))

          i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x7f 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x01 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x0e 0xc4
          i2cset -f -y "$i2c_bus" "$value" 0x0f 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x5c 0xd9
          i2cset -f -y "$i2c_bus" "$value" 0x60 0x10

          if [ $val -eq 0 ]; then
              i2cset -f -y "$i2c_bus" "$value" 0x0a 0x1e
          else
              i2cset -f -y "$i2c_bus" "$value" 0x0a 0x2e
          fi

          i2cset -f -y "$i2c_bus" "$value" 0x0d 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x16 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x17 0xc8
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x04

          i2cset -f -y "$i2c_bus" "$value" 0x30 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x31 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x32 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x33 0x01

          i2cset -f -y "$i2c_bus" "$value" 0x00 0x08

          i2cset -f -y "$i2c_bus" "$value" 0x18 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x19 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x1a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x1b 0x00

          i2cset -f -y "$i2c_bus" "$value" 0x28 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x29 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x2a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x2b 0x00

          i2cset -f -y "$i2c_bus" "$value" 0x00 0x0a

          i2cset -f -y "$i2c_bus" "$value" 0x48 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x49 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x4a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x4b 0x00

          i2cset -f -y "$i2c_bus" "$value" 0x58 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x59 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x5a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x5b 0x00

          i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x02 0x00

          count=$((count + 1))
      done
    '';
  };

  # ─────────────────────────────────────────────────────────────
  # Desktop / Window Managers
  # ─────────────────────────────────────────────────────────────

  programs.hyprland.enable = true;
  programs.dwl.enable = true;
  programs.mango.enable = true;

  # ─────────────────────────────────────────────────────────────
  # Bluetooth / Power
  # ─────────────────────────────────────────────────────────────

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  services.upower.enable = true;

  # ─────────────────────────────────────────────────────────────
  # Flatpak
  # ─────────────────────────────────────────────────────────────

  services.flatpak.enable = true;

  # ─────────────────────────────────────────────────────────────
  # User
  # ─────────────────────────────────────────────────────────────

  users.users.aves = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "aves";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = [ ];
  };

  # ─────────────────────────────────────────────────────────────
  # Programs
  # ─────────────────────────────────────────────────────────────

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # ─────────────────────────────────────────────────────────────
  # Graphics
  # ─────────────────────────────────────────────────────────────

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ─────────────────────────────────────────────────────────────
  # XDG Desktop Portals
  # ─────────────────────────────────────────────────────────────

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    config.common.default = "gtk";

    config.kde.default = "kde";
    config.kde."org.freedesktop.impl.portal.ScreenCast" = "kde";
    config.kde."org.freedesktop.impl.portal.Screenshot" = "kde";

    config.hyprland.default = "hyprland";
    config.mango.default = "gtk";
  };

  # Hyprland / wlr screen-casting picker
  xdg.portal.wlr = {
    enable = true;

    settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
    };
  };

  # Hyprland does not activate graphical-session.target itself.
  systemd.user.services.portal-bootstrap = {
    description = "Activate graphical-session.target for xdg-desktop-portal";

    wantedBy = [ "default.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    before = [ "xdg-desktop-portal.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };

  # Restart the portal after the Wayland session environment is available.
  systemd.user.services.fix-screencast = {
    description = "Restart the screen capture portal after session env import";

    wantedBy = [ "default.target" ];

    after = [
      "graphical-session.target"
      "xdg-desktop-portal.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      i=0

      while [ $i -lt 30 ] && ! ${pkgs.systemd}/bin/systemctl --user show-environment | ${pkgs.gnugrep}/bin/grep -q '^WAYLAND_DISPLAY='; do
        i=$((i+1))
        sleep 1
      done

      ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal.service
    '';
  };

  systemd.user.services.xdg-desktop-portal.wantedBy = [
    "default.target"
  ];

  # ─────────────────────────────────────────────────────────────
  # System Packages
  # ─────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [

    # ── Core CLI ────────────────────────────────────────────────
    vim
    neovim
    git
    wget
    curl
    unzip
    zip
    jq
    yazi
    bat
    dust
    btop
    fastfetch
    nitch
    onefetch

    # ── Shell / Terminal ────────────────────────────────────────
    zsh
    starship
    ghostty
    kitty
    foot
    gnome-terminal

    # ── Desktop / Launchers ─────────────────────────────────────
    albert
    fuzzel
    rofi
    wofi
    waybar
    waypaper

    # ── KDE ─────────────────────────────────────────────────────
    kdePackages.dolphin
    kdePackages.kdenlive

    # ── Browsers ────────────────────────────────────────────────
    chromium
    librewolf

    # ── Gaming ─────────────────────────────────────────────────
    steam
    modrinth-app
    prismlauncher
    r2modman
    ferium
    wine

    # ── Communication ──────────────────────────────────────────
    discord
    vesktop

    # ── Media / Audio ──────────────────────────────────────────
    mpvpaper
    pavucontrol
    playerctl
    cava
    sptlrx
    audacity
    shotcut
    ffmpeg
    yt-dlp
    libnotify

    # ── OBS / Screen Capture ───────────────────────────────────
    xdg-desktop-portal-wlr
    grim
    slurp
    hyprshot
    hyprpicker
    swayosd

    # Custom Wayland OBS wrapper
    (pkgs.runCommand "obs-wayland" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin $out/share/applications $out/share/icons

      makeWrapper ${pkgs.obs-studio}/bin/obs $out/bin/obs \
        --set QT_QPA_PLATFORM wayland

      install -Dm444 \
        ${pkgs.obs-studio}/share/applications/com.obsproject.Studio.desktop \
        $out/share/applications/com.obsproject.Studio.desktop

      cp -r ${pkgs.obs-studio}/share/icons/hicolor \
        $out/share/icons/
    '')

    # ── Wayland / Window Manager ────────────────────────────────
    hyprland
    swaybg
    swayidle
    swaylock
    swaylock-effects
    mako
    xwayland-satellite
    wl-clipboard
    wayland
    wayland-protocols
    wayland-scanner
    wlroots
    wlroots_0_19

    # ── Graphics / Low-level Wayland ────────────────────────────
    mesa
    libdrm
    vulkan-loader
    libxkbcommon
    pixman
    cairo
    pango
    libinput
    upower

    # ── Development ─────────────────────────────────────────────
    gcc
    clang
    rustup
    rustc
    cargo
    rustfmt
    clippy
    cmake
    meson
    ninja
    gnumake
    pkg-config
    gnumake

    # ── Development Libraries / System Interfaces ──────────────
    alsa-lib
    dbus
    systemd
    systemd.dev
    i2c-tools

    # ── Programming / Game Development ─────────────────────────
    love
    blender
    krita
    unityhub

    (python3.withPackages (ps: with ps; [
      pygame
    ]))

    # ── Editors / IDEs ──────────────────────────────────────────
    zed-editor
    vscode
    github-desktop

    # ── Networking / Utilities ──────────────────────────────────
    localsend
    brightnessctl
    libinput
    os-prober
    upower

    # ── Fun Stuff™ ──────────────────────────────────────────────
    cmatrix
    cowsay
    asciiquarium
    cbonsai
    toilet
    figlet
    lolcat
    sl
    hollywood
    genact
    ratty
    terminaltexteffects
    pokemon-colorscripts

    # ── Java / Minecraft ────────────────────────────────────────
    jdk

    # ── Other ───────────────────────────────────────────────────
    opencode
    zed-editor
  ];
}
