#!/bin/bash
# List all available lessons in the curriculum
# Shows the full hierarchy: section/unit/lesson
#
# Dev mode: Set BOOTCAMP_DEV=1 or create .dev file to list from local content/

set -e

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

    echo "[DEV MODE] Available lessons:"
    echo ""

    # List all lessons with hierarchy
    for section in "$CONTENT_DIR"/*/; do
        section_name=$(basename "$section")
        echo "$section_name/"
        for unit in "$section"*/; do
            [ -d "$unit" ] || continue
            unit_name=$(basename "$unit")
            echo "  $unit_name/"
            for lesson in "$unit"*/; do
                [ -d "$lesson" ] || continue
                lesson_name=$(basename "$lesson")
                echo "    $lesson_name"
            done
        done
    done
else
    # Production: list from GitHub using tree API
    echo "Available lessons:"
    echo ""

    gh api "repos/pixelpax/code-chode/git/trees/main?recursive=1" \
        --jq '.tree[] | select(.path | startswith("content/")) | select(.type == "tree") | .path' \
        | sed 's|^content/||' \
        | grep -E '^[^/]+/[^/]+/[^/]+$' \
        | sort \
        | while read -r path; do
            section=$(echo "$path" | cut -d'/' -f1)
            unit=$(echo "$path" | cut -d'/' -f2)
            lesson=$(echo "$path" | cut -d'/' -f3)
            echo "$section/$unit/$lesson"
        done
fi