---
name: voice-to-claude
description: High-quality voice dictation for Claude Code using whisper.cpp with Metal GPU acceleration. Use this when the user wants voice input, speech-to-text, or dictation. Hotkey is Ctrl+Alt (hold to record, release to transcribe).
---

# Voice-to-Claude

Voice dictation for Claude Code using whisper.cpp with Metal GPU acceleration.

## How It Works

1. **Hold Ctrl+Alt** - Recording starts
2. **Speak** - Say what you want to dictate
3. **Release** - Text appears in Claude Code input

100% local processing. No cloud APIs. No data leaves your device.

## Setup (One-Time)

Run the setup script to install dependencies, build whisper.cpp, and download a model:

```bash
bash ~/.claude/skills/voice-to-claude/scripts/setup.sh
```

This will:
1. Install Python dependencies (sounddevice, numpy, scipy, pynput)
2. Clone and build whisper.cpp with Metal support
3. Download the base model (~142MB)
4. Save configuration

## Start the Daemon

After setup, start the voice dictation daemon:

```bash
bash ~/.claude/skills/voice-to-claude/scripts/start.sh
```

## Check Status

```bash
bash ~/.claude/skills/voice-to-claude/scripts/status.sh
```

## Stop the Daemon

```bash
bash ~/.claude/skills/voice-to-claude/scripts/stop.sh
```

## Configuration

Config is stored at `~/.config/voice-to-claude/config.json`

### Available Models

| Model | Size | Speed | Use Case |
|-------|------|-------|----------|
| tiny | ~75MB | ~0.5s | Quick notes |
| base | ~142MB | ~1s | General use (default) |
| medium | ~1.5GB | ~2s | Better accuracy |
| large-v3 | ~3GB | ~3s | Best quality |

To change model:
```bash
bash ~/.claude/skills/voice-to-claude/scripts/config.sh model medium
```

### Hotkey Options

Default: Ctrl+Alt (hold both to record)

To change hotkey:
```bash
# Use Ctrl+Shift instead
bash ~/.claude/skills/voice-to-claude/scripts/config.sh hotkey ctrl+shift
```

## Troubleshooting

### Daemon not starting
```bash
tail -50 ~/.config/voice-to-claude/daemon.log
```

### Microphone not working
1. Go to System Settings > Privacy & Security > Microphone
2. Enable Terminal
3. Restart the daemon
