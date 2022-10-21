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
        go_1_17_3 = pkgs.callPackage ./go_1_17_3.nix {};
        go_1_18_5 = pkgs.callPackage ./go_1_18_5.nix {};
        go_1_18_6 = pkgs.callPackage ./go_1_18_6.nix {};
        go_1_18_7 = pkgs.callPackage ./go_1_18_7.nix {};
        go_1_19 = pkgs.callPackage ./go_1_19.nix {};
        go_1_19_1 = pkgs.callPackage ./go_1_19_1.nix {};
        go_1_19_2 = pkgs.callPackage ./go_1_19_2.nix {};
      in
      {
        defaultPackage = go_1_19_2;
        packages = [ 
          go_1_17_3
          go_1_18_5
          go_1_18_6
          go_1_18_7
          go_1_19
          go_1_19_1
          go_1_19_2
        ];
        devShells = {
          default = pkgs.mkShell {
            packages = [ go_1_19_2 ];
          };
          go_1_17_3 = pkgs.mkShell {
            packages = [ go_1_17_3 ];
          };
          go_1_18_5 = pkgs.mkShell {
            packages = [ go_1_18_5 ];
          };
          go_1_18_6 = pkgs.mkShell {
            packages = [ go_1_18_6 ];
          };
          go_1_18_7 = pkgs.mkShell {
            packages = [ go_1_18_7 ];
          };
          go_1_19 = pkgs.mkShell {
            packages = [ go_1_19 ];
          };
          go_1_19_1 = pkgs.mkShell {
            packages = [ go_1_19_1 ];
          };
          go_1_19_2 = pkgs.mkShell {
            packages = [ go_1_19_2 ];
          };
        };
      }
    );
}
