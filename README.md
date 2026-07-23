# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Single source of truth for the
terminal experience across machines, backed up to **Forgejo** (`home/dotfiles`) and GitHub.

## What's in here

| Target | What |
|--------|------|
| `~/.config/ghostty/config` | [Ghostty](https://ghostty.org) terminal — Catppuccin Mocha, JetBrainsMono Nerd Font Mono, subtle opacity+blur, block cursor, tab/split keybinds |
| `~/.config/starship.toml` | [Starship](https://starship.rs) prompt — Catppuccin Mocha powerline (os · user · dir · git · language versions · docker · time) |
| `~/.zshrc` | zsh: starship + zoxide + fzf init, `eza`/`bat` aliases, `zsh-autosuggestions` + `zsh-syntax-highlighting` (brew/pacman path-portable) |
| `~/.config/fish/config.fish` | fish: portable brew shellenv + starship/zoxide/fzf + same aliases |
| `~/.config/nvim`, `~/.config/alacritty` | editor / legacy terminal (macOS only — see below) |
| `~/.gitconfig`, `~/.ssh/config` | git identity, ssh host aliases (macOS only — see below) |

### The CLI stack (installed per-OS, not tracked here)
`starship` · `eza` (→ `ls`) · `bat` (→ `cat`) · `zoxide` (→ `z`) · `fzf` · `fd` · `ripgrep` ·
`zsh-autosuggestions` · `zsh-syntax-highlighting`

## Per-machine behavior

- **`.chezmoiignore`** excludes `ssh/config`, `gitconfig`, `nvim`, `alacritty`, and fish universal vars
  **on Linux**, so applying on a Linux box (e.g. the rig) only touches the terminal stack and never
  clobbers that host's own ssh/git/editor config. macOS manages everything.
- **Machine-specific settings** go in `~/.zshrc.local` (sourced by `~/.zshrc`, **not** tracked) — e.g.
  `PATH` additions, host-only env vars.

## Bootstrap a new machine

```sh
# 1. install the terminal stack + chezmoi + apply — idempotent, safe to re-run
sh install.sh
#    (or, if chezmoi + the tools are already present:)
chezmoi init --apply git@forgejo:home/dotfiles.git

# 2. Linux only: make zsh your login shell
chsh -s "$(command -v zsh)"

# 3. open a new Ghostty window — starship, autosuggestions, and highlighting are live.
```

Prerequisites the bootstrap installs: Ghostty, JetBrainsMono Nerd Font, and the CLI stack
(Homebrew casks/formulae on macOS; `pacman` on Arch/CachyOS).

## Daily use

```sh
chezmoi edit ~/.zshrc          # edit the source, not the live file
chezmoi diff                   # preview what apply would change
chezmoi apply ~/.config/ghostty ~/.config/starship.toml ~/.zshrc   # apply specific targets
chezmoi update                 # git pull from Forgejo + apply
chezmoi cd                     # drop into the source repo to commit/push
```

> **Caution (macOS):** `~/.ssh/config` in this repo is intentionally a *sanitized example*
> (placeholder tailnet/user), while the live Mac config has real values — so avoid a blanket
> `chezmoi apply` on the Mac (it would overwrite the live ssh config with the template). Apply
> specific targets, or run `chezmoi diff` first. On Linux this can't happen — `.chezmoiignore`
> excludes `ssh/config` there.

## Remotes

- `forgejo` — `git@forgejo:home/dotfiles.git` (primary backup, self-hosted)
- `origin` — `github.com/btabaska/dotfiles.git`

No secrets live in this repo: `~/.ssh/config` holds host aliases only (no keys), and machine-specific
values stay in the untracked `~/.zshrc.local`.
