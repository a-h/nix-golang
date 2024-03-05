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
        go_1_20_3 = pkgs.callPackage ./go_1_20_3.nix {};
        go_1_22_0 = pkgs.callPackage ./go_1_22_0.nix {};
        go_1_22_1 = pkgs.callPackage ./go_1_22_1.nix {};
      in
      {
        defaultPackage = go_1_22_1;
        packages = { 
          go_1_20_3 = go_1_20_3;
          go_1_22_0 = go_1_22_0;
          go_1_22_1 = go_1_22_1;
        };
        devShells = {
          default = pkgs.mkShell {
            packages = [ go_1_22_1 ];
          };
          go_1_20_3 = pkgs.mkShell {
            packages = [ go_1_20_3 ];
          };
          go_1_22_0 = pkgs.mkShell {
            packages = [ go_1_22_0 ];
          };
          go_1_22_1 = pkgs.mkShell {
            packages = [ go_1_22_0 ];
          };
        };
      }
    );
}
