{
  programs.helix = {
    enable = true;
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
