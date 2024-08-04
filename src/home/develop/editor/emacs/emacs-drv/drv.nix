{ pname ? "emacs"
, pkgs
, version
, emacs-src
, stdenv ? pkgs.stdenv
}:

stdenv.mkDerivation {
  inherit pname version;

  src = emacs-src;

  nativeBuildInputs = with pkgs; [
    gnumake
  ];

  buildInputs = with pkgs; [
    autoconf
    texinfo
    ncurses
  ];

  preConfigure = ''
  '';

  configureFlags = [ "--without-all" ];
}
