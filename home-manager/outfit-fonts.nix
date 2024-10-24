{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "outfit-fonts";
  src = pkgs.fetchurl {
    url = "https://github.com/Outfitio/Outfit-Fonts/archive/refs/tags/1.1.zip";
    hash = "sha256-MblVZrQ4BZcKYqEq6z2Qo44GxNY+KI3Y6+9jmFzlpbc=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/Outfit
    tmp=$(mktemp -d)
    ${pkgs.unzip}/bin/unzip $src -d $tmp/
    mv $tmp/*/fonts/* $out/share/fonts/Outfit/
    rm -rf $tmp
  '';
}
