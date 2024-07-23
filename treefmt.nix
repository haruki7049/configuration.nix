{ pkgs, ... }: {
  projectRootFile = "flake.nix";
  programs.nixpkgs-fmt.enable = true;
  programs.taplo.enable = true;
  programs.stylua.enable = true;
  settings.formatter = {
    "stylua".options = [
      "--indent-type"
      "Spaces"
    ];
  };
}
