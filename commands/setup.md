---
description: Set up voice-to-claude (one-time setup)
---

# Voice-to-Claude Setup

You are helping the user set up voice-to-claude, a voice dictation plugin for Claude Code.

## What This Plugin Does

Voice-to-claude enables voice dictation directly into Claude Code using whisper.cpp with Metal GPU acceleration:

- **Hotkey**: Hold Ctrl+Alt, speak, release to transcribe
- **Engine**: whisper.cpp (GGML) with Metal acceleration
- **Privacy**: 100% local, no cloud APIs, no data leaves the device

## Setup Steps

Run these steps to complete setup:

### 1. Check Python Dependencies

First, check if the required Python packages are installed:

```bash
python3 -c "import sounddevice, numpy, scipy, pynput" 2>/dev/null && echo "Dependencies OK" || echo "Need to install dependencies"
```

If dependencies are missing, install them:

```bash
pip3 install sounddevice numpy scipy pynput
```

### 2. Clone and Build whisper.cpp

Check if whisper.cpp is already built:

```bash
ls ~/.local/share/voice-to-claude/whisper.cpp/build/bin/whisper-cli 2>/dev/null && echo "whisper.cpp OK" || echo "Need to build whisper.cpp"
```

If whisper.cpp needs to be built:

```bash
# Create directory
mkdir -p ~/.local/share/voice-to-claude
cd ~/.local/share/voice-to-claude

# Clone whisper.cpp
git clone https://github.com/ggerganov/whisper.cpp.git
cd whisper.cpp

# Build with Metal support (Apple Silicon GPU acceleration)
cmake -B build -DGGML_METAL=ON
cmake --build build -j

# Verify
./build/bin/whisper-cli --help | head -5
```

### 3. Download Whisper Model

Download the base model (recommended for balance of speed/quality):

```bash
cd ~/.local/share/voice-to-claude/whisper.cpp
./models/download-ggml-model.sh base
```

Available models (can download later via /voice-to-claude:config):
- `tiny` - ~75MB, fastest (~0.5s)
- `base` - ~142MB, balanced (~1s) **[RECOMMENDED]**
- `medium` - ~1.5GB, better quality (~2s)
- `large-v3` - ~3GB, best quality (~3s)

### 4. Grant Microphone Permission

The first time you record, macOS will ask for microphone permission. Grant it when prompted.

You can also pre-grant in: System Settings > Privacy & Security > Microphone > Enable Terminal

### 5. Save Configuration

After completing steps 1-4, run the setup script to save the configuration:

```bash
python3 "${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}/scripts/setup.py" --finalize
```

## Verification

After setup, verify everything works:

```bash
python3 -c "
from pathlib import Path
import json

config_file = Path.home() / '.config' / 'voice-to-claude' / 'config.json'
if config_file.exists():
    config = json.load(open(config_file))
    if config.get('setup_complete'):
        print('Setup complete!')
        print(f'  Model: {config.get(\"model\")}')
        print(f'  Hotkey: Ctrl+Alt (hold to record)')
    else:
        print('Setup not finalized. Run the finalize step.')
else:
    print('Config not found. Run setup steps above.')
"
```

## Usage After Setup

Once setup is complete:

1. **Restart Claude Code** - The daemon will auto-start via hook
2. **Hold Ctrl+Alt** - Start recording
3. **Speak** - Say what you want to dictate
4. **Release** - Text appears in Claude Code input

To manually control the daemon:
- `/voice-to-claude:status` - Check daemon status
- `/voice-to-claude:config` - Change model or hotkey
