# Voice-to-Claude

High-quality voice dictation for Claude Code using whisper.cpp with Metal GPU acceleration.

[![License](https://img.shields.io/github/license/enesbasbug/voice-to-claude)](LICENSE)
[![Stars](https://img.shields.io/github/stars/enesbasbug/voice-to-claude)](https://github.com/enesbasbug/voice-to-claude/stargazers)

## Install

Inside Claude Code, run the following commands:

**Step 1: Add the marketplace**
```
/plugin marketplace add enesbasbug/voice-to-claude
```

**Step 2: Install the plugin**
```
/plugin install voice-to-claude
```

**Step 3: Run setup**
```
/voice-to-claude:setup
```

Done! Hold **Ctrl+Alt** to record, release to transcribe.

> **Note**: Setup builds whisper.cpp with Metal support (~3-5 min first time),
> downloads the base model (~142MB), and configures the daemon.

---

## What is Voice-to-Claude?

Voice-to-Claude gives you high-quality voice input directly into Claude Code using whisper.cpp with Metal GPU acceleration.

| What You Get | Why It Matters |
|--------------|----------------|
| **Local processing** | All audio processed on-device using whisper.cpp |
| **Metal GPU acceleration** | Fast transcription on Apple Silicon |
| **Multiple models** | Choose quality/speed tradeoff (tiny to large-v3) |
| **Push-to-talk** | Hold hotkey to record, release to transcribe |
| **Privacy first** | No audio or text sent to external services |

### How It Works

```
Hold Ctrl+Alt → start recording
        ↓
Audio captured from microphone
        ↓
Release Ctrl+Alt → stop recording
        ↓
whisper.cpp transcribes locally (~1s for base model)
        ↓
Text inserted into Claude Code input
```

**Key details:**
- Uses whisper.cpp (GGML) for high-quality transcription
- Metal acceleration for fast GPU inference on macOS
- Keyboard injection or clipboard fallback
- Native system sounds for audio feedback

---

## Configuration

Customize your settings anytime:

```
/voice-to-claude:config
```

### Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `model` | `tiny`, `base`, `medium`, `large-v3` | `base` | Whisper model |
| `hotkey` | Key combo | `ctrl+alt` | Trigger recording |
| `output_mode` | `keyboard`, `clipboard` | `keyboard` | How text is inserted |
| `sound_effects` | `true`, `false` | `true` | Play audio feedback |

### Available Models

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| tiny | ~75MB | ~0.5s | Basic |
| base | ~142MB | ~1s | Good (default) |
| medium | ~1.5GB | ~2s | Better |
| large-v3 | ~3GB | ~3s | Best |

Settings stored in `~/.config/voice-to-claude/config.json`.

---

## Requirements

- **macOS** (Apple Silicon recommended for Metal acceleration)
- **Python 3.10+**
- **cmake** and **Xcode Command Line Tools** (for building whisper.cpp)
- **~200MB-3GB disk space** depending on model

### Prerequisites

```bash
# Install build tools (if not already installed)
brew install cmake
xcode-select --install
```

---

## Commands

| Command | Description |
|---------|-------------|
| `/voice-to-claude:setup` | First-time setup: build whisper.cpp, download model |
| `/voice-to-claude:start` | Start the voice dictation daemon |
| `/voice-to-claude:stop` | Stop the daemon |
| `/voice-to-claude:status` | Show daemon status and configuration |
| `/voice-to-claude:config` | Change settings (model, hotkey, etc.) |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No audio input | Check microphone permissions in System Settings > Privacy & Security > Microphone |
| Keyboard injection not working | Grant Accessibility permissions in System Settings > Privacy & Security > Accessibility |
| Build failed | Ensure cmake and Xcode tools are installed: `brew install cmake && xcode-select --install` |
| Model not loading | Run `/voice-to-claude:setup` to download. Check disk space |
| Hotkey not triggering | Check for conflicts with other apps. Try `/voice-to-claude:config` to change hotkey |

### Logs

```bash
tail -50 ~/.config/voice-to-claude/daemon.log
```

---

## Privacy

**All processing is local:**
- Audio captured from your microphone is processed entirely on-device
- whisper.cpp runs locally — no cloud API calls
- Audio is never sent anywhere, never stored
- Transcribed text only goes to Claude Code input or clipboard

**No telemetry or analytics.**

---

## Development

```bash
git clone https://github.com/enesbasbug/voice-to-claude
cd voice-to-claude

# Test locally without marketplace install
claude --plugin-dir /path/to/voice-to-claude
```

---

## License

MIT — see [LICENSE](LICENSE)

---

## Credits

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp) - Fast C++ implementation of OpenAI's Whisper
- [OpenAI Whisper](https://github.com/openai/whisper) - Original speech recognition model
