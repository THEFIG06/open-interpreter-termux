# Fix for node-pty Build Error in Termux

## Problem

When installing packages that depend on `node-pty` (or other native Node modules) in Termux, you encounter this error:

```
gyp: Undefined variable android_ndk_path in binding.gyp while trying to load binding.gyp
```

This happens because `node-gyp` expects the `android_ndk_path` variable to be defined when building on Android, but it's not set in the Termux environment.

## Solution

There are two main approaches to fix this issue:

### Method 1: Create Global GYP Configuration (Recommended)

This method is cleaner and persists across installations.

1. Create the `.gyp` directory in your home folder:
```bash
mkdir -p ~/.gyp
```

2. Create the `include.gypi` file with the NDK path configuration:
```bash
cat > ~/.gyp/include.gypi << 'EOF'
{
  "variables": {
    "android_ndk_path": ""
  }
}
EOF
```

3. Now try installing your package again:
```bash
npm install
```

### Method 2: Edit node-gyp Configure Script

This method requires editing the node-gyp source after each installation.

1. Install node-gyp globally if not already installed:
```bash
npm install -g node-gyp
```

2. Find and edit the configure.js file:
```bash
# Find the path to node-gyp
npm root -g

# Edit the configure.js file (usually at: <npm-root>/node-gyp/lib/configure.js)
# Add this line after line 60 (in the configure function):
#   argv.push('-Dandroid_ndk_path=""')
```

## Quick Fix Script

Run this script to automatically apply Method 1:

```bash
#!/bin/bash
mkdir -p ~/.gyp
cat > ~/.gyp/include.gypi << 'EOF'
{
  "variables": {
    "android_ndk_path": ""
  }
}
EOF
echo "✓ GYP configuration created successfully!"
echo "You can now run 'npm install' to build native modules."
```

## Alternative: Using Termux NDK (Advanced)

If you need full NDK support for more complex builds:

1. Install termux-ndk (only for aarch64 and Android 9+):
```bash
pkg install termux-ndk
```

2. Set the NDK path in your `.gyp/include.gypi`:
```bash
cat > ~/.gyp/include.gypi << 'EOF'
{
  "variables": {
    "android_ndk_path": "/data/data/com.termux/files/usr"
  }
}
EOF
```

## Troubleshooting

### Issue: Still getting the same error

Try clearing npm cache and node_modules:
```bash
npm cache clean --force
rm -rf node_modules
rm package-lock.json
npm install
```

### Issue: Permission errors

Make sure you have the necessary build tools:
```bash
pkg install build-essential python nodejs
```

### Issue: Different error after applying fix

Some native modules may have additional requirements. Check the specific package documentation for Termux compatibility.

## Related Issues

- This issue affects multiple packages: `node-pty`, `sqlite3`, `node-canvas`, and others requiring node-gyp compilation
- The issue started appearing in recent Node.js versions on Termux
- Some packages may not be fully compatible with Termux/Android even after this fix

## References

- [GitHub Issue: node-pty binding.gyp problem](https://github.com/microsoft/node-pty/issues/665)
- [GitHub Issue: node-gyp on Termux](https://github.com/termux/termux-packages/issues/20717)
- [GitHub: termux-ndk project](https://github.com/lzhiyong/termux-ndk)
- [GitHub Issue: android_ndk_path variable problem](https://github.com/nodejs/gyp-next/issues/237)
