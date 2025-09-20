# Dotfiles management and testing

# Show available commands
default:
    @just --list

# --- Environment Management ---

# Bootstrap entire environment (install deps + setup configs)
bootstrap:
    ./install-deps.sh
    ./manage.sh setup

# Install dependencies only
install-deps:
    ./install-deps.sh

# Setup configurations (stow all)
setup:
    ./manage.sh setup

# Remove configurations (unstow all)
cleanup:
    ./manage.sh cleanup

# Stow a specific configuration
stow config:
    stow {{config}}

# Unstow a specific configuration
unstow config:
    stow -D {{config}}

# --- Testing ---

import 'test.just'

# --- Development ---

# Update Neovim plugins
update-nvim:
    nvim --headless "+Lazy! sync" +qa

# Update Homebrew packages (macOS)
update-brew:
    brew update && brew upgrade && brew cleanup

# Quick commit with message
commit message:
    git add . && git commit -m "{{message}}"

# Push to remote
push:
    git push

# --- System Maintenance ---

# Clean up system (brew, docker, etc.)
clean-system:
    @echo "🧹 Cleaning up system..."
    @if command -v brew >/dev/null 2>&1; then brew cleanup; fi
    @if command -v docker >/dev/null 2>&1; then docker system prune -f; fi
    @if command -v npm >/dev/null 2>&1; then npm cache clean --force; fi

# Validate stow status
validate-stow:
    #!/usr/bin/env bash
    for config in nvim git fish starship alacritty wezterm gitui; do
        if [ -L ~/.config/$$config ] || [ -L ~/.$$config ]; then
            echo "✅ $$config is stowed"
        else
            echo "❌ $$config is not stowed"
        fi
    done

# --- Quick Edits ---

# Edit Neovim config
edit-nvim:
    $$EDITOR ~/.config/nvim/

# Edit Fish config
edit-fish:
    $$EDITOR ~/.config/fish/config.fish

# Edit this justfile
edit-just:
    $$EDITOR justfile
