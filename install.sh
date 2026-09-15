#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Which git/<name>.gitconfig becomes ~/.gitconfig.local. Defaults to edloidas.
GIT_IDENTITY="${1:-edloidas}"
GIT_IDENTITY_FILE="git/$GIT_IDENTITY.gitconfig"

if [[ ! -f "$DOTFILES_DIR/$GIT_IDENTITY_FILE" ]]; then
  echo "Unknown git identity '$GIT_IDENTITY'. Available:" >&2
  for f in "$DOTFILES_DIR"/git/*.gitconfig; do
    echo "  $(basename "${f%.gitconfig}")" >&2
  done
  exit 1
fi

DOTFILES=(
  .gitconfig
  .gitignore_global
  .zshrc
)

CONFIGS=(
  config/ghostty/config
  config/tmux/tmux.conf
)

# Linked into ~/.local/bin, which is already on PATH from .zshrc.
BINS=(
  bin/op-sa
  bin/with-secrets
)

link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    echo "Replacing symlink: $dst"
    rm "$dst"
  elif [[ -f "$dst" ]]; then
    local bak="${dst}.bak"
    echo "Backing up file: $dst -> $bak"
    mv "$dst" "$bak"
  fi

  ln -sf "$src" "$dst"
  echo "Linked: $dst -> $src"
}

for dotfile in "${DOTFILES[@]}"; do
  link "$dotfile" "$dotfile"
done

for cfg in "${CONFIGS[@]}"; do
  link "$cfg" ".$cfg"
done

for b in "${BINS[@]}"; do
  chmod +x "$DOTFILES_DIR/$b"
  link "$b" ".local/$b"
done

link "$GIT_IDENTITY_FILE" ".gitconfig.local"

echo "Done."
