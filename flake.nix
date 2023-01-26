{
  description = "My résumé in PDF format";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
  };

  outputs = { self, flake-utils, nixpkgs }:
    {
      overlay = final: prev: {
        latex = prev.texlive.combine {
          inherit (prev.texlive) scheme-small
            babel
            bera
            classicthesis
            currvita
            datetime
            endnotes
            fmtcount
            fpl
            hyperref
            mathpazo
            mparhack
            palatino
            titlesec
            tocloft
            unicode-math
            ;
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [
            self.overlay
          ];
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = (with pkgs; [
            semver-tool
          ]) ++ self.packages.${system}.default.nativeBuildInputs;
        };

        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "yurrriq-resume";
          version = builtins.readFile ./VERSION;
          src = pkgs.nix-gitignore.gitignoreRecursiveSource [ ".git/" ] ./.;

          nativeBuildInputs = with pkgs; [
            git
            latex
            pandoc
            yq
          ];

          makeFlags = [
            "OUT_DIR=${placeholder "out"}"
          ];

          dontInstall = true;
        };
      });
}
