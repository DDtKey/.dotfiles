#!/bin/bash

# Define the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Configuration directories to manage
CONFIGS=("nvim" "tmux" "zsh" "git" "fish" "starship" "alacritty" "wezterm") 

# Change to the dotfiles directory
cd $DOTFILES_DIR

setup() {
  success=true
  for config in "${CONFIGS[@]}"; do
    if stow $config; then
      echo "Successfully stowed $config"
    else
      echo "Failed to stow $config"
      success=false
    fi
  done
  if [ "$success" = true ]; then
    echo "All specified configurations have been stowed."
  else
    echo "Some configurations could not be stowed. Please check the errors above."
  fi
}

cleanup() {
  local success=true
  for config in "${CONFIGS[@]}"; do
    if stow -D $config; then
      echo "Successfully unstowed $config"
    else
      echo "Failed to unstow $config"
      success=false
    fi
  done
  if [ "$success" = true ]; then
    echo "Environment cleaned up. All specified configurations have been unstowed."
  else
    echo "Some configurations could not be unstowed. Please check the errors above."
  fi
}

if [ -z "$1" ]; then
  setup
else
  case "$1" in
  setup)
    setup
    ;;
  cleanup)
    cleanup
    ;;
  *)
    echo "Invalid option: $1"
    echo "Usage: $0 [install|cleanup]"
    exit 1
    ;;
  esac
fi
