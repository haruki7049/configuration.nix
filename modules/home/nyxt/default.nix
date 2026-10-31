{ ... }:

{
  programs.nyxt.enable = true;
  programs.nyxt.config = builtins.readFile ./config.lisp;
}
