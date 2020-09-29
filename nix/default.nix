import (import ./sources.nix).nixpkgs {
  overlays = [
    (
      self: super: {
        latex = (
          super.texlive.combine {
            inherit (super.texlive) scheme-small
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
          }
        );
      }
    )
  ];
}
