# dotfiles

Personal dotfiles for macOS.

## Contents

- `.gitconfig` — git config with aliases, delta, credential helpers; includes `~/.gitconfig.local`
- `git/*.gitconfig` — per-account identity and signing, one of them linked as `~/.gitconfig.local`
- `.gitignore_global` — global gitignore (wired via `core.excludesfile`)
- `.zshrc` — zsh with Oh My Zsh, Powerlevel10k, aliases, PATH
- `config/ghostty/config` — Ghostty terminal config
- `config/tmux/tmux.conf` — tmux config with vi keys, Catppuccin theme, TPM plugins
- `bin/with-secrets` — run a command with 1Password references in an env file resolved
- `bin/op-sa` — run the `op` CLI as a machine's service account

## Git identity

`.gitconfig` ends with `[include] path = ~/.gitconfig.local`, so identity,
signing, and editor live in that file and override anything above them. The
candidates are tracked in `git/`:

- `git/edloidas.gitconfig` — main account, macOS, signs with 1Password
- `git/adiutriel.gitconfig` — secondary account, Linux, unsigned, vim

`install.sh` symlinks one of them to `~/.gitconfig.local`, `edloidas` by
default:

```sh
./install.sh            # edloidas
./install.sh adiutriel
```

`user.useConfigOnly` is set in `.gitconfig`, so without the include git refuses
to commit instead of silently authoring as `<user>@<hostname>`. Nothing signs
or authors as the wrong account by accident.

Anything tied to one machine rather than one account, such as repo-specific
credential helpers or URL rewrites, goes in an untracked `~/.gitconfig.machine`,
which `.gitconfig` also includes.

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

Creates symlinks in `$HOME`, links `bin/` into `~/.local/bin`, and links the chosen git identity (see above) as `~/.gitconfig.local`. Existing symlinks are replaced; existing files are backed up as `<file>.bak`.

## License

[MIT](LICENSE) © [Mikita Taukachou](https://edloidas.io)
