{
  description = "my nix/OS flake :D";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      sys-config = nixpkgs.lib.nixosSystem;
      home-config = home-manager.lib.homeManagerConfiguration;
    in
    {
      nixosConfigurations = {
        laptop = sys-config {
          inherit system;
          specialArgs = { inherit inputs system; };
          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        rogue = home-config {
          inherit pkgs;
          modules = [
            # ./hosts/laptop/home.nix
          ];
        };
      };
    };
}
