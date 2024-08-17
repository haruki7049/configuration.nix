{
  programs.helix = {
    enable = false;
    defaultEditor = false;
    settings = {
      theme = "dracula";
    };
    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "zig";
          auto-format = true;
        }
      ];
    };
  };
}
