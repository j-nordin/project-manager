#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_LINK="$HOME/.local/bin/project"
PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins/project"

echo "Installing project-manager..."

# Symlink the script
mkdir -p "$HOME/.local/bin"
if [[ -L "$BIN_LINK" ]]; then
    rm "$BIN_LINK"
elif [[ -e "$BIN_LINK" ]]; then
    echo "error: $BIN_LINK exists and is not a symlink, skipping" >&2
    exit 1
fi
ln -s "$SCRIPT_DIR/project" "$BIN_LINK"
chmod +x "$SCRIPT_DIR/project"
echo "  Linked $BIN_LINK -> $SCRIPT_DIR/project"

# Symlink the zsh plugin
if [[ -L "$PLUGIN_DIR" ]]; then
    rm "$PLUGIN_DIR"
elif [[ -e "$PLUGIN_DIR" ]]; then
    echo "error: $PLUGIN_DIR exists and is not a symlink, skipping" >&2
    exit 1
fi
ln -s "$SCRIPT_DIR/zsh-plugin" "$PLUGIN_DIR"
echo "  Linked $PLUGIN_DIR -> $SCRIPT_DIR/zsh-plugin"

# Add plugin to zshrc if not already there
ZSHRC="$HOME/.zshrc"
if grep -q 'project' "$ZSHRC" && sed -n '/^plugins=(/,/)/p' "$ZSHRC" | grep -q 'project'; then
    echo "  Plugin 'project' already in .zshrc plugins"
else
    # Insert 'project' before the closing ) of the plugins block
    sed -i '/^plugins=(/,/)/{
        /^)/{
            i\\tproject
        }
    }' "$ZSHRC"
    echo "  Added 'project' to .zshrc plugins"
fi

echo "Done! Restart your shell or run: source ~/.zshrc"
