#!/bin/bash

set -e

# --------------------------------------------
# Configuration Variables
# --------------------------------------------

# Common packages to install across all platforms
COMMON_PACKAGES=("stow" "fish" "neovim" "wezterm" "just" "cmake" "ripgrep" "fd")

# Homebrew installation URL
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

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

  echo "🔑 Adding Prebuilt-MRP GPG key and repository..."
  curl -fsSL 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1>/dev/null
  echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
}

install_by_url() {
  local url="$1"
  local tool_name="$2"

  if ! command_exists "$tool_name"; then
    echo "🔧 Installing $tool_name..."
    curl -fsSL "$url" | sh || error "Failed to install $tool_name from URL."
  else
    echo "✅ $tool_name is already installed."
  fi
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
    MACOS_PACKAGES=("rectangle")
    install_brew_packages "${MACOS_PACKAGES[@]}"
  elif is_debian_based; then
    echo "🐧 Detected Debian-based system."
    install_apt_packages "curl" # Ensure curl is installed first
    setup_apt_repositories
    install_apt_packages "${COMMON_PACKAGES[@]}"
  else
    error "Unsupported operating system."
  fi

  # Install tools from URLs
  install_by_url "https://sh.rustup.rs" "rustup"
  install_by_url "https://starship.rs/install.sh" "starship"
  install_by_url "https://setup.atuin.sh" "atuin"

  echo "🚀 Dependency installation completed successfully! ✅"
}

main
