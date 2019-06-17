{ pkgs ? (import <nixpkgs> {}).pkgs }:

pkgs.mkShell {
  buildInputs = with pkgs; [

    # Haskell Dependencies:
    (pkgs.haskellPackages.ghcWithPackages (p: with p; [
      cabal-install
      hasktags
      hlint
      hoogle
      xmonad
      xmonad-contrib
    ]))
  ];
}
