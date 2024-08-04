{ pname ? "emacs"
, pkgs
, version ? "29.4"
, stdenv ? pkgs.stdenv
}:

stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "emacs-29.4";
    hash = "sha256-FCP6ySkN9mAdp2T09n6foS2OciqZXc/54guRZ0B4Z2s=";
  };

  nativeBuildInputs = with pkgs; [
    gnumake
    pkg-config
  ];

  buildInputs = with pkgs; [
    autoconf
    texinfo
    ncurses
    gnutls
    libgccjit
    tree-sitter
    alsa-lib
    gtk3
    mailutils
    zlib
    imagemagick
    xorg.libXpm
    giflib
  ];

  configurePhase = ''
    $src/autogen.sh
    ./configure --prefix=$out
  '';

  configureFlags = [
    "--with-native-compilation"
    "--with-tree-sitter"
    "--with-imagemagick"
    "--with-ns"
    "--with-x-toolkit=gtk3"
    "--with-xwidgets"
    "--with-x"
  ];

  meta.platforms = [ "${stdenv.hostPlatform.system}" ];
}
