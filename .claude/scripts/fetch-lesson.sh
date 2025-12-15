#!/bin/bash
# Fetch a lesson from the content repo
# Usage: ./tools/fetch-lesson.sh fundamentals/01-hello-terminal
#
# Dev mode: Set BOOTCAMP_DEV=1 or create .dev file to pull from local content/

set -e

LESSON_PATH="$1"
LOCAL_LESSONS="./lessons"

if [ -z "$LESSON_PATH" ]; then
    echo "Usage: $0 <course/lesson>"
    echo "Example: $0 fundamentals/01-hello-terminal"
    exit 1
fi

# Check for dev mode: env var or .dev file
if [ -n "$BOOTCAMP_DEV" ] || [ -f ".dev" ]; then
    # Find content dir relative to where we're running
    if [ -d "../content" ]; then
        CONTENT_DIR="../content"
    elif [ -d "../../content" ]; then
        CONTENT_DIR="../../content"
    else
        echo "Dev mode: Can't find content directory"
        exit 1
    fi

    echo "[DEV MODE] Copying from $CONTENT_DIR/$LESSON_PATH"
    mkdir -p "$LOCAL_LESSONS/$(dirname "$LESSON_PATH")"
    cp -r "$CONTENT_DIR/$LESSON_PATH" "$LOCAL_LESSONS/$(dirname "$LESSON_PATH")/"
else
    # Production: download from GitHub
    echo "Fetching from GitHub..."
    mkdir -p "$LOCAL_LESSONS/$(dirname "$LESSON_PATH")"
    gh api repos/pixelpax/code-chode/contents/content/$LESSON_PATH \
        --jq '.[].download_url' | xargs -I {} curl -sS {} # TODO: needs work
fi

echo "Lesson ready at $LOCAL_LESSONS/$LESSON_PATH"