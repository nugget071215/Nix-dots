{ config, pkgs, inputs, ... }:

{
    imports = [
        ./configs/zsh.nix
        ./configs/spicetify.nix
        ./configs/fastfetch.nix
        inputs.mangowm.hmModules.mango
        ./configs/quickshell.nix
        ./configs/ghostty.nix
        ./configs/bt-headset-audio.nix
        inputs.caelestia-shell.homeManagerModules.default
    ];

    programs.caelestia = {
      enable = true;
      systemd.enable = false;
      cli.enable = true;
    };

    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
      inputs.helium.packages.${pkgs.system}.default
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

    home.username = "aves";
    home.homeDirectory = "/home/aves";

    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
}
