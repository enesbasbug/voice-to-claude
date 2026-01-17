---
description: Set up voice-to-claude - install dependencies, build whisper.cpp, download model
---

# voice-to-claude Setup

This command guides users through setting up voice-to-claude with whisper.cpp for high-quality local speech recognition.

## Instructions

Follow these steps IN ORDER. Do not skip ahead.

### Step 1: Check Python Installation

Run this command to check Python version:

```bash
python3 --version 2>/dev/null || python --version 2>/dev/null || echo "NOT_FOUND"
```

**Evaluate the result:**

- If output is `NOT_FOUND` or command fails: Python is not installed. Go to Step 2.
- If version is 3.9.x or lower: Python is too old. Go to Step 2.
- If version is 3.10 or higher: Python is ready. Skip to Step 3.

### Step 2: Install/Upgrade Python (if needed)

If Python is missing or below 3.10:

**macOS:**
```bash
brew install python@3.12
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update && sudo apt install -y python3.12 python3.12-venv python3-pip
```

After installation, verify:
```bash
python3 --version
```

### Step 3: Check Build Tools (macOS)

whisper.cpp requires cmake and a C++ compiler:

```bash
command -v cmake >/dev/null && echo "cmake OK" || echo "cmake MISSING"
command -v clang++ >/dev/null && echo "clang++ OK" || echo "clang++ MISSING"
```

If cmake is missing:
```bash
brew install cmake
```

If clang++ is missing, install Xcode Command Line Tools:
```bash
xcode-select --install
```

### Step 4: Run Setup Script

Once prerequisites are confirmed, run the setup script:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/setup.py
```

The setup script will automatically:
1. Install Python dependencies (sounddevice, numpy, scipy, pynput)
2. Clone and build whisper.cpp with Metal GPU acceleration
3. Download the base Whisper model (~142MB)
4. Configure the daemon

**This may take 3-5 minutes** on first run (building whisper.cpp takes time).

### Step 5: Handle Common Errors

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
