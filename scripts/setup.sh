#!/bin/bash
# Voice-to-Claude Setup Script

set -e

SKILL_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
INSTALL_DIR="$HOME/.local/share/voice-to-claude"
CONFIG_DIR="$HOME/.config/voice-to-claude"

echo "========================================"
echo "Voice-to-Claude Setup"
echo "========================================"
echo ""

# Step 1: Check/Install Python dependencies
echo "[1/4] Checking Python dependencies..."
if python3 -c "import sounddevice, numpy, scipy, pynput" 2>/dev/null; then
    echo "  ✓ Python dependencies OK"
else
    echo "  Installing Python dependencies..."
    pip3 install sounddevice numpy scipy pynput
    echo "  ✓ Python dependencies installed"
fi

# Step 2: Build whisper.cpp
echo ""
echo "[2/4] Setting up whisper.cpp..."
mkdir -p "$INSTALL_DIR"

if [ -f "$INSTALL_DIR/whisper.cpp/build/bin/whisper-cli" ]; then
    echo "  ✓ whisper.cpp already built"
else
    echo "  Cloning whisper.cpp..."
    cd "$INSTALL_DIR"
    if [ ! -d "whisper.cpp" ]; then
        git clone https://github.com/ggerganov/whisper.cpp.git
    fi

    echo "  Building with Metal support (this may take a few minutes)..."
    cd whisper.cpp
    cmake -B build -DGGML_METAL=ON
    cmake --build build -j

    if [ -f "build/bin/whisper-cli" ]; then
        echo "  ✓ whisper.cpp built successfully"
    else
        echo "  ✗ Build failed"
        exit 1
    fi
fi

# Step 3: Download model
echo ""
echo "[3/4] Downloading Whisper model..."
cd "$INSTALL_DIR/whisper.cpp"

if [ -f "models/ggml-base.bin" ]; then
    echo "  ✓ Base model already downloaded"
else
    echo "  Downloading base model (~142MB)..."
    ./models/download-ggml-model.sh base
    echo "  ✓ Base model downloaded"
fi

# Step 4: Save configuration
echo ""
echo "[4/4] Saving configuration..."
mkdir -p "$CONFIG_DIR"

# Copy Python source files
echo "  Copying Python modules..."
cp -r "$SKILL_DIR/src" "$INSTALL_DIR/"

cat > "$CONFIG_DIR/config.json" << EOF
{
  "whisper_cpp_path": "$INSTALL_DIR/whisper.cpp/build/bin/whisper-cli",
  "models_dir": "$INSTALL_DIR/whisper.cpp/models",
  "model": "base",
  "hotkey_ctrl": true,
  "hotkey_alt": true,
  "hotkey_shift": false,
  "hotkey_cmd": false,
  "output_mode": "keyboard",
  "sound_effects": true,
  "max_recording_seconds": 60,
  "setup_complete": true
}
EOF

echo "  ✓ Configuration saved"

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "To start voice dictation:"
echo "  bash ~/.claude/skills/voice-to-claude/scripts/start.sh"
echo ""
echo "Then hold Ctrl+Alt and speak!"
echo ""
