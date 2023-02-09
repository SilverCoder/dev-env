{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    deno = { url = "path:./deno"; inputs.nixpkgs.follows = "nixpkgs"; };
    rust = { url = "path:./rust"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { nixpkgs, flake-utils, deno, rust, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };
      in {
        homeManagerModules = {
          deno = deno.homeManagerModules.${system}.default;
          rust = rust.homeManagerModules.${system}.default;
        };
      });
}
