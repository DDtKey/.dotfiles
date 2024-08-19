#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Define the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Configuration directories to manage
CONFIGS=("nvim" "git" "fish" "starship" "alacritty" "wezterm" "gitui")

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || {
  echo "Directory $DOTFILES_DIR does not exist!"
  exit 1
}

setup_env() {
  echo "🔧 Setting up configurations..."
  local success=true
  for config in "${CONFIGS[@]}"; do
    if stow "$config"; then
      echo "✔️ Successfully stowed $config"
    else
      echo "❌ Failed to stow $config"
      success=false
    fi
  done
  if [ "$success" = true ]; then
    echo "🎉 All environment configurations have been stowed."
  else
    echo "⚠️ Some configurations could not be stowed. Please check the errors above."
  fi
}

cleanup_env() {
  echo "🧹 Cleaning up configurations..."
  local success=true
  for config in "${CONFIGS[@]}"; do
    if stow -D "$config"; then
      echo "✔️ Successfully unstowed $config"
    else
      echo "❌ Failed to unstow $config"
      success=false
    fi
  done
  if [ "$success" = true ]; then
    echo "🗑️ Environment cleaned up. All specified configurations have been unstowed."
  else
    echo "⚠️ Some configurations could not be unstowed. Please check the errors above."
  fi
}

bootstrap() {
  echo "🚀 Bootstrapping the environment..."
  if "$SCRIPT_DIR/install-deps.sh"; then
    setup_env
  else
    echo "❌ Failed to install dependencies. Aborting setup."
  fi
}

if [ -z "$1" ]; then
  echo "🔄 No argument provided. Defaulting to setup..."
  setup_env
else
  case "$1" in
  bootstrap)
    bootstrap
    ;;
  setup)
    setup_env
    ;;
  cleanup)
    cleanup_env
    ;;
  *)
    echo "❌ Invalid option: $1"
    echo "Usage: $0 [bootstrap|setup|cleanup]"
    exit 1
    ;;
  esac
fi
