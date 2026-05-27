{
  description = "NixOS config"; 

  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: { 
    nixosConfigurations.avalon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./packages.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.tim = import ./home.nix;
	  home-manager.extraSpecialArgs = { inherit inputs; };
	}
      ];
    };
  };
}
