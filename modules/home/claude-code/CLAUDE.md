# Global Agent Guidelines

These rules apply to every repository. A repository's own `AGENTS.md` / `CLAUDE.md` adds project-specific rules on top
of them; when both cover the same topic, follow the repository's rule.

## Language

- Always respond to the user in **Japanese**, regardless of the language of the instructions or of the user's message.
- Write repository documentation, agent skills, code comments, commit messages, pull request descriptions and issues in
  English.

## Git & GitHub

- **NEVER MERGE PULL REQUESTS**: Do not run `gh pr merge` (including enabling auto-merge with `gh pr merge --auto`) or
  `git merge` into the default branch. Merging rests strictly with the human maintainer.
- **No autonomous changes to the default branch**: Work on topic branches. Commit or push to the default branch only
  when the user explicitly instructs it for that specific change.
- **Never propose commits or pushes unprompted**: Do not ask "Would you like me to commit?" and do not append proposed
  commit messages. When instructed, or when creating or updating pull requests on topic branches, run `git commit` and
  `git push` directly.
- **Never rewrite pushed history**: No amend or rebase followed by a force-push on branches that exist on the remote.
- **Conventional Commits**: `feat:`, `fix:`, `refactor:`, `docs:`, `build:`, `style:`, `test:`, optionally with a scope
  (e.g. `feat(hyprland):`). English, imperative mood, under 72 characters, no trailing period. Do not put issue numbers
  in the summary; link issues from the pull request description with closing keywords (e.g. `Closes #24`).
- Stage only the files changed for the task (`git add <path>`), never `git add -A`.
- Never set milestones on pull requests or issues unless asked.

## Working Principles

- **Evidence First**: Base all answers and actions on actual file contents and command output. Never speculate or
  assume.
- **Non-Destructive**: Get explicit approval before irreversible or outward-facing actions: deleting or overwriting
  user-authored files, hard resets, force-pushes, changing files outside the repository, and changing repository or
  GitHub settings.
- **Targeted Edits**: Make minimal changes strictly necessary for the request. Do not modify unrelated files, and do
  not modify or commit files the user placed for reference (e.g. untracked files in the repository root).

## Status Assessment

When asked to check status or assess the workspace:

1. **Local Git State**: `git status -s -b`, `git log -n 5 --oneline`, and how far the branch is behind the remote
   default branch.
1. **GitHub PRs (always)**: `gh pr list` and `gh pr status`, even when the local state is clean.
1. **GitHub Issues (always)**: `gh issue list`.
1. **Environment Health**: Run the verification commands described in the repository's `AGENTS.md`.
1. **Synthesis**: Report local state, remote GitHub state and environment health. Always include the open PR and issue
   lists (number, title and state), or state explicitly that there are none.
