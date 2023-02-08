{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      module = {
        packages = with pkgs; [ deno rustup ];

        env = {
          HELLO_WORLD = "test";
        };
      };
    };
}
