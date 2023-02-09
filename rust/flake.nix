{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      packages = with pkgs; [
        rust-bin.stable.latest.default
        rust-bin.stable.latest.rust-analyzer
      ];
    in
    {
      homeManagerModules =
        let
          module = { ... }: {
            home.packages = packages;
          };
        in
        {
          default = module;
          rust = module;
        };

      devShell = with pkgs; mkShell {
        inherit packages;
      };
    };
}
