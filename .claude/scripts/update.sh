#!/bin/bash
# Update Bootcamp Box infrastructure from the main repo
# Usage: ./.claude/scripts/update.sh
#
# Replaces .claude/ and course_map.html with latest from main.
# NEVER touches: .teacher/, lessons/

set -e

REPO="pixelpax/bootcamp-box-dev"
BRANCH="main"
BASE_PATH="bootcamp-box"

echo "Updating Bootcamp Box from main..."
echo ""

# Recursive fetch for directories with subdirs (like .claude/)
fetch_dir() {
    local api_path="$1"
    local dest_path="$2"

    mkdir -p "$dest_path"

    gh api "repos/$REPO/contents/$api_path" --jq '.[] | "\(.path) \(.type)"' | while read -r path type; do
        local name=$(basename "$path")
        if [ "$type" = "dir" ]; then
            fetch_dir "$path" "$dest_path/$name"
        else
            curl -sS "https://raw.githubusercontent.com/$REPO/$BRANCH/$path" -o "$dest_path/$name"
        fi
    done
}

# Clear and re-fetch .claude/
echo "  Fetching .claude/..."
rm -rf .claude
fetch_dir "$BASE_PATH/.claude" ".claude"
chmod +x .claude/scripts/*.sh

# Update root files
echo "  Fetching course_map.html..."
curl -sS "https://raw.githubusercontent.com/$REPO/$BRANCH/$BASE_PATH/course_map.html" -o "course_map.html"

echo ""
echo "Done! Your .teacher/ and lessons/ are untouched."