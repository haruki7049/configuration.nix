{
  programs.helix = {
    enable = false;
    defaultEditor = false;
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
