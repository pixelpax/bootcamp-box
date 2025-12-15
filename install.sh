#!/bin/bash
# Bootcamp Box installer - ensures Claude Code is installed

set -e

echo "🎒 Bootcamp Box Setup"
echo "===================="

# Check if claude is installed
if command -v claude &> /dev/null; then
    echo "✓ Claude Code is already installed"
    claude --version
else
    echo "✗ Claude Code not found"
    echo ""
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash

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

echo ""
echo "✓ Setup complete!"
echo ""
echo "To start learning, run:"
echo "  ./bb"