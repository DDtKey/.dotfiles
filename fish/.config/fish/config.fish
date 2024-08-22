if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

# init starship
starship init fish | source

# functions specific for current environment
if test -f ~/.config/fish/functions/local_fns.fish
    source ~/.config/fish/functions/local_fns.fish
end

# setup theme
source ~/.config/fish/theme.fish

# PATH config
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin

