#!/bin/bash
# Fix for node-pty and other native Node modules build errors in Termux
# This script creates the necessary GYP configuration to resolve the
# "Undefined variable android_ndk_path" error

set -e

echo "================================================"
echo "  Termux Node-GYP Build Error Fix"
echo "================================================"
echo ""

# Create .gyp directory if it doesn't exist
echo "[1/3] Creating .gyp directory..."
mkdir -p ~/.gyp

# Create include.gypi with android_ndk_path configuration
echo "[2/3] Creating GYP configuration file..."
cat > ~/.gyp/include.gypi << 'EOF'
{
  "variables": {
    "android_ndk_path": ""
  }
}
EOF

# Verify the file was created
if [ -f ~/.gyp/include.gypi ]; then
    echo "✓ Configuration file created successfully at: ~/.gyp/include.gypi"
else
    echo "✗ Failed to create configuration file"
    exit 1
fi

echo "[3/3] Displaying configuration..."
echo ""
cat ~/.gyp/include.gypi
echo ""

echo "================================================"
echo "✓ Fix applied successfully!"
echo "================================================"
echo ""
echo "You can now install packages with native modules:"
echo "  npm install"
echo ""
echo "If you still encounter issues, try:"
echo "  1. Clear npm cache: npm cache clean --force"
echo "  2. Remove node_modules: rm -rf node_modules"
echo "  3. Remove package-lock.json: rm package-lock.json"
echo "  4. Install again: npm install"
echo ""
echo "For more information, see: TERMUX_NODE_PTY_FIX.md"
echo ""
