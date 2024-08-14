if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting
starship init fish | source

if test -f ~/.config/fish/functions/local_fns.fish
    source ~/.config/fish/functions/local_fns.fish
end
