{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs {
          system = system;
        };
        go = pkgs.callPackage ./go.nix {};
      in
      {
        defaultPackage = go;
        packages = go;
        devShells.default = pkgs.mkShell {
          packages = [ go ];
        };
      }
    );
}
