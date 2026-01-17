---
description: Stop the voice dictation daemon
---

# Stop voice-to-claude Daemon

Stop the speech-to-text daemon.

## Instructions

When the user runs `/voice-to-claude:stop`:

### Step 1: Check daemon status

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon status
```

### Step 2: Stop if running

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon stop
```

### Step 3: Confirm stopped

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/exec.py daemon status
```

Show confirmation:
```
voice-to-claude daemon stopped.

To restart: /voice-to-claude:start
```
