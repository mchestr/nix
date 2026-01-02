{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opnix = {
      url = "github:mrjones2014/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, opnix, ... }: {
    nixosConfigurations.mikepc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        opnix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.mike = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
