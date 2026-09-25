{ pkgs }:

let
  fetchurl = pkgs.fetchurl;
in

fetchurl {
  url = "https://haruki7049.dev/wallpapers/fanta-hhkb.jpg";
  hash = "sha256-eOSL8Phl7ATQvWIKnLPc75yp0H7Sj0vazAxCsH4J/Dc=";
}
