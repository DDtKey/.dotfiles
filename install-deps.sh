#!/bin/bash

set -e

# ------------------------------------------------------
# Configuration
# ------------------------------------------------------

COMMON_PACKAGES=("stow" "fish" "neovim" "wezterm" "just" "cmake" "ripgrep" "fd")
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# ------------------------------------------------------
# Utility Functions
# ------------------------------------------------------

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

is_fedora_based() {
  [[ -f /etc/os-release ]] && . /etc/os-release && [[ "$ID" == "fedora" || "$ID_LIKE" == *"fedora"* || "$ID" == "rhel" || "$ID" == "centos" ]]
}

is_container() {
  [[ -f /.dockerenv ]] || [[ -n "${container}" ]] || [[ "${CONTAINER:-}" == "1" ]]
}

# ------------------------------------------------------
# Installation Functions
# ------------------------------------------------------

install_homebrew() {
  if ! command_exists brew; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL $HOMEBREW_INSTALL_URL)" || error "Failed to install Homebrew."
  else
    echo "✅ Homebrew is already installed."
  fi
}

install_apt_packages() {
  echo "🔄 Updating package list..."
  if [ "$EUID" -eq 0 ]; then
    apt-get update || error "Failed to update package list."
    echo "📦 Installing packages..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${@}" || error "Failed to install APT packages."
  elif command -v sudo &>/dev/null; then
    sudo apt-get update || error "Failed to update package list."
    echo "📦 Installing packages..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${@}" || error "Failed to install APT packages."
  else
    error "Neither running as root nor sudo available."
  fi
}

install_brew_packages() {
  echo "🔄 Updating Homebrew..."
  brew update || error "Failed to update Homebrew."
  echo "📦 Installing packages with Homebrew..."
  brew install "${@}" || error "Failed to install Brew packages."
}

install_dnf_packages() {
  echo "🔄 Updating DNF cache..."
  if [ "$EUID" -eq 0 ]; then
    dnf makecache --refresh || error "Failed to update DNF cache."
    echo "📦 Installing packages..."
    dnf install -y "${@}" || error "Failed to install DNF packages."
  elif command -v sudo &>/dev/null; then
    sudo dnf makecache --refresh || error "Failed to update DNF cache."
    echo "📦 Installing packages..."
    sudo dnf install -y "${@}" || error "Failed to install DNF packages."
  else
    error "Neither running as root nor sudo available."
  fi
}

setup_apt_repositories() {
  echo "🔑 Setting up repositories..."
  if [ "$EUID" -eq 0 ]; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg || error "Failed to add WezTerm GPG key."
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | tee /etc/apt/sources.list.d/wezterm.list >/dev/null || error "Failed to add WezTerm repository."
    curl -fsSL 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1>/dev/null
    echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | tee /etc/apt/sources.list.d/prebuilt-mpr.list
  elif command -v sudo &>/dev/null; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg || error "Failed to add WezTerm GPG key."
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null || error "Failed to add WezTerm repository."
    curl -fsSL 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1>/dev/null
    echo "deb [arch=all,$(dpkg --print-architecture) signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
  else
    error "Cannot setup repositories."
  fi
}

setup_fedora_repositories() {
  echo "🔑 Setting up Fedora repositories..."
  if [ "$EUID" -eq 0 ]; then
    dnf copr enable -y wezfurlong/wezterm-nightly || echo "⚠️ WezTerm COPR repository may already be enabled"
  elif command -v sudo &>/dev/null; then
    sudo dnf copr enable -y wezfurlong/wezterm-nightly || echo "⚠️ WezTerm COPR repository may already be enabled"
  else
    echo "⚠️ Cannot setup WezTerm repository without root or sudo"
  fi
}

install_by_url() {
  local url="$1"
  local tool_name="$2"
  local extra_args="${3:-}"

  if ! command_exists "$tool_name"; then
    echo "🔧 Installing $tool_name..."
    if [ -n "$extra_args" ]; then
      curl -fsSL "$url" | sh -s -- $extra_args || error "Failed to install $tool_name from URL."
    else
      curl -fsSL "$url" | sh || error "Failed to install $tool_name from URL."
    fi
  else
    echo "✅ $tool_name is already installed."
  fi
}

# ------------------------------------------------------
# Main
# ------------------------------------------------------

main() {
  echo "⏳ Starting dependency installation..."

  if is_macos; then
    echo "🍏 Detected macOS."
    install_homebrew
    install_brew_packages "${COMMON_PACKAGES[@]}"
    MACOS_PACKAGES=("rectangle" "atuin")
    install_brew_packages "${MACOS_PACKAGES[@]}"
  elif is_debian_based; then
    echo "🐧 Detected Debian-based system."
    install_apt_packages "curl"

    if is_container; then
      echo "📦 Container mode: installing core packages only"
      CONTAINER_PACKAGES=("stow" "fish" "neovim" "cmake" "ripgrep" "fd-find")
      install_apt_packages "${CONTAINER_PACKAGES[@]}"
    else
      setup_apt_repositories
      install_apt_packages "${COMMON_PACKAGES[@]}"
    fi
  elif is_fedora_based; then
    echo "🎩 Detected Fedora-based system."
    install_dnf_packages "curl"

    if is_container; then
      echo "📦 Container mode: installing core packages only"
      CONTAINER_PACKAGES=("stow" "fish" "neovim" "cmake" "ripgrep" "fd-find")
      install_dnf_packages "${CONTAINER_PACKAGES[@]}"
    else
      setup_fedora_repositories
      FEDORA_PACKAGES=("stow" "fish" "neovim" "wezterm" "just" "cmake" "ripgrep" "fd-find")
      install_dnf_packages "${FEDORA_PACKAGES[@]}"
    fi
  else
    error "Unsupported operating system."
  fi

  if is_container; then
    install_by_url "https://sh.rustup.rs" "rustup" "-y"
    install_by_url "https://starship.rs/install.sh" "starship" "--yes"
    install_by_url "https://setup.atuin.sh" "atuin" "--non-interactive"
  else
    install_by_url "https://sh.rustup.rs" "rustup"
    install_by_url "https://starship.rs/install.sh" "starship"
    if ! is_macos; then
      install_by_url "https://setup.atuin.sh" "atuin"
    fi
  fi

  echo "🚀 Dependency installation completed successfully! ✅"
}

main
