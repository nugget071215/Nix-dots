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
  services.xserver.desktopManager.xfce.enable = true;
  services.desktopManager.gnome.enable = true;
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
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "/home/aves/.nix/2pa-byps.sh";
      Restart = "on-failure";
      User = "root";
    };
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
  services.displayManager.gdm.enable = true;
  services.upower.enable = true;
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.hyprland.enable = true; 
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  programs.zsh.enable = true;
  programs.niri.enable = true;
  programs.mango.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
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
    libxkbcommon
    libxkbcommon.dev

    alsa-lib
    alsa-lib.dev

    systemd
    systemd.dev
    udev
    udev.dev

    pkg-config

    vulkan-loader
    vulkan-headers
    mesa
    libdrm

    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr

    clang
    gcc
    cmake
    unityhub
    os-prober 
# i like femboys
  ];
  system.stateVersion = "26.05"; 
}
