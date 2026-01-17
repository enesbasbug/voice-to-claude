#!/bin/bash
# Configure voice-to-claude settings

CONFIG_DIR="$HOME/.config/voice-to-claude"
CONFIG_FILE="$CONFIG_DIR/config.json"
INSTALL_DIR="$HOME/.local/share/voice-to-claude"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Setup not complete. Run setup first:"
    echo "  bash ~/.claude/skills/voice-to-claude/scripts/setup.sh"
    exit 1
fi

show_help() {
    echo "Voice-to-Claude Configuration"
    echo ""
    echo "Usage: config.sh <setting> <value>"
    echo ""
    echo "Settings:"
    echo "  model <name>      - Change Whisper model (tiny, base, medium, large-v3)"
    echo "  hotkey <keys>     - Change hotkey (e.g., ctrl+alt, ctrl+shift)"
    echo "  output <mode>     - Change output mode (keyboard, clipboard)"
    echo "  sounds <on|off>   - Enable/disable sound effects"
    echo ""
    echo "Examples:"
    echo "  config.sh model medium"
    echo "  config.sh hotkey ctrl+shift"
    echo "  config.sh output clipboard"
    echo ""
}

if [ $# -lt 1 ]; then
    show_help
    exit 0
fi

SETTING="$1"
VALUE="$2"

case "$SETTING" in
    model)
        if [ -z "$VALUE" ]; then
            echo "Current model: $(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('model', 'base'))")"
            echo ""
            echo "Available models: tiny, base, medium, large-v3"
            exit 0
        fi

        # Check if model exists
        MODEL_FILE="$INSTALL_DIR/whisper.cpp/models/ggml-${VALUE}.bin"
        if [ ! -f "$MODEL_FILE" ]; then
            echo "Model '$VALUE' not downloaded."
            echo "Download it with:"
            echo "  cd $INSTALL_DIR/whisper.cpp && ./models/download-ggml-model.sh $VALUE"
            exit 1
        fi

        python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
c['model'] = '$VALUE'
json.dump(c, open('$CONFIG_FILE', 'w'), indent=2)
"
        echo "Model changed to: $VALUE"
        echo "Restart daemon for changes to take effect."
        ;;

    hotkey)
        if [ -z "$VALUE" ]; then
            HOTKEY=$(python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
parts = []
if c.get('hotkey_ctrl', True): parts.append('ctrl')
if c.get('hotkey_alt', True): parts.append('alt')
if c.get('hotkey_shift', False): parts.append('shift')
if c.get('hotkey_cmd', False): parts.append('cmd')
print('+'.join(parts))
")
            echo "Current hotkey: $HOTKEY"
            echo ""
            echo "Options: ctrl, alt, shift, cmd (combine with +)"
            echo "Example: config.sh hotkey ctrl+alt"
            exit 0
        fi

        python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
keys = '$VALUE'.lower().split('+')
c['hotkey_ctrl'] = 'ctrl' in keys
c['hotkey_alt'] = 'alt' in keys
c['hotkey_shift'] = 'shift' in keys
c['hotkey_cmd'] = 'cmd' in keys
json.dump(c, open('$CONFIG_FILE', 'w'), indent=2)
"
        echo "Hotkey changed to: $VALUE"
        echo "Restart daemon for changes to take effect."
        ;;

    output)
        if [ -z "$VALUE" ]; then
            echo "Current output mode: $(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('output_mode', 'keyboard'))")"
            echo ""
            echo "Options: keyboard, clipboard"
            exit 0
        fi

        python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
c['output_mode'] = '$VALUE'
json.dump(c, open('$CONFIG_FILE', 'w'), indent=2)
"
        echo "Output mode changed to: $VALUE"
        echo "Restart daemon for changes to take effect."
        ;;

    sounds)
        if [ -z "$VALUE" ]; then
            echo "Sound effects: $(python3 -c "import json; print('on' if json.load(open('$CONFIG_FILE')).get('sound_effects', True) else 'off')")"
            exit 0
        fi

        if [ "$VALUE" = "on" ]; then
            BOOL="true"
        else
            BOOL="false"
        fi

        python3 -c "
import json
c = json.load(open('$CONFIG_FILE'))
c['sound_effects'] = $BOOL
json.dump(c, open('$CONFIG_FILE', 'w'), indent=2)
"
        echo "Sound effects: $VALUE"
        ;;

    *)
        echo "Unknown setting: $SETTING"
        show_help
        exit 1
        ;;
esac
