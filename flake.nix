{
  description = "my nix/OS flake :D";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      rust-overlay,
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
            ./system/laptop/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        rogue = home-config {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs system rust-overlay; };
          modules = [ ./home/rogue.nix ];
        };
      };
    };
}
