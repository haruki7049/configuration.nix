{
  ...
}:

let
  vimrc = builtins.readFile ./vimrc;
in

{
  programs.vim = {
    enable = true;
    extraConfig = vimrc;
  };
}
