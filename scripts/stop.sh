#!/bin/bash
# Stop the voice-to-claude daemon

CONFIG_DIR="$HOME/.config/voice-to-claude"
PID_FILE="$CONFIG_DIR/daemon.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "Daemon is not running (no PID file)"
    exit 0
fi

PID=$(cat "$PID_FILE")

if kill -0 "$PID" 2>/dev/null; then
    echo "Stopping daemon (PID: $PID)..."
    kill "$PID"
    rm -f "$PID_FILE"
    echo "✓ Daemon stopped"
else
    echo "Daemon was not running (stale PID file removed)"
    rm -f "$PID_FILE"
fi
