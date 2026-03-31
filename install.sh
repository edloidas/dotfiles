#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTFILES=(
  .gitconfig
  .zshrc
)

link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$HOME/$1"

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
  link "$dotfile"
done

echo "Done."
