{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust.url = "path:./rust";
  };

  outputs = { nixpkgs, flake-utils, rust, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        default-pkgs = pkgs;
        mkNixShell = { pkgs ? default-pkgs, modules }:
          with pkgs;
          mkShell (builtins.foldl' (config: flake:
            config // {
              packages = config.packages ++ flake.module.packages;
            } // (if builtins.hasAttr "env" flake.module then
              flake.module.env
            else
              { })) { packages = [ ]; } modules);
        modules = { inherit rust; };
      in {
        devShell = mkNixShell { modules = (builtins.attrValues modules); };
        modules = modules;
      });
}
