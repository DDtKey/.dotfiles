#!/bin/bash

# Define a list of packages that should be installed on all platforms
COMMON_PACKAGES=("stow" "fish" "neovim" "starship" "wezterm")

install_macos() {
  echo "🍏 Detected macOS. Installing dependencies..."

  # Install Homebrew if not installed
  if ! command -v brew &>/dev/null; then
    echo "🏠 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
      echo "❌ Homebrew installation failed."
      exit 1
    }
  else
    echo "✅ Homebrew is already installed."
  fi

  echo "🔄 Installing packages with Homebrew..."
  brew install "${COMMON_PACKAGES[@]}" || {
    echo "❌ Package installation failed."
    exit 1
  }
}

install_debian() {
  echo "🐧 Detected Debian-based system. Installing dependencies..."

  sudo apt-get update || {
    echo "❌ Failed to update package list."
    exit 1
  }

  DEBIAN_PACKAGES=("curl")
  ALL_PACKAGES=("${COMMON_PACKAGES[@]}" "${DEBIAN_PACKAGES[@]}")

  echo "🔄 Installing packages with apt-get..."
  sudo apt-get install -y "${ALL_PACKAGES[@]}" || {
    echo "❌ Package installation failed."
    exit 1
  }
}

is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

is_debian_based() {
  [[ -f /etc/os-release ]] && . /etc/os-release && [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]
}

echo "⏳ Dependency installation initiated 💻"

if is_macos; then
  install_macos
elif is_debian_based; then
  install_debian
else
  echo "❌ Unsupported operating system 😵"
  exit 1
fi

echo "🚀 Dependency installation completed successfully! ✅"
