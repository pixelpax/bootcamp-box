#!/bin/bash
# List available lessons in a section/unit
# Usage: ./list-available-lessons.sh fundamentals/01-terminal-basics
#
# Dev mode: Set BOOTCAMP_DEV=1 or create .dev file to list from local content/

set -e

UNIT_PATH="$1"

if [ -z "$UNIT_PATH" ]; then
    echo "Usage: $0 <section/unit>"
    echo "Example: $0 fundamentals/01-terminal-basics"
    exit 1
fi

# Check for dev mode: env var or .dev file
if [ -n "$BOOTCAMP_DEV" ] || [ -f ".dev" ]; then
    # Find content dir relative to where we're running
    if [ -d "../../../../content" ]; then
        CONTENT_DIR="../../../../content"
    elif [ -d "../../../content" ]; then
        CONTENT_DIR="../../../content"
    elif [ -d "../../content" ]; then
        CONTENT_DIR="../../content"
    elif [ -d "../content" ]; then
        CONTENT_DIR="../content"
    else
        echo "Dev mode: Can't find content directory"
        exit 1
    fi

    echo "[DEV MODE] Listing from $CONTENT_DIR/$UNIT_PATH"
    ls -1 "$CONTENT_DIR/$UNIT_PATH" | sort
else
    # Production: list from GitHub
    gh api "repos/pixelpax/code-chode/contents/content/$UNIT_PATH" --jq '.[].name' | sort
fi
