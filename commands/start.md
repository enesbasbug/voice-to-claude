---
description: Start the voice dictation daemon
---

# Start voice-to-claude Daemon

Start the speech-to-text daemon for voice dictation.

## Instructions

When the user runs `/voice-to-claude:start`:

### Step 1: Check if setup is complete

```bash
test -f ~/.config/voice-to-claude/config.json && python3 -c "import json; c=json.load(open('$HOME/.config/voice-to-claude/config.json')); exit(0 if c.get('setup_complete') else 1)" && echo "SETUP_OK" || echo "SETUP_NEEDED"
```

- If output is `SETUP_NEEDED`: Tell user to run `/voice-to-claude:setup` first.
- If output is `SETUP_OK`: Proceed to Step 2.

### Step 2: Check daemon status

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon status
```

### Step 3: Start if not running

If daemon is not running:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon start --background
```

### Step 4: Confirm and show usage

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon status
```

Show usage reminder:
```
voice-to-claude daemon started.

Usage:
  Hotkey: Ctrl+Alt (hold to record, release to transcribe)

  1. Hold Ctrl+Alt - Recording starts
  2. Speak clearly
  3. Release - Text appears in input

Tips:
  - Speak in complete sentences for best accuracy
  - Use /voice-to-claude:config to change model or hotkey
  - Use /voice-to-claude:stop to stop the daemon
```
