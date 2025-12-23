#!/bin/bash
# Bootcamp Box installer - ensures Node.js and Claude Code are installed

set -e

echo "🎒 Bootcamp Box Setup"
echo "===================="

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || grep -q Microsoft /proc/version 2>/dev/null; then
    OS="linux"
fi

# Check/install Node.js
if command -v node &> /dev/null; then
    echo "✓ Node.js is installed ($(node --version))"
else
    echo "✗ Node.js not found"
    echo ""
    echo "Installing Node.js..."

    if [[ "$OS" == "mac" ]]; then
        # Mac: use Homebrew
        if command -v brew &> /dev/null; then
            brew install node
        else
            echo "Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install node
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Linux/WSL: use NodeSource
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "Couldn't detect your OS. Please install Node.js manually:"
        echo "  https://nodejs.org"
        exit 1
    fi

    # Verify
    if command -v node &> /dev/null; then
        echo "✓ Node.js installed ($(node --version))"
    else
        echo "Node.js installation failed. Please install manually:"
        echo "  https://nodejs.org"
        exit 1
    fi
fi

# Check/install Claude Code
if command -v claude &> /dev/null; then
    echo "✓ Claude Code is already installed"
    claude --version
else
    echo "✗ Claude Code not found"
    echo ""
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code

    # Add ~/.local/bin to PATH if needed (claude installs there)
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"

        # Persist to shell config
        if [ -f "$HOME/.zshrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        if [ -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi
        # Create .bashrc if neither exists (fresh system)
        if [ ! -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi
    fi

    # Verify installation
    if command -v claude &> /dev/null; then
        echo "✓ Claude Code installed successfully"
    else
        echo ""
        echo "Installation may have worked but 'claude' isn't in PATH yet."
        echo "Try opening a new terminal and running './bb' again."
        exit 1
    fi
fi

# Make scripts executable
chmod +x ./bb ./install.sh ./.claude/scripts/*.sh 2>/dev/null || true

echo ""
echo "✓ Setup complete!"
echo ""
echo "To start learning, run:"
echo "  ./bb"