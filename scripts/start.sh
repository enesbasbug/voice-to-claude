#!/bin/bash
# Start the voice-to-claude daemon

SKILL_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
INSTALL_DIR="$HOME/.local/share/voice-to-claude"
CONFIG_DIR="$HOME/.config/voice-to-claude"
PID_FILE="$CONFIG_DIR/daemon.pid"

# Check if already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Daemon already running (PID: $PID)"
        exit 0
    fi
fi

# Check if setup is complete
if [ ! -f "$CONFIG_DIR/config.json" ]; then
    echo "Setup not complete. Run:"
    echo "  bash ~/.claude/skills/voice-to-claude/scripts/setup.sh"
    exit 1
fi

# Determine Python source location
if [ -d "$INSTALL_DIR/src" ]; then
    SRC_DIR="$INSTALL_DIR/src"
elif [ -d "$SKILL_DIR/src" ]; then
    SRC_DIR="$SKILL_DIR/src"
else
    echo "Error: Cannot find Python source files"
    exit 1
fi

echo "Starting voice-to-claude daemon..."

# Start daemon in background
nohup python3 -c "
import sys
sys.path.insert(0, '$SRC_DIR')
from voice_to_claude.daemon import start_daemon
start_daemon(background=False, quiet=False)
" > "$CONFIG_DIR/daemon.log" 2>&1 &

echo $! > "$PID_FILE"

sleep 1

if kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo "✓ Daemon started (PID: $(cat "$PID_FILE"))"
    echo ""
    echo "Hold Ctrl+Alt and speak to dictate!"
    echo ""
    echo "View logs: tail -f ~/.config/voice-to-claude/daemon.log"
else
    echo "✗ Failed to start daemon. Check logs:"
    echo "  tail ~/.config/voice-to-claude/daemon.log"
    exit 1
fi
