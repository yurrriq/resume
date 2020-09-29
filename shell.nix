{ pkgs ? import ./nix }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    latex
    pandoc
  ];
}
