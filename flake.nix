{
  description = "My résumé in PDF format";

  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    pre-commit-hooks-nix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:cachix/git-hooks.nix";
    };
    treefmt-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      flake.overlays.default = _final: prev: {
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

        # FIXME: v2 works differently, I guess.
        treefmt = prev.treefmt1;
      };

      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, self', system, ... }: {
        _module.args.pkgs = import nixpkgs {
          overlays = [
            self.overlays.default
          ];
          inherit system;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.pre-commit.devShell
            self'.packages.default
          ];

          nativeBuildInputs = with pkgs; [
            semver-tool
          ];
        };

        packages.default = pkgs.callPackage ./. { };

        pre-commit.settings.hooks = {
          convco.enable = true;
          editorconfig-checker.enable = true;
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ./flake.nix;
          programs = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
            prettier.excludes = [
              ".todo/*"
            ];
          };
        };
      };
    };
}
