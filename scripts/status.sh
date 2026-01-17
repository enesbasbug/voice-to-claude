#!/bin/bash
# Check voice-to-claude daemon status

CONFIG_DIR="$HOME/.config/voice-to-claude"
PID_FILE="$CONFIG_DIR/daemon.pid"
CONFIG_FILE="$CONFIG_DIR/config.json"

echo "Voice-to-Claude Status"
echo "========================================"

# Check setup
if [ -f "$CONFIG_FILE" ]; then
    SETUP_COMPLETE=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('setup_complete', False))")
    if [ "$SETUP_COMPLETE" = "True" ]; then
        echo "Setup: Complete"
    else
        echo "Setup: Not complete"
        echo ""
        echo "Run: bash ~/.claude/skills/voice-to-claude/scripts/setup.sh"
        exit 0
    fi
else
    echo "Setup: Not complete"
    echo ""
    echo "Run: bash ~/.claude/skills/voice-to-claude/scripts/setup.sh"
    exit 0
fi

# Check daemon
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Daemon: Running (PID: $PID)"
    else
        echo "Daemon: Stopped (stale PID)"
    fi
else
    echo "Daemon: Stopped"
fi

# Show config
if [ -f "$CONFIG_FILE" ]; then
    MODEL=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('model', 'base'))")
    echo "Model: $MODEL"

    HOTKEY=$(python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
parts = []
if c.get('hotkey_ctrl', True): parts.append('Ctrl')
if c.get('hotkey_alt', True): parts.append('Alt')
if c.get('hotkey_shift', False): parts.append('Shift')
if c.get('hotkey_cmd', False): parts.append('Cmd')
print('+'.join(parts))
")
    echo "Hotkey: $HOTKEY"
fi

echo "========================================"
