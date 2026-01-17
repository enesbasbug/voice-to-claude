---
description: Configure voice-to-claude settings
---

# Voice-to-Claude Configuration

Configure voice-to-claude settings including model, hotkey, and output mode.

## Current Configuration

Check current settings:

```bash
python3 -c "
import json
from pathlib import Path

config_file = Path.home() / '.config' / 'voice-to-claude' / 'config.json'
if config_file.exists():
    config = json.load(open(config_file))
    print('Current Configuration')
    print('=' * 40)
    print(f'Model: {config.get(\"model\", \"base\")}')
    hotkey_parts = []
    if config.get('hotkey_ctrl', True): hotkey_parts.append('Ctrl')
    if config.get('hotkey_alt', True): hotkey_parts.append('Alt')
    if config.get('hotkey_shift', False): hotkey_parts.append('Shift')
    if config.get('hotkey_cmd', False): hotkey_parts.append('Cmd')
    print(f'Hotkey: {\" + \".join(hotkey_parts)}')
    print(f'Output Mode: {config.get(\"output_mode\", \"keyboard\")}')
    print(f'Sound Effects: {config.get(\"sound_effects\", True)}')
    print(f'Max Recording: {config.get(\"max_recording_seconds\", 60)}s')
else:
    print('No configuration found. Run /voice-to-claude:setup first.')
"
```

## Available Models

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| tiny | ~75MB | Fastest (~0.5s) | Basic |
| base | ~142MB | Fast (~1s) | Good (default) |
| medium | ~1.5GB | Medium (~2s) | Better |
| large-v3 | ~3GB | Slow (~3s) | Best |

## Change Model

To change the Whisper model:

### 1. Download the model (if not already downloaded)

```bash
cd ~/.local/share/voice-to-claude/whisper.cpp
# Replace MODEL with: tiny, base, medium, or large-v3
./models/download-ggml-model.sh MODEL
```

### 2. Update configuration

```bash
python3 -c "
import json
from pathlib import Path

# Change this to your desired model
NEW_MODEL = 'base'  # Options: tiny, base, medium, large-v3

config_file = Path.home() / '.config' / 'voice-to-claude' / 'config.json'
config = json.load(open(config_file)) if config_file.exists() else {}
config['model'] = NEW_MODEL
config_file.parent.mkdir(parents=True, exist_ok=True)
json.dump(config, open(config_file, 'w'), indent=2)
print(f'Model changed to: {NEW_MODEL}')
print('Restart the daemon for changes to take effect.')
"
```

## Change Hotkey

The default hotkey is Ctrl+Alt (hold both to record).

To change the hotkey combination:

```bash
python3 -c "
import json
from pathlib import Path

# Configure which modifier keys to use (set to True/False)
HOTKEY_CTRL = True   # Left Control
HOTKEY_ALT = True    # Left Alt/Option
HOTKEY_SHIFT = False # Left Shift
HOTKEY_CMD = False   # Left Command

config_file = Path.home() / '.config' / 'voice-to-claude' / 'config.json'
config = json.load(open(config_file)) if config_file.exists() else {}
config['hotkey_ctrl'] = HOTKEY_CTRL
config['hotkey_alt'] = HOTKEY_ALT
config['hotkey_shift'] = HOTKEY_SHIFT
config['hotkey_cmd'] = HOTKEY_CMD
json.dump(config, open(config_file, 'w'), indent=2)

parts = []
if HOTKEY_CTRL: parts.append('Ctrl')
if HOTKEY_ALT: parts.append('Alt')
if HOTKEY_SHIFT: parts.append('Shift')
if HOTKEY_CMD: parts.append('Cmd')
print(f'Hotkey changed to: {\" + \".join(parts)}')
print('Restart the daemon for changes to take effect.')
"
```

## Change Output Mode

- `keyboard` - Types text directly (default)
- `clipboard` - Copies to clipboard and pastes

```bash
python3 -c "
import json
from pathlib import Path

# Change to 'keyboard' or 'clipboard'
OUTPUT_MODE = 'keyboard'

config_file = Path.home() / '.config' / 'voice-to-claude' / 'config.json'
config = json.load(open(config_file)) if config_file.exists() else {}
config['output_mode'] = OUTPUT_MODE
json.dump(config, open(config_file, 'w'), indent=2)
print(f'Output mode changed to: {OUTPUT_MODE}')
print('Restart the daemon for changes to take effect.')
"
```

## Restart Daemon After Changes

After changing configuration, restart the daemon:

```bash
python3 -c "
import sys
sys.path.insert(0, '${CLAUDE_PLUGIN_ROOT}/src')
from voice_to_claude.daemon import stop_daemon, start_daemon
import time
stop_daemon()
time.sleep(0.5)
start_daemon(background=True)
"
```
