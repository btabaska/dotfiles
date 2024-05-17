if status is-interactive
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
starship init fish | source
# Commands to run in interactive sessions can go here
end
