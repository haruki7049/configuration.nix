{ pname ? "emacs"
, pkgs
, version
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
  ];

  configurePhase = ''
    $src/autogen.sh
    ./configure --prefix=$out
  '';

  configureFlags = [ "--without-all" ];
}
