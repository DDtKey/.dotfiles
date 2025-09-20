# Testing commands for dotfiles

# Check if testing prerequisites are available
test-check:
    @echo "🔍 Checking test prerequisites..."
    @if command -v docker >/dev/null 2>&1; then \
        echo "✅ Docker found"; \
    elif command -v podman >/dev/null 2>&1; then \
        echo "✅ Podman found"; \
    else \
        echo "❌ Neither Docker nor Podman found"; \
        exit 1; \
    fi

# Test dotfiles installation on all supported distributions
test-all: test-check
    @echo "🧪 Testing on all distributions..."
    @just test-ubuntu
    @echo ""
    @just test-fedora
    @echo ""
    @just test-debian

# Test on Ubuntu
test-ubuntu: test-check
    #!/usr/bin/env bash
    echo "🐧 Testing on Ubuntu..."
    if command -v docker >/dev/null 2>&1; then
        CONTAINER_CMD=docker
    else
        CONTAINER_CMD=podman
    fi
    $CONTAINER_CMD run --rm \
        -v $(pwd):/dotfiles:ro \
        -v $(pwd)/test-inside-container.sh:/test.sh:ro \
        --workdir /dotfiles \
        ubuntu:22.04 \
        bash /test.sh

# Test on Fedora
test-fedora: test-check
    #!/usr/bin/env bash
    echo "🎩 Testing on Fedora..."
    if command -v docker >/dev/null 2>&1; then
        CONTAINER_CMD=docker
    else
        CONTAINER_CMD=podman
    fi
    $CONTAINER_CMD run --rm \
        -v $(pwd):/dotfiles:ro \
        -v $(pwd)/test-inside-container.sh:/test.sh:ro \
        --workdir /dotfiles \
        fedora:39 \
        bash /test.sh

# Test on Debian
test-debian: test-check
    #!/usr/bin/env bash
    echo "🌀 Testing on Debian..."
    if command -v docker >/dev/null 2>&1; then
        CONTAINER_CMD=docker
    else
        CONTAINER_CMD=podman
    fi
    $CONTAINER_CMD run --rm \
        -v $(pwd):/dotfiles:ro \
        -v $(pwd)/test-inside-container.sh:/test.sh:ro \
        --workdir /dotfiles \
        debian:12 \
        bash /test.sh

# Run quick validation without full installation
test-quick:
    #!/usr/bin/env bash
    echo "🚀 Quick validation test..."

    for script in "install-deps.sh" "manage.sh" "test-inside-container.sh"; do
        if [ ! -f "./$script" ]; then
            echo "❌ $script not found"
            exit 1
        else
            echo "✅ $script exists"
        fi
    done

    for config in nvim git fish starship alacritty wezterm gitui; do
        if [ -d "$config" ]; then
            echo "✅ $config directory exists"
        else
            echo "❌ $config directory missing"
        fi
    done

    echo "✅ Quick validation completed"

