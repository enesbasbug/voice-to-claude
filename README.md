# Voice-to-Claude

High-quality voice dictation for Claude Code using whisper.cpp with Metal GPU acceleration.

## Features

- **Local Processing**: 100% offline, no cloud APIs, no data leaves your device
- **Metal Acceleration**: GPU-accelerated transcription on Apple Silicon
- **Multiple Models**: Choose from tiny (~0.5s) to large-v3 (best quality)
- **Hotkey Activation**: Hold Ctrl+Alt to record, release to transcribe
- **Auto-Start**: Daemon starts automatically when Claude Code launches

## Requirements

- macOS (Apple Silicon recommended for Metal acceleration)
- Python 3.10+
- Claude Code CLI

## Installation

### 1. Install the Plugin

```bash
# Clone or copy the plugin to your plugins directory
cp -r voice-to-claude ~/.claude/plugins/

# Or use Claude Code's plugin install command
/plugin install voice-to-claude
```

### 2. Run Setup

In Claude Code, run:

```
/voice-to-claude:setup
```

This will guide you through:
1. Installing Python dependencies
2. Building whisper.cpp with Metal support
3. Downloading a Whisper model (base recommended)
4. Configuring the daemon

### 3. Restart Claude Code

After setup, restart Claude Code. The daemon will start automatically.

## Usage

1. **Hold Ctrl+Alt** - Recording starts (you'll hear a sound)
2. **Speak** - Say what you want to dictate
3. **Release** - Text appears in Claude Code input

## Slash Commands

| Command | Description |
|---------|-------------|
| `/voice-to-claude:setup` | One-time setup wizard |
| `/voice-to-claude:status` | Check daemon status |
| `/voice-to-claude:config` | Change model, hotkey, or settings |

## Configuration

Configuration is stored at `~/.config/voice-to-claude/config.json`

### Available Models

| Model | Size | Speed | Use Case |
|-------|------|-------|----------|
| tiny | ~75MB | ~0.5s | Quick notes, simple phrases |
| base | ~142MB | ~1s | General use (recommended) |
| medium | ~1.5GB | ~2s | Better accuracy |
| large-v3 | ~3GB | ~3s | Best quality, complex audio |

### Hotkey Options

Default: Ctrl+Alt (hold both to record)

You can change to any combination of:
- Ctrl (Control)
- Alt (Option)
- Shift
- Cmd (Command)

### Output Modes

- `keyboard` - Types text directly (default)
- `clipboard` - Copies to clipboard and pastes

## Architecture

```
voice-to-claude/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── setup.md             # Setup wizard
│   ├── config.md            # Configuration
│   └── status.md            # Status check
├── hooks/
│   └── hooks.json           # Auto-start daemon
├── src/voice_to_claude/
│   ├── daemon.py            # Background service
│   ├── recorder.py          # Audio recording
│   ├── transcriber.py       # whisper.cpp integration
│   ├── keyboard.py          # Text injection
│   ├── config.py            # Settings management
│   └── sounds.py            # Audio feedback
├── scripts/
│   ├── setup.py             # Setup script
│   └── exec.py              # Entry point
├── pyproject.toml
└── README.md
```

## Troubleshooting

### Daemon not starting
```bash
# Check status
python3 ~/.config/voice-to-claude/check_status.py

# View logs
tail -50 ~/.config/voice-to-claude/daemon.log
```

### Microphone not working
1. Go to System Settings > Privacy & Security > Microphone
2. Enable Terminal (or the app running Claude Code)
3. Restart the daemon

### Model not found
```bash
cd ~/.local/share/voice-to-claude/whisper.cpp
./models/download-ggml-model.sh base
```

## Comparison with claude-stt

| Feature | voice-to-claude | claude-stt |
|---------|-----------------|------------|
| STT Engine | whisper.cpp (GGML) | Moonshine ONNX |
| GPU | Metal acceleration | CPU only |
| Models | Tiny/Base/Medium/Large-v3 | Fixed Moonshine |
| Quality | Higher accuracy | Faster but less accurate |
| Platform | macOS focused | Cross-platform |

## License

MIT License - see LICENSE file for details.

## Credits

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp) - Fast C++ implementation of OpenAI's Whisper
- [OpenAI Whisper](https://github.com/openai/whisper) - Original speech recognition model
