# treefmt-nix configuration, shared by formatter.nix, devshell.nix and checks/treefmt.nix
{
  projectRootFile = "flake.nix";

  # Nix
  programs.nixfmt.enable = true;

  # Toml
  programs.taplo.enable = true;

  # ShellScripts
  programs.shellcheck.enable = true;
  programs.shfmt.enable = true;
}
