---
description: Set up voice-to-claude - install dependencies, build whisper.cpp, download model
---

# voice-to-claude Setup

This command guides users through setting up voice-to-claude with whisper.cpp for high-quality local speech recognition.

## Instructions

The setup script will automatically check prerequisites and guide you through installation.

### Step 1: Run Setup Script

Once prerequisites are confirmed, run the setup script:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/setup.py
```

The setup script will automatically:
- Check Python version (3.10+ required) - any 3.10, 3.11, or 3.12 works
- Create a local virtual environment (`.venv`) in the plugin directory
- Install Python dependencies in the venv (isolated, no conflicts with system Python)
- Build whisper.cpp with Metal support (~3-5 minutes first time)
- Download the base Whisper model (~142MB)
- Configure the daemon

**Note:** If Python 3.10+ is not found, the script will show installation instructions.

### Step 2: Handle Common Errors

**"Microphone permission denied" (macOS):**
```
macOS requires Microphone permission for audio recording.

1. Open System Settings > Privacy & Security > Microphone
2. Find your terminal app (Terminal, iTerm, etc.) and enable it
3. Re-run: /voice-to-claude:setup
```

**"Accessibility permission needed" (macOS):**
```
macOS requires Accessibility permission for keyboard input.

1. Open System Settings > Privacy & Security > Accessibility
2. Find your terminal app and enable it
3. Re-run: /voice-to-claude:start
```

**cmake or build errors:**
```bash
# Ensure Xcode tools are installed
xcode-select --install

# Try rebuilding
cd ~/.local/share/voice-to-claude/whisper.cpp
rm -rf build
cmake -B build -DGGML_METAL=ON
cmake --build build -j
```

**PortAudio errors:**
```bash
brew install portaudio
```

### Success

When setup completes successfully, you'll see:
```
Setup Complete!
To start voice dictation:
  /voice-to-claude:start

Then hold Ctrl+Alt and speak!
```

Use `/voice-to-claude:start` to start the daemon.
