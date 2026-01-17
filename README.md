# Voice-to-Claude

High-quality voice dictation for Claude Code using whisper.cpp with Metal GPU acceleration.

## Features

- **Local Processing**: 100% offline, no cloud APIs, no data leaves your device
- **Metal Acceleration**: GPU-accelerated transcription on Apple Silicon
- **Multiple Models**: Choose from tiny (~0.5s) to large-v3 (best quality)
- **Hotkey Activation**: Hold Ctrl+Alt to record, release to transcribe

## Requirements

- macOS (Apple Silicon recommended for Metal acceleration)
- Python 3.10+
- Claude Code CLI

## Installation

### 1. Clone to Claude Code skills directory

```bash
git clone https://github.com/enesbasbug/voice-to-claude ~/.claude/skills/voice-to-claude
```

### 2. Restart Claude Code

```bash
claude
```

### 3. Run setup

In Claude Code, type `/voice-to-claude` and Claude will guide you through setup. Or run directly:

```bash
bash ~/.claude/skills/voice-to-claude/scripts/setup.sh
```

This will:
1. Install Python dependencies (sounddevice, numpy, scipy, pynput)
2. Clone and build whisper.cpp with Metal support
3. Download the base model (~142MB)

### 4. Start the daemon

```bash
bash ~/.claude/skills/voice-to-claude/scripts/start.sh
```

## Usage

1. **Hold Ctrl+Alt** - Recording starts (you'll hear a sound)
2. **Speak** - Say what you want to dictate
3. **Release** - Text appears in Claude Code input

## Commands

| Script | Description |
|--------|-------------|
| `scripts/setup.sh` | One-time setup (build whisper.cpp, download model) |
| `scripts/start.sh` | Start the daemon |
| `scripts/stop.sh` | Stop the daemon |
| `scripts/status.sh` | Check daemon status |
| `scripts/config.sh` | Change settings (model, hotkey, etc.) |

## Configuration

Config is stored at `~/.config/voice-to-claude/config.json`

### Available Models

| Model | Size | Speed | Use Case |
|-------|------|-------|----------|
| tiny | ~75MB | ~0.5s | Quick notes, simple phrases |
| base | ~142MB | ~1s | General use (default) |
| medium | ~1.5GB | ~2s | Better accuracy |
| large-v3 | ~3GB | ~3s | Best quality |

Change model:
```bash
bash ~/.claude/skills/voice-to-claude/scripts/config.sh model medium
```

### Hotkey Options

Default: Ctrl+Alt (hold both to record)

Change hotkey:
```bash
bash ~/.claude/skills/voice-to-claude/scripts/config.sh hotkey ctrl+shift
```

## Troubleshooting

### Daemon not starting
```bash
tail -50 ~/.config/voice-to-claude/daemon.log
```

### Microphone not working
1. Go to System Settings > Privacy & Security > Microphone
2. Enable Terminal (or your terminal app)
3. Restart the daemon

### Model not found
```bash
cd ~/.local/share/voice-to-claude/whisper.cpp
./models/download-ggml-model.sh base
```

## License

MIT License - see LICENSE file for details.

## Credits

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp) - Fast C++ implementation of OpenAI's Whisper
- [OpenAI Whisper](https://github.com/openai/whisper) - Original speech recognition model
