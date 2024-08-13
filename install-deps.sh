#!/bin/bash

set -e

# --------------------------------------------
# Configuration Variables
# --------------------------------------------

# Common packages to install across all platforms
COMMON_PACKAGES=("stow" "fish" "neovim" "wezterm" "just" "cmake")

# Cargo crates to install
CARGO_CRATES=("starship" "atuin")

# Homebrew installation URL
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Rust installation script URL
RUST_INSTALL_URL="https://sh.rustup.rs"

# --------------------------------------------
# Utility Functions
# --------------------------------------------

error() {
  echo -e "❌ $1" >&2
  exit 1
}

command_exists() {
  command -v "$1" &>/dev/null
}

is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

is_debian_based() {
  [[ -f /etc/os-release ]] && . /etc/os-release && [[ "$ID_LIKE" == *"debian"* || "$ID" == "debian" ]]
}

# --------------------------------------------
# Installation Functions
# --------------------------------------------

install_homebrew() {
  if ! command_exists brew; then
    echo "🍺 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL $HOMEBREW_INSTALL_URL)" || error "Failed to install Homebrew."
  else
    echo "✅ Homebrew is already installed."
  fi
}

install_apt_packages() {
  echo "🔄 Updating package list..."
  sudo apt-get update || error "Failed to update package list."
  echo "📦 Installing packages with apt-get..."
  sudo apt-get install -y "${@}" || error "Failed to install APT packages."
}

install_brew_packages() {
  echo "🔄 Updating Homebrew..."
  brew update || error "Failed to update Homebrew."
  echo "📦 Installing packages with Homebrew..."
  brew install "${@}" || error "Failed to install Brew packages."
}

setup_apt_repositories() {
  echo "🔑 Adding WezTerm GPG key and repository..."
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg || error "Failed to add WezTerm GPG key."
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null || error "Failed to add WezTerm repository."

  echo "🔑 Adding Prebuilt-MRP GPG key and repository"
  curl -fsSL 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1>/dev/null
  echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
}

install_rust() {
  if ! command_exists rustc; then
    echo "🔧 Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || error "Failed to install Rust."
    source "$HOME/.cargo/env"
  else
    echo "✅ Rust is already installed."
  fi
}

install_cargo_crates() {
  echo "🔧 Installing cargo-binstall"
  cargo install cargo-binstall || error "Failed to install cargo-binstall"

  for crate in "${CARGO_CRATES[@]}"; do
    if ! command_exists "$crate"; then
      echo "🔧 Installing cargo crate with binstall: $crate"
      cargo binstall "$crate" || error "Failed to install cargo crate: $crate"
    else
      echo "✅ Cargo crate '$crate' is already installed."
    fi
  done
}

# --------------------------------------------
# Main
# --------------------------------------------

main() {
  echo "⏳ Starting dependency installation..."

  if is_macos; then
    echo "🍏 Detected macOS."
    install_homebrew
    install_brew_packages "${COMMON_PACKAGES[@]}"
  elif is_debian_based; then
    echo "🐧 Detected Debian-based system."
    install_apt_packages "curl" # Ensure curl is installed first
    setup_apt_repositories
    install_apt_packages "${COMMON_PACKAGES[@]}"
  else
    error "Unsupported operating system."
  fi

  # Install common tools
  install_rust
  install_cargo_crates

  echo "🚀 Dependency installation completed successfully! ✅"
}

main
