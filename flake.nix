{
  description = "Aves' NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    areofyl-fetch.url = "github:areofyl/fetch";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swayfx.url = "github:WillPower3309/swayfx";
    quickshell = {
       url = "github:outfoxxed/quickshell";
       inputs.nixpkgs.follows = "nixpkgs";
    };
    helium.url = "github:schembriaiden/helium-browser-nix-flake";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.minty = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        
        home-manager.nixosModules.home-manager

        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.aves = import ./home.nix;
        }
      ];
    };
  };
}
