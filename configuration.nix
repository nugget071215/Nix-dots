{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./generated.nix
    ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
   
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;
  systemd.services.fix-audio = {
    description = "Fixes audio on my laptop";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    path = with pkgs; [ kmod i2c-tools ];

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
  users.users."aves" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "aves";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    
    ];
  };
  programs.firefox.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;
  programs.dwl.enable = true;

  services.upower.enable = true;
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  programs.mango.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    config.common.default = "*";
    config.mango.default = "gtk";
    # KDE Plasma session: use the KDE portal backend (talks to KWin), so
    # PipeWire screen capture in OBS works.
    config.kde.default = "kde";
    config.kde."org.freedesktop.impl.portal.ScreenCast" = "kde";
    config.kde."org.freedesktop.impl.portal.Screenshot" = "kde";
    # Hyprland session: use the Hyprland portal backend.
    config.hyprland.default = "hyprland";
    # Generic fallback for any other session.
    config.common.default = "gtk";
  };

  # Without an explicit chooser, xdg-desktop-portal-wlr falls back to its
  # default slurp/wmenu/wofi/... chain, which it cannot find because the
  # systemd unit PATH lacks /run/current-system/sw/bin. Point it at slurp
  # (absolute store path) so the OBS screen-picker actually shows up.
  xdg.portal.wlr = {
    enable = true;
    settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
    };
  };

  # Hyprland does not activate graphical-session.target on its own, but
  # xdg-desktop-portal refuses to start without it (Requisite=). Pull it in
  # from a persistent user service so the portal can start at login.
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

  # The portal frontend can come up before the session environment
  # (WAYLAND_DISPLAY, XDG_CURRENT_DESKTOP) is imported into the user
  # manager, so it binds the ScreenCast backend to the wrong portal and
  # OBS sees "[pipewire] No capture sources available". Once the session
  # env is present, restart the frontend so it re-resolves the config and
  # activates the wlr backend.
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

  systemd.user.services.xdg-desktop-portal.wantedBy = [ "default.target" ];

  environment.systemPackages = with pkgs; [
    vim 
    wget
    hyprland
    kitty
    xdg-desktop-portal-wlr
    wofi
    swayosd
    mako
    neovim
    swaybg
    waypaper
    bat
    steam
    albert
    modrinth-app
    zsh
    fastfetch
    starship
    (pkgs.runCommand "obs-wayland" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin $out/share/applications $out/share/icons
      makeWrapper ${pkgs.obs-studio}/bin/obs $out/bin/obs \
        --set QT_QPA_PLATFORM wayland

      install -Dm444 ${pkgs.obs-studio}/share/applications/com.obsproject.Studio.desktop \
        $out/share/applications/com.obsproject.Studio.desktop
      cp -r ${pkgs.obs-studio}/share/icons/hicolor $out/share/icons/
    '')
    r2modman
    prismlauncher
    vesktop
    unzip
    zip
    localsend
    i2c-tools
    swayosd
    yazi
    ratty
    opencode
    bat
    git
    wget
    hyprshot
    hyprpicker
    btop
    libnotify
    swaylock
    libinput
    cava
    cmatrix 
    cowsay
    xwayland-satellite
    mpvpaper
    blender
    rustup
    gcc
    meson 
    ninja 
    clang 
    pkg-config
    wayland 
    wayland-protocols
    wayland-scanner 
    libxkbcommon
    mesa 
    libdrm 
    vulkan-loader
    libinput 
    systemd.dev 
    wlroots 
    pixman 
    cairo 
    pango
    waybar
    krita
    dust 
    cbonsai 
    toilet 
    figlet 
    lolcat 
    sl 
    hollywood
    genact
    onefetch
    terminaltexteffects
    pokemon-colorscripts
    love
    grim 
    slurp 
    wine
    upower
    fuzzel
    rofi
    pavucontrol
    brightnessctl
    playerctl
    zed-editor
    github-desktop
    vscode
    swayidle
    swaylock-effects
    rustc 
    cargo 
    dbus 
    pkg-config
    chromium
    wayland 
    rustfmt
    clippy
    cmake 
    gcc 
    alsa-lib 
    systemd 
    wayland
    wayland-protocols
    wayland-scanner
    clang
    gcc
    cmake
    unityhub
    os-prober 
    nitch
    ghostty
    discord
    gnome-terminal
    openjdk
    sptlrx
    jq
    asciiquarium
    yt-dlp 
    ffmpeg 
    librewolf
    kdePackages.dolphin
    audacity
    kdePackages.kdenlive
    (python3.withPackages (ps: with ps; [
      pygame
    ]))
    hyprland
    ferium
    foot 
    wlroots_0_19
    wl-clipboard
    gnumake
    shotcut
# i like femboys
  ];
  system.stateVersion = "26.05"; 
}
