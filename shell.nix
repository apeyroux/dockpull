with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "dockpull-shell";
  buildInputs = [ cabal2nix ghc cabal-install ];
}
