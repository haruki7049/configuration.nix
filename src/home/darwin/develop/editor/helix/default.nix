{
  ...
}:

{
  programs.helix = {
    enable = true;
    defaultEditor = false;
    settings = {
      theme = "dracula_transparency";
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
      };
    };
    themes.dracula_transparency = {
      inherits = "dracula";
      "ui.background" = { };
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
        {
          name = "java";
          auto-format = true;
        }
      ];
    };
  };
}
