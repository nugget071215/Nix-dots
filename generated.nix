{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    nix
    spotify
  ];
}
