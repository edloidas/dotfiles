# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew prefix (run `brew --prefix` to check if different)
HOMEBREW_PREFIX="/opt/homebrew"

# Move zcompdump cache out of $HOME
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-${ZSH_VERSION}"

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Disable theme since we use Powerlevel10k
ZSH_THEME=""

# Skip compaudit permission check (single-user machine)
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Powerlevel10k theme
source ~/pgm/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# === Environment Variables ===

export EDITOR='cursor'

export BAT_THEME="Monokai Extended"

# Claude Code
export ENABLE_BACKGROUND_TASKS=1
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1

# Enonic
export XP_HOME="$HOME/.enonic/xp_home"
# Sandbox: export XP_HOME="$HOME/.enonic/sandboxes/XP_7_15"
# QA: export ENONIC_CLI_CLOUD_API_URL="https://console.enonic-qa.com/api"
# LOCAL: export ENONIC_CLI_CLOUD_API_URL="http://localhost:8080/webapp/com.enonic.cloud.api/_/service/com.enonic.cloud.api/graphql"

# Java
if /usr/libexec/java_home -v25 &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home -v25)
fi

# Go
export GOPATH="$HOME/go"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"

# bun
export BUN_INSTALL="$HOME/.bun"

# Google Cloud
export GOOGLE_CLOUD_PROJECT="playground-186616"

# === PATH Configuration ===

typeset -U PATH  # Ensure unique entries only

path=(
  "$PNPM_HOME"
  "$BUN_INSTALL/bin"
  "$JAVA_HOME/bin"
  "$GOPATH/bin"
  "/opt/homebrew/opt/gradle/bin"
  "/opt/homebrew/opt/snapcraft/bin"
  "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin"
  "$HOME/.cache/lm-studio/bin"
  $path
)

# === Git Fuzzy Search ===

# Fuzzy search git aliases and insert selected into shell buffer (gf is taken by oh-my-zsh)
gfz() {
  local selected
  selected=$(git config --list \
    | grep '^alias\.' \
    | sed 's/^alias\.//' \
    | column -t -s '=' \
    | fzf --nth=1 --preview 'git config alias.{1}')
  [[ -n "$selected" ]] && print -z "git $(echo "$selected" | awk '{print $1}')"
}

# === Aliases ===

alias rename="rename.sh"
alias grd="gradle build deploy -x check -Penv=dev --warning-mode none"
alias grp="gradle build deploy -x check -Penv=prod --warning-mode none"
alias grb="gradle build -x check -Penv=dev --warning-mode none"
alias lzd="lazydocker"
alias pnpx="pnpm dlx"
alias reload="exec $SHELL"

# === Shell Enhancements ===

# Syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zoxide
eval "$(zoxide init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# 1Password plugins (disabled — interferes with Claude Code OAuth flow)
# source "$HOME/.config/op/plugins.sh"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.cache/lm-studio/bin"
# End of LM Studio CLI section


