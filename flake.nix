{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust.url = "path:./rust";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        default-pkgs = pkgs;
        mkNixShell = { pkgs ? default-pkgs, modules }:
          with pkgs;
          mkShell (builtins.foldl' (config: module:
            config // {
              packages = config.packages ++ module.module.packages;
            } // module.module.env) { packages = [ ]; } modules);
        modules = [ inputs.rust ];
      in { devShell = mkNixShell { inherit modules; }; });
}
