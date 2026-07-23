if status is-interactive
    # Homebrew (macOS /opt/homebrew, Intel /usr/local, or linuxbrew) — only if present
    for brewbin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
        if test -x $brewbin
            eval ($brewbin shellenv)
            break
        end
    end

    # Prompt + shell tools
    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init fish | source
    type -q fzf; and fzf --fish 2>/dev/null | source

    # Modern CLI aliases
    if type -q eza
        alias ls 'eza --group-directories-first --icons=auto'
        alias ll 'eza -lah --group-directories-first --icons=auto --git'
        alias la 'eza -a --group-directories-first --icons=auto'
        alias lt 'eza --tree --level=2 --icons=auto'
    end
    type -q bat; and alias cat 'bat --paging=never'
end
