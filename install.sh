#!/usr/bin/env sh
# Idempotent bootstrap for a new machine: install the terminal stack + chezmoi,
# then apply these dotfiles from Forgejo. Safe to re-run.
set -eu

REPO_SSH="git@forgejo:home/dotfiles.git"
REPO_HTTP="http://macmini.tailb31641.ts.net:3030/home/dotfiles.git"

os="$(uname -s)"
case "$os" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      echo "Install Homebrew first: https://brew.sh" >&2; exit 1
    fi
    brew install --cask ghostty font-jetbrains-mono-nerd-font || true
    brew install chezmoi starship eza zoxide fzf bat fd ripgrep \
                 zsh-autosuggestions zsh-syntax-highlighting
    ;;
  Linux)
    if command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --needed --noconfirm \
        ghostty ttf-jetbrains-mono-nerd chezmoi starship eza zoxide fzf bat fd ripgrep \
        zsh zsh-autosuggestions zsh-syntax-highlighting
    else
      echo "Non-Arch Linux: install ghostty, a JetBrainsMono Nerd Font, chezmoi, starship, eza," >&2
      echo "zoxide, fzf, bat, fd, ripgrep, zsh + zsh-autosuggestions + zsh-syntax-highlighting" >&2
      echo "with your package manager, then re-run." >&2
    fi
    ;;
  *)
    echo "Unsupported OS: $os" >&2; exit 1 ;;
esac

# Prefer SSH (deploy/user key); fall back to HTTP.
if git ls-remote "$REPO_SSH" >/dev/null 2>&1; then REPO="$REPO_SSH"; else REPO="$REPO_HTTP"; fi

if [ -d "${HOME}/.local/share/chezmoi/.git" ]; then
  chezmoi git -- remote set-url origin "$REPO" 2>/dev/null || true
  chezmoi update --force
else
  chezmoi init --apply "$REPO"
fi

echo
echo "Done. Open a new shell for the full setup."
[ "$os" = "Linux" ] && echo "Tip: 'chsh -s \"$(command -v zsh)\"' to make zsh your login shell."
exit 0
