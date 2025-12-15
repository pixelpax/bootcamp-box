#!/bin/bash
# Bootcamp Box launcher

# Ensure claude is installed
if ! command -v claude &> /dev/null; then
    echo "Claude Code not found. Running installer..."
    ./install.sh || exit 1
fi

# Create .teacher directory if it doesn't exist
mkdir -p .teacher

# Start background logger (logs every 10 seconds)
(
    while true; do
        date "+%Y-%m-%d %H:%M:%S" > .teacher/last-logged-in.txt
        sleep 10
    done
) &
LOGGER_PID=$!

# Cleanup logger on exit
trap "kill $LOGGER_PID 2>/dev/null" EXIT

# Launch Claude
claude "Read CLAUDE.md and begin"