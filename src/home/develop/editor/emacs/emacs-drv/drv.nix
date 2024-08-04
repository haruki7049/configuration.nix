{ pname ? "emacs"
, pkgs
, version
, specialArgs
, stdenv ? pkgs.stdenv
}:

let
  emacs-src = specialArgs.emacs-src;
in
stdenv.mkDerivation {
  inherit pname version;

  src = emacs-src;

  nativeBuildInputs = with pkgs; [
    gnumake
    pkg-config
  ];

  buildInputs = with pkgs; [
    autoconf
    texinfo
    ncurses
    gnutls
  ];

  configurePhase = ''
    $src/autogen.sh
    ./configure --prefix=$out
  '';

  configureFlags = [ "--without-all" ];

  meta.platforms = [ "${stdenv.hostPlatform.system}" ];
}
