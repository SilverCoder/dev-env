{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust = { url = "path:./rust"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { nixpkgs, flake-utils, rust, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          
          config.allowUnfree = true;
        };
      in {
        homeManagerModules = {
          rust = rust.homeManagerModules.${system}.default;
        };
      });
}
