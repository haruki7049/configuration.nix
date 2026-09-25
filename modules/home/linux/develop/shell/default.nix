{
  imports = [
    ./nushell
    ./zsh
  ];

  programs = {
    bash.enable = true;
    fish.enable = true;
  };
}
