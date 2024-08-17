{
  programs.helix = {
    enable = false;
    defaultEditor = false;
    settings = {
      theme = "dracula";
      editor.lsp = {
        enable = true;
        display-messages = true;
        auto-signature-help = true;
        display-inlay-hints = true;
        display-signature-help-docs = true;
        snippets = true;
        goto-reference-include-declaration = true;
      };

      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
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
        {
          name = "perl";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
        }
      ];
    };
  };
}
