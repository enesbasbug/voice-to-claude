#!/usr/bin/env python3
"""Setup script for voice-to-claude plugin."""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def get_config_path():
    """Get path to config file."""
    return Path.home() / ".config" / "voice-to-claude" / "config.json"


def get_whisper_dir():
    """Get path to whisper.cpp directory."""
    return Path.home() / ".local" / "share" / "voice-to-claude" / "whisper.cpp"


def load_config():
    """Load existing config or return empty dict."""
    config_path = get_config_path()
    if config_path.exists():
        return json.load(open(config_path))
    return {}


def save_config(config):
    """Save config to file."""
    config_path = get_config_path()
    config_path.parent.mkdir(parents=True, exist_ok=True)
    json.dump(config, open(config_path, "w"), indent=2)


def check_python_deps():
    """Check if Python dependencies are installed."""
    deps = ["sounddevice", "numpy", "scipy", "pynput"]
    missing = []
    for dep in deps:
        try:
            __import__(dep)
        except ImportError:
            missing.append(dep)
    return missing


def check_whisper_cpp():
    """Check if whisper.cpp is built."""
    whisper_cli = get_whisper_dir() / "build" / "bin" / "whisper-cli"
    return whisper_cli.exists()


def check_model(model_name="base"):
    """Check if a model is downloaded."""
    models_dir = get_whisper_dir() / "models"
    model_files = {
        "tiny": "ggml-tiny.bin",
        "base": "ggml-base.bin",
        "medium": "ggml-medium.bin",
        "large-v3": "ggml-large-v3.bin"
    }
    model_file = model_files.get(model_name, "ggml-base.bin")
    return (models_dir / model_file).exists()


def finalize_setup():
    """Finalize setup by saving configuration."""
    config = load_config()

    # Find whisper-cli
    whisper_cli = get_whisper_dir() / "build" / "bin" / "whisper-cli"
    if not whisper_cli.exists():
        print("Error: whisper-cli not found. Please build whisper.cpp first.")
        print(f"Expected at: {whisper_cli}")
        sys.exit(1)

    # Find models directory
    models_dir = get_whisper_dir() / "models"
    if not models_dir.exists():
        print("Error: models directory not found.")
        sys.exit(1)

    # Check for at least one model
    available_models = []
    for model in ["tiny", "base", "medium", "large-v3"]:
        model_files = {
            "tiny": "ggml-tiny.bin",
            "base": "ggml-base.bin",
            "medium": "ggml-medium.bin",
            "large-v3": "ggml-large-v3.bin"
        }
        if (models_dir / model_files[model]).exists():
            available_models.append(model)

    if not available_models:
        print("Error: No Whisper models found. Download at least one model.")
        print("  cd ~/.local/share/voice-to-claude/whisper.cpp")
        print("  ./models/download-ggml-model.sh base")
        sys.exit(1)

    # Set default model (prefer base, then first available)
    if "base" in available_models:
        default_model = "base"
    else:
        default_model = available_models[0]

    # Update config
    config.update({
        "whisper_cpp_path": str(whisper_cli),
        "models_dir": str(models_dir),
        "model": config.get("model", default_model),
        "hotkey_ctrl": config.get("hotkey_ctrl", True),
        "hotkey_alt": config.get("hotkey_alt", True),
        "hotkey_shift": config.get("hotkey_shift", False),
        "hotkey_cmd": config.get("hotkey_cmd", False),
        "output_mode": config.get("output_mode", "keyboard"),
        "sound_effects": config.get("sound_effects", True),
        "max_recording_seconds": config.get("max_recording_seconds", 60),
        "setup_complete": True
    })

    save_config(config)

    print("=" * 50)
    print("Voice-to-Claude Setup Complete!")
    print("=" * 50)
    print()
    print(f"Whisper CLI: {whisper_cli}")
    print(f"Models: {', '.join(available_models)}")
    print(f"Active Model: {config['model']}")
    print(f"Hotkey: Ctrl+Alt (hold to record)")
    print()
    print("Restart Claude Code to activate the daemon.")
    print("Then hold Ctrl+Alt and speak!")
    print()


def status():
    """Show setup status."""
    print("Voice-to-Claude Setup Status")
    print("=" * 50)

    # Check Python deps
    missing_deps = check_python_deps()
    if missing_deps:
        print(f"[ ] Python dependencies: Missing {', '.join(missing_deps)}")
    else:
        print("[x] Python dependencies: OK")

    # Check whisper.cpp
    if check_whisper_cpp():
        print("[x] whisper.cpp: Built")
    else:
        print("[ ] whisper.cpp: Not built")

    # Check models
    models_status = []
    for model in ["tiny", "base", "medium", "large-v3"]:
        if check_model(model):
            models_status.append(model)

    if models_status:
        print(f"[x] Models: {', '.join(models_status)}")
    else:
        print("[ ] Models: None downloaded")

    # Check config
    config = load_config()
    if config.get("setup_complete"):
        print("[x] Setup: Complete")
    else:
        print("[ ] Setup: Not finalized")

    print()


def main():
    parser = argparse.ArgumentParser(description="Voice-to-Claude setup")
    parser.add_argument("--status", action="store_true", help="Show setup status")
    parser.add_argument("--finalize", action="store_true", help="Finalize setup")

    args = parser.parse_args()

    if args.status:
        status()
    elif args.finalize:
        finalize_setup()
    else:
        status()
        print("Use --finalize to complete setup after building whisper.cpp and downloading a model.")


if __name__ == "__main__":
    main()
