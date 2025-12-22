#!/bin/bash
# Fetch a lesson from the content repo
# Usage: ./fetch-lesson.sh fundamentals/01-terminal-basics/01-hello-terminal
#
# Dev mode: Set BOOTCAMP_DEV=1 or create .dev file to pull from local content/

set -e

LESSON_PATH="$1"
LOCAL_LESSONS="./lessons"

if [ -z "$LESSON_PATH" ]; then
    echo "Usage: $0 <section/unit/lesson>"
    echo "Example: $0 fundamentals/01-terminal-basics/01-hello-terminal"
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

    echo "[DEV MODE] Copying from $CONTENT_DIR/$LESSON_PATH"
    mkdir -p "$LOCAL_LESSONS/$(dirname "$LESSON_PATH")"
    cp -r "$CONTENT_DIR/$LESSON_PATH" "$LOCAL_LESSONS/$(dirname "$LESSON_PATH")/"
else
    # Production: download from GitHub using gh
    echo "Fetching from GitHub..."
    DEST="$LOCAL_LESSONS/$LESSON_PATH"
    mkdir -p "$DEST"

    # Recursive function to fetch directory contents
    fetch_dir() {
        local api_path="$1"
        local dest_base="$2"

        gh api "repos/pixelpax/bootcamp-box-dev/contents/$api_path" --jq '.[] | "\(.path) \(.type)"' | while read -r path type; do
            REL_PATH="${path#content/$LESSON_PATH/}"
            if [ "$type" = "dir" ]; then
                mkdir -p "$dest_base/$REL_PATH"
                fetch_dir "$path" "$dest_base"
            else
                curl -sS "https://raw.githubusercontent.com/pixelpax/bootcamp-box-dev/main/$path" -o "$dest_base/$REL_PATH"
            fi
        done
    }

    fetch_dir "content/$LESSON_PATH" "$DEST"
fi

echo "Lesson ready at $LOCAL_LESSONS/$LESSON_PATH"