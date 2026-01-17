#!/usr/bin/env python3
"""Entry point for running voice-to-claude commands."""

import os
import sys

# Add src directory to path
script_dir = os.path.dirname(os.path.abspath(__file__))
plugin_root = os.path.dirname(script_dir)
src_dir = os.path.join(plugin_root, "src")
sys.path.insert(0, src_dir)

if __name__ == "__main__":
    # Support running as: python exec.py -m voice_to_claude.daemon start
    if len(sys.argv) >= 3 and sys.argv[1] == "-m":
        module_name = sys.argv[2]
        sys.argv = [module_name] + sys.argv[3:]

        if module_name == "voice_to_claude.daemon":
            from voice_to_claude.daemon import main
            main()
        else:
            print(f"Unknown module: {module_name}")
            sys.exit(1)
    else:
        print("Usage: python exec.py -m voice_to_claude.daemon [start|stop|status|restart]")
        sys.exit(1)
