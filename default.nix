{ git
, latex
, lib
, nix-gitignore
, pandoc
, stdenv
, yq
}:

stdenv.mkDerivation {
  pname = "yurrriq-resume";
  version = builtins.readFile ./VERSION;
  src = nix-gitignore.gitignoreRecursiveSource [ ".git/" ] ./.;

  nativeBuildInputs = [
    git
    latex
    pandoc
    yq
  ];

  makeFlags = [
    "OUT_DIR=${placeholder "out"}"
  ];

  dontInstall = true;

  meta = with lib; {
    homepage = "http://cv.ericb.me";
    description = "Eric Bailey's résumé";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
    inherit (latex.meta) platforms;
  };
}
