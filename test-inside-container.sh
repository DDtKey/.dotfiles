#!/bin/bash

set -e
test_result() {
    local test_name="$1"
    local status="$2"

    if [ "$status" = "0" ]; then
        echo "✅ $test_name: PASS"
        return 0
    else
        echo "❌ $test_name: FAIL"
        return 1
    fi
}

echo "🚀 Starting dotfiles installation test..."
echo "📋 System info: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"

echo "🔧 Preparing container environment..."
if command -v apt-get &>/dev/null; then
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y curl gpg lsb-release ca-certificates
elif command -v dnf &>/dev/null; then
    dnf makecache --refresh -q
    dnf install -q -y curl gnupg2 redhat-lsb-core ca-certificates
fi

cd /dotfiles

echo "📦 Testing dependency installation..."
if timeout 300 ./install-deps.sh; then
    test_result "Dependency Installation" 0
    install_success=0
else
    test_result "Dependency Installation" 1
    install_success=1
fi

echo "🔍 Testing critical tools installation..."
tools_failed=0
if command -v stow &>/dev/null; then
    echo "  ✅ stow: $(command -v stow)"
else
    echo "  ❌ stow: NOT FOUND"
    tools_failed=1
fi

if command -v fish &>/dev/null; then
    echo "  ✅ fish: $(command -v fish)"
else
    echo "  ❌ fish: NOT FOUND"
    tools_failed=1
fi

if command -v nvim &>/dev/null; then
    echo "  ✅ nvim: $(command -v nvim)"
elif command -v neovim &>/dev/null; then
    echo "  ✅ neovim: $(command -v neovim)"
else
    echo "  ❌ nvim/neovim: NOT FOUND"
    tools_failed=1
fi

test_result "Critical Tools Check" $tools_failed

echo "🔗 Testing stow operations..."
stow_failed=0
if [ "$install_success" = "0" ]; then
    for config in nvim git fish starship alacritty; do
        if [ -d "$config" ]; then
            if stow --simulate "$config" 2>/dev/null; then
                echo "  ✅ $config: stow simulation OK"
            else
                echo "  ❌ $config: stow simulation FAILED"
                stow_failed=1
            fi
        fi
    done
else
    echo "  ⏭️  Skipping stow test due to installation failure"
    stow_failed=1
fi
test_result "Stow Operations" $stow_failed

echo "🔧 Testing basic configurations..."
config_failed=0
if [ -f "fish/.config/fish/config.fish" ]; then
    if fish -n "fish/.config/fish/config.fish" 2>/dev/null; then
        echo "  ✅ fish config: syntax OK"
    else
        echo "  ❌ fish config: syntax ERROR"
        config_failed=1
    fi
fi

if [ -f "nvim/.config/nvim/init.lua" ]; then
    echo "  ✅ neovim config: exists"
else
    echo "  ❌ neovim config: missing"
    config_failed=1
fi

test_result "Configuration Validation" $config_failed

echo ""
echo "🏁 Test completed for $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"