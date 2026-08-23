# dotfiles

Personal dotfiles for macOS.

## Contents

- `.gitconfig` — git config with aliases, delta, SSH signing
- `.gitignore_global` — global gitignore (wired via `core.excludesfile`)
- `.zshrc` — zsh with Oh My Zsh, Powerlevel10k, aliases, PATH
- `config/ghostty/config` — Ghostty terminal config
- `config/tmux/tmux.conf` — tmux config with vi keys, Catppuccin theme, TPM plugins
- `bin/with-secrets` — run a command with 1Password references in an env file resolved
- `bin/op-sa` — run the `op` CLI as a machine's service account

## Secrets

A project's env file can hold 1Password references instead of values:

```
SOME_TOKEN=op://<vault>/<item>/<field>
```

`with-secrets <command>` resolves them into that one process, so the file itself
holds nothing secret and reading it discloses nothing.

Run the command without the wrapper and the app receives the literal `op://…`
string, which usually surfaces as a confusing 401 rather than a missing-config
error. Bun and most dotenv loaders give real environment variables precedence
over the file, which is why the wrapper wins.

`with-secrets` picks its authentication per machine:

- A laptop with the 1Password desktop app authenticates through it, so the
  wrapper calls `op` directly — biometric, nothing long-lived on disk.
- A headless machine cannot authenticate interactively, so it reads a service
  account token from `$HOME/.config/op-sa/token` (mode 600) and goes through
  `op-sa`. Scope such a token read-only to the one vault it needs.

Never give a machine a service account token when it can already authenticate as
you. The token is a bearer credential; biometric unlock is not.

## Install

```sh
./install.sh
```

Creates symlinks in `$HOME`, and links `bin/` into `~/.local/bin`. Existing symlinks are replaced; existing files are backed up as `<file>.bak`.

## License

[MIT](LICENSE) © [Mikita Taukachou](https://edloidas.io)
