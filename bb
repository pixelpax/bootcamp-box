#!/bin/bash
# Bootcamp Box launcher

# Ensure claude is installed
if ! command -v claude &> /dev/null; then
    echo "Claude Code not found. Running installer..."
    bash ./install.sh || exit 1
fi

# Create .teacher directory if it doesn't exist
mkdir -p .teacher

# Save previous session time before starting new one
if [ -f .teacher/current-session.txt ]; then
    cp .teacher/current-session.txt .teacher/last-session.txt
fi


# Start background logger (updates current session time every 10 seconds)
(
    while true; do
        date "+%Y-%m-%d %H:%M:%S" > .teacher/current-session.txt
        sleep 10
    done
) &
LOGGER_PID=$!

# Cleanup logger on exit
trap "kill $LOGGER_PID 2>/dev/null" EXIT

# Launch Claude
claude "Read CLAUDE.md and begin"
