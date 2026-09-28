{
  ...
}:

{
  programs.claude-code = {
    enable = true;

    # Global instructions for every project (~/.claude/CLAUDE.md). Claude Code reads them
    # together with each repository's AGENTS.md. settings.json is left unmanaged.
    context = ./CLAUDE.md;
  };
}
