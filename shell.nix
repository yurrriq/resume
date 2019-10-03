with import <nixpkgs> {
  overlays = [
    (self: super: {
      latex = (super.texlive.combine {
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
      });
    })
  ];
};

mkShell {
  buildInputs = [
    # ((import ./.todo/node.nix {}).shell)
    # nodePackages.node2nix
    latex
  ];
}
