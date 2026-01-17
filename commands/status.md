---
description: Check voice-to-claude daemon status
---

# Voice-to-Claude Status

Check the status of the voice-to-claude daemon.

## Check Status

Run this command to check daemon status:

```bash
python3 -c "
import os
import json
from pathlib import Path

config_dir = Path.home() / '.config' / 'voice-to-claude'
pid_file = config_dir / 'daemon.pid'
config_file = config_dir / 'config.json'

# Check if setup is complete
setup_complete = False
config = {}
if config_file.exists():
    config = json.load(open(config_file))
    setup_complete = config.get('setup_complete', False)

# Check if daemon is running
running = False
pid = None
if pid_file.exists():
    try:
        pid = int(pid_file.read_text().strip())
        os.kill(pid, 0)  # Check if process exists
        running = True
    except (ValueError, ProcessLookupError, OSError):
        pass

print('Voice-to-Claude Status')
print('=' * 40)

if not setup_complete:
    print('Status: NOT SET UP')
    print()
    print('Run /voice-to-claude:setup to complete setup.')
elif running:
    print(f'Status: RUNNING (PID: {pid})')
    print()
    print(f'Model: {config.get(\"model\", \"unknown\")}')
    hotkey_parts = []
    if config.get('hotkey_ctrl'): hotkey_parts.append('Ctrl')
    if config.get('hotkey_alt'): hotkey_parts.append('Alt')
    if config.get('hotkey_shift'): hotkey_parts.append('Shift')
    if config.get('hotkey_cmd'): hotkey_parts.append('Cmd')
    print(f'Hotkey: {\" + \".join(hotkey_parts) or \"None\"}')
    print(f'Output: {config.get(\"output_mode\", \"keyboard\")}')
    print()
    print('Hold the hotkey and speak to dictate.')
else:
    print('Status: STOPPED')
    print()
    print(f'Model: {config.get(\"model\", \"unknown\")}')
    print()
    print('The daemon should auto-start when Claude Code launches.')
    print('To manually start: python3 -m voice_to_claude.daemon start')
"
```

## Manual Daemon Control

If needed, you can manually control the daemon:

**Start daemon:**
```bash
cd ~/.local/share/voice-to-claude
python3 -c "
import sys
sys.path.insert(0, '${CLAUDE_PLUGIN_ROOT}/src')
from voice_to_claude.daemon import start_daemon
start_daemon(background=True)
"
```

**Stop daemon:**
```bash
python3 -c "
import sys
sys.path.insert(0, '${CLAUDE_PLUGIN_ROOT}/src')
from voice_to_claude.daemon import stop_daemon
stop_daemon()
"
```

**View logs:**
```bash
tail -50 ~/.config/voice-to-claude/daemon.log
```
