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
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    config.common.default = "*";
    config.mango.default = "gtk";
  };

  systemd.user.services.xdg-desktop-portal-wlr = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      Environment = [
        "WAYLAND_DISPLAY=wayland-0"
        "PATH=/run/current-system/sw/bin"
      ];
    };
  };

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
    obs-studio
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
    niri
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
    davinci-resolve
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
    kdePackages.kdenlive
    python3
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
# i like femboys
  ];
  system.stateVersion = "26.05"; 
}
