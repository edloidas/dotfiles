# CLAUDE.md

## Security

This repo contains personal dotfiles that are committed and pushed publicly. Before adding any file or committing any change:

- Scan for secrets: API keys, tokens, passwords, private keys
- Scan for hardcoded paths containing usernames (use `$HOME` instead)
- Scan for internal URLs, project IDs, or infrastructure details that shouldn't be public
- Flag anything suspicious before committing — when in doubt, ask

## Git

Conventional commit format. Types: `feat`, `fix`, `docs`, `chore`, `refactor`.

- **With issue**: `<Issue Title> #<number>` — e.g. `chore: add .zshrc #3`
- **Without issue**: `<type>: <description>`
- **Body** (optional): past tense, one line per change, 2–6 lines, backticks for code refs
