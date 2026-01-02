# Open Interpreter on Android - Troubleshooting Guide

This comprehensive troubleshooting guide covers common issues and solutions for running Open Interpreter on Termux.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Runtime Errors](#runtime-errors)
- [Performance Problems](#performance-problems)
- [API and Authentication](#api-and-authentication)
- [Storage and Permissions](#storage-and-permissions)
- [Network Issues](#network-issues)
- [Advanced Debugging](#advanced-debugging)

---

## Installation Issues

### Package Installation Fails

**Problem:** `pkg install` commands fail with errors

**Solutions:**

```bash
# 1. Update package lists
pkg update

# 2. Fix broken packages
pkg upgrade

# 3. Clear package cache
pkg clean
pkg autoclean

# 4. Reinstall termux-tools
pkg install termux-tools

# 5. Check storage space
df -h
```

### Python Installation Problems

**Problem:** Python not found or wrong version

**Solutions:**

```bash
# Check current Python version
python --version

# Uninstall and reinstall Python
pkg uninstall python
pkg install python

# Set Python 3 as default
echo 'alias python=python3' >> ~/.bashrc
source ~/.bashrc

# Verify installation
which python
python --version
```

### pip Install Failures

**Problem:** `pip install open-interpreter` fails

**Common Errors and Fixes:**

#### Error: "Failed building wheel"
```bash
# Install build dependencies
pkg install build-essential python-dev

# Upgrade pip and setuptools
pip install --upgrade pip setuptools wheel

# Try installing again
pip install open-interpreter --no-cache-dir
```

#### Error: "No space left on device"
```bash
# Check available space
df -h

# Clean pip cache
pip cache purge

# Remove unused packages
pkg autoremove

# Install without cache
pip install open-interpreter --no-cache-dir
```

#### Error: "Permission denied"
```bash
# Don't use sudo in Termux!
# Install in user directory (default)
pip install --user open-interpreter

# Or install normally (Termux is single-user)
pip install open-interpreter
```

### Rust/Cargo Compilation Errors

**Problem:** Rust packages fail to compile

**Solution:**

```bash
# Ensure rust is properly installed
pkg install rust

# Set rust environment
export RUSTC_WRAPPER=""

# Retry installation
pip install open-interpreter --no-cache-dir
```

---

## Runtime Errors

### "Command not found: interpreter"

**Problem:** `interpreter` command not recognized after installation

**Solutions:**

```bash
# 1. Check if it's installed
pip list | grep open-interpreter

# 2. Find the installation location
find ~ -name interpreter -type f 2>/dev/null

# 3. Add Python bin to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4. Or use full path
python -m interpreter

# 5. Reinstall if necessary
pip uninstall open-interpreter
pip install open-interpreter
```

### "No module named 'interpreter'"

**Problem:** Python can't find the interpreter module

**Solutions:**

```bash
# 1. Verify Python version
python --version  # Should be 3.8+

# 2. Check installed packages
pip list | grep open-interpreter

# 3. Reinstall completely
pip uninstall open-interpreter
pip cache purge
pip install open-interpreter --no-cache-dir

# 4. Check for multiple Python installations
which python
which python3

# 5. Use the correct pip
python -m pip install open-interpreter
```

### Crashes or Unexpected Exits

**Problem:** Open Interpreter crashes randomly

**Solutions:**

```bash
# 1. Check for Out of Memory (OOM)
# Reduce context window in config
nano ~/.config/open-interpreter/config.yaml
# Set: context_window: 2048

# 2. Use a lighter model
interpreter --model gpt-3.5-turbo

# 3. Check for errors
interpreter --verbose

# 4. Clear any corrupted config
mv ~/.config/open-interpreter ~/.config/open-interpreter.backup
interpreter  # Will create new config

# 5. Update to latest version
pip install --upgrade open-interpreter
```

### "Failed to execute Python code"

**Problem:** Code execution fails inside Open Interpreter

**Solutions:**

```bash
# 1. Verify Python works
python -c "print('Hello')"

# 2. Check required packages
pip install --upgrade pip

# 3. Install common dependencies
pkg install python-numpy python-pandas

# 4. Check file permissions
ls -la ~/.local/bin/interpreter
chmod +x ~/.local/bin/interpreter

# 5. Test with safe mode
interpreter --safe_mode ask
```

---

## Performance Problems

### Slow Response Times

**Problem:** Open Interpreter is very slow

**Optimizations:**

```bash
# 1. Use faster model
interpreter --model gpt-3.5-turbo  # Much faster than GPT-4

# 2. Reduce context window
# Edit config: ~/.config/open-interpreter/config.yaml
context_window: 2048
max_tokens: 1000

# 3. Close other apps to free RAM
# Check current RAM usage
free -m

# 4. Use local model for simple tasks
interpreter --local --model ollama/llama2

# 5. Disable unnecessary features
# In config.yaml:
safe_mode: "off"  # Skip confirmation prompts
```

### High Memory Usage

**Problem:** Termux or device running out of memory

**Solutions:**

```bash
# 1. Check memory usage
free -m
top

# 2. Restart Termux
exit
# Close and reopen Termux app

# 3. Clear Python cache
find ~ -type d -name __pycache__ -exec rm -r {} + 2>/dev/null

# 4. Limit context window
# Edit: ~/.config/open-interpreter/config.yaml
context_window: 2048  # Lower for devices with <6GB RAM

# 5. Use streaming for large responses
# In config.yaml:
stream: true
```

### Battery Drain

**Problem:** Excessive battery usage

**Solutions:**

```bash
# 1. Use local models instead of API calls
interpreter --local

# 2. Reduce API calls frequency
# Use manual approval mode
interpreter --auto_run false

# 3. Lower screen brightness
# Use a darker terminal theme

# 4. Acquire wakelock (prevents CPU throttling during long tasks)
termux-wake-lock

# Release when done
termux-wake-unlock
```

---

## API and Authentication

### "Invalid API Key" Errors

**Problem:** API key not recognized or invalid

**Solutions:**

```bash
# 1. Verify API key is set
echo $OPENAI_API_KEY
echo $ANTHROPIC_API_KEY

# 2. Check for extra spaces or quotes
# Should be exactly the key, no quotes in the export
export OPENAI_API_KEY=sk-abc123...  # Correct
# Not: export OPENAI_API_KEY='sk-abc123...'  # Can cause issues

# 3. Make it permanent
echo "export OPENAI_API_KEY=your-actual-key" >> ~/.bashrc
source ~/.bashrc

# 4. Test the API key
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# 5. Use config file instead
nano ~/.config/open-interpreter/config.yaml
# Add: api_key: "your-key-here"
```

### "Rate limit exceeded"

**Problem:** Too many API requests

**Solutions:**

```bash
# 1. Wait a few minutes before retrying

# 2. Use a different model or provider
interpreter --model gpt-3.5-turbo  # Lower rate limits

# 3. Implement delays between requests
# In config.yaml:
rpm: 3  # Requests per minute limit

# 4. Check your OpenAI account
# Visit: https://platform.openai.com/account/rate-limits

# 5. Switch to Anthropic or local model temporarily
export ANTHROPIC_API_KEY=your-key
interpreter --model claude-3-5-sonnet-20241022
```

### "Connection timeout" / API unreachable

**Problem:** Can't connect to API

**Solutions:**

```bash
# 1. Check internet connection
ping -c 3 8.8.8.8

# 2. Test API endpoint
ping -c 3 api.openai.com

# 3. Check if using VPN or proxy
# May need to configure proxy settings

# 4. Increase timeout in config
# ~/.config/open-interpreter/config.yaml
request_timeout: 120  # seconds

# 5. Use different network
# Try mobile data vs WiFi
```

---

## Storage and Permissions

### "Permission denied" When Accessing Files

**Problem:** Can't read/write files

**Solutions:**

```bash
# 1. Setup storage permissions
termux-setup-storage
# Grant permission in Android dialog

# 2. Verify storage is mounted
ls ~/storage/

# 3. Check file permissions
ls -la path/to/file

# 4. Fix ownership
# Not needed in Termux (single user)

# 5. Use correct paths
# ✅ Correct: ~/storage/shared/Documents/file.txt
# ❌ Wrong: /sdcard/Documents/file.txt
```

### Can't Access SD Card or External Storage

**Problem:** External storage not accessible

**Solutions:**

```bash
# 1. Run storage setup
termux-setup-storage

# 2. Check available storage locations
ls ~/storage/
# Should show: dcim, downloads, shared, etc.

# 3. Android 11+ limitations
# Some paths may not be accessible
# Use ~/storage/shared/ for most files

# 4. Verify permissions in Android settings
# Settings > Apps > Termux > Permissions > Files

# 5. Try alternative path
# ~/storage/downloads/ for downloads folder
```

### Config File Not Found/Created in Wrong Location

**Problem:** Config appears in Downloads instead of config directory

**Solutions:**

```bash
# 1. Understand the issue
# This is an Android/Termux limitation with external editors

# 2. Use command-line editor instead
nano ~/.config/open-interpreter/config.yaml
# Or
vim ~/.config/open-interpreter/config.yaml

# 3. Manually create config directory
mkdir -p ~/.config/open-interpreter/

# 4. Copy config to correct location if needed
cp ~/storage/downloads/config.yaml ~/.config/open-interpreter/

# 5. Enable external apps (optional)
nano ~/.termux/termux.properties
# Add: allow-external-apps = true
```

---

## Network Issues

### "SSLError" or Certificate Errors

**Problem:** SSL/TLS verification failures

**Solutions:**

```bash
# 1. Update CA certificates
pkg install ca-certificates

# 2. Update OpenSSL
pkg upgrade openssl

# 3. Set certificate path
export SSL_CERT_FILE=/system/etc/security/cacerts
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# 4. Update Python certificates
pip install --upgrade certifi

# 5. Last resort (not recommended for production)
# In config.yaml:
# verify_ssl: false
```

### Slow Download Speeds

**Problem:** Packages download very slowly

**Solutions:**

```bash
# 1. Change Termux mirror
termux-change-repo
# Select a closer/faster mirror

# 2. Check network connection
ping -c 5 google.com

# 3. Try different DNS
echo "nameserver 8.8.8.8" > $PREFIX/etc/resolv.conf
echo "nameserver 1.1.1.1" >> $PREFIX/etc/resolv.conf

# 4. Use WiFi instead of mobile data (or vice versa)

# 5. Pause and resume download
# For pip: Use --retries flag
pip install --retries 5 open-interpreter
```

---

## Advanced Debugging

### Enable Verbose Logging

```bash
# Start with debug output
interpreter --verbose

# Or in Python
python -m interpreter --debug

# Check logs location
ls ~/.config/open-interpreter/logs/
```

### Collect Diagnostic Information

```bash
# System info
./check-system.sh

# Package versions
pip list > ~/installed_packages.txt

# Python version
python --version > ~/python_version.txt

# Environment variables
env | grep -i 'key\|path\|python' > ~/env_vars.txt

# Termux info
pkg list-installed > ~/termux_packages.txt
```

### Reset to Clean State

```bash
# 1. Backup important data first!

# 2. Remove Open Interpreter
pip uninstall open-interpreter

# 3. Clear all caches
pip cache purge
pkg clean

# 4. Remove config
mv ~/.config/open-interpreter ~/.config/open-interpreter.backup

# 5. Reinstall fresh
pip install open-interpreter

# 6. Test
interpreter --version
```

### Check for Conflicts

```bash
# List all Python packages
pip list

# Look for conflicting versions
pip check

# Reinstall specific package
pip install --force-reinstall package-name

# Freeze current working state
pip freeze > requirements.txt
```

---

## Device-Specific Issues

### Samsung Galaxy Fold 6 / Fold Series

**Issue:** Screen rotation or multi-window issues

**Solution:**
```bash
# Set fixed screen dimensions
# Add to ~/.bashrc:
export LINES=40
export COLUMNS=120
```

### Low-End Devices (<4GB RAM)

**Issue:** Constant crashes or OOM errors

**Solutions:**
```bash
# 1. Use lightest model
interpreter --model gpt-3.5-turbo

# 2. Minimal config
# ~/.config/open-interpreter/config.yaml:
context_window: 1024
max_tokens: 500
stream: true

# 3. Close all other apps

# 4. Consider using UserLand with swap file
```

---

## Getting Additional Help

### Check System Status

```bash
# Run the system checker
./check-system.sh

# Check logs
cat ~/.config/open-interpreter/logs/latest.log
```

### Report Issues

If you're still experiencing problems:

1. **Gather information:**
   ```bash
   interpreter --version
   python --version
   uname -a
   ```

2. **Check existing issues:**
   - [Open Interpreter Issues](https://github.com/KillianLucas/open-interpreter/issues)
   - [This Repo Issues](https://github.com/THEFIG06/open-interpreter-termux/issues)

3. **Create a new issue with:**
   - Device model and RAM
   - Android version
   - Termux version
   - Python version
   - Error messages (full output)
   - Steps to reproduce

---

## Quick Fixes Reference

| Problem | Quick Fix |
|---------|-----------|
| Command not found | `export PATH="$HOME/.local/bin:$PATH"` |
| Package install fails | `pkg clean && pkg update` |
| Permission denied | `termux-setup-storage` |
| Slow performance | `interpreter --model gpt-3.5-turbo` |
| Out of memory | Lower context_window in config |
| API key issues | `echo $OPENAI_API_KEY` to verify |
| SSL errors | `pkg install ca-certificates` |
| Can't access files | Use `~/storage/shared/` paths |
| Config in wrong place | Use `nano ~/.config/open-interpreter/config.yaml` |
| Import errors | `pip install --force-reinstall open-interpreter` |

---

**Need more help?** Check the [main README](../README.md) or run `./check-system.sh` for automated diagnostics.
