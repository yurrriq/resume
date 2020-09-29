{ pkgs ? import ./nix
, src ? pkgs.nix-gitignore.gitignoreRecursiveSource [ ".git/" ] ./.
}:
pkgs.stdenv.mkDerivation rec {
  pname = "yurrriq-resume";
  version = builtins.readFile ./VERSION;
  inherit src;

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
}
