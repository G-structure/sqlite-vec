{
  description = "Development environment with Emscripten";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            emscripten
            cmake
            python3
            nodejs
            sqlite
            sqlite.dev
            gnumake
            unzip
            curl
            tcl
          ];

          shellHook = ''
            export EMSCRIPTEN=${pkgs.emscripten}/share/emscripten
            export SQLITE_INCLUDE_PATH=${pkgs.sqlite.dev}/include
            export CFLAGS="-I${pkgs.sqlite.dev}/include"

            # Ensure vendor directory exists and contains sqlite3.h
            mkdir -p vendor
            if [ ! -f vendor/sqlite3.h ]; then
              cp ${pkgs.sqlite.dev}/include/sqlite3.h vendor/
            fi
          '';
        };
      });
}
