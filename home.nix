{ config, pkgs, inputs, ... }:

{
    imports = [
        ./configs/zsh.nix
        ./configs/starship.nix
        ./configs/spicetify.nix
        ./configs/niri.nix
        ./configs/hyprland.nix
        ./configs/fastfetch.nix
        ./configs/mango.nix
        ./configs/waybar.nix
        ./configs/noctalia.nix
        ./configs/quickshell.nix
    ];

    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
      pkgs.spicetify-cli
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GTK_CSD = "0";
    };

    # Hide duplicate flatpak Spotify entry from fuzzel
    xdg.dataFile."applications/com.spotify.Client.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    home.username = "aves";
    home.homeDirectory = "/home/aves";

    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
}
