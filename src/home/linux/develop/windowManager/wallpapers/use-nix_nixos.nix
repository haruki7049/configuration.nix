{ pkgs }:

let
  fetchurl = pkgs.fetchurl;
in
fetchurl {
  url = "https://haruki7049.dev/use-nix_nixos.jpg";
  hash = "sha256-syAWh9XiY2qhM0ACssnj+riBVkvMkTNJysnjcTHAw80=";
}
