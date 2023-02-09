
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        packages = with pkgs; [ deno ];
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
            deno = module;
          };

        devShell = with pkgs; mkShell {
          inherit packages;
        };
    });
}
