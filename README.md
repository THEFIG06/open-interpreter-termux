# [Open Interpreter](https://github.com/KillianLucas/open-interpreter) on Android

Run Open Interpreter on your Android device using [Termux](https://termux.dev/en/) - a powerful Android terminal emulator and Linux environment that works directly with no rooting or setup required. Perfect for high-performance devices like the Samsung Galaxy Fold 6!

<div align="center">

 | [日本語](docs/README_JP.md) | [English](README.md) |

</div>

---

## 🚀 Quick Start (Automated Installation)

**NEW!** We now have an automated setup script that handles everything for you:

```bash
# Download and run the setup script
curl -sL https://raw.githubusercontent.com/THEFIG06/open-interpreter-termux/main/setup.sh | bash
```

Or clone this repository and run:

```bash
git clone https://github.com/THEFIG06/open-interpreter-termux.git
cd open-interpreter-termux
chmod +x setup.sh
./setup.sh
```

The automated script will:
- ✅ Update all packages
- ✅ Install required dependencies
- ✅ Set up storage permissions
- ✅ Install Open Interpreter
- ✅ Create helper scripts
- ✅ Configure optimal settings for your device

**After installation, run:**
```bash
./setup-api-key.sh  # Set up your API keys
interpreter         # Start Open Interpreter
```

---

## 📋 Manual Installation

If you prefer manual installation or want more control:

### Prerequisites

1. **Install Termux**
   - Download from [GitHub Releases](https://github.com/termux/termux-app/releases) (v0.118.1 or later)
   - ⚠️ Do NOT use the Play Store version - it's outdated

2. **Install Termux:API** (Optional but recommended)
   - Download from [GitHub Releases](https://github.com/termux/termux-api/releases) (v0.50.1 or later)
   - Enables additional Android integration features

### Installation Steps

Open Termux and run the following commands:

#### 1. Update System Packages
```bash
yes | pkg update && yes | pkg upgrade
```

#### 2. Install Required Packages
```bash
yes | pkg install termux-api python python-pip cmake ninja patchelf build-essential matplotlib rust binutils libzmq git wget curl nano
```

**For high-end devices (8GB+ RAM)** - Install additional packages:
```bash
yes | pkg install numpy pandas scipy
```

#### 3. Setup Storage Permissions
```bash
termux-setup-storage
```
⚠️ Grant permission when prompted. If it fails, run the command again.

#### 4. Upgrade pip
```bash
pip install --upgrade pip
```

#### 5. Install Open Interpreter

**Standard installation:**
```bash
pip install open-interpreter
```

**For high-performance devices (12GB+ RAM):**
```bash
pip install "open-interpreter[local,os,safe]"
```

#### 6. Configure API Keys

Choose your AI provider:

**Option A: OpenAI (GPT-4, GPT-3.5)**
```bash
export OPENAI_API_KEY='your-openai-api-key-here'
echo "export OPENAI_API_KEY='your-openai-api-key-here'" >> ~/.bashrc
```

**Option B: Anthropic (Claude)**
```bash
export ANTHROPIC_API_KEY='your-anthropic-api-key-here'
echo "export ANTHROPIC_API_KEY='your-anthropic-api-key-here'" >> ~/.bashrc
```

**Option C: Local Models (No API key needed)**
```bash
# Install Ollama for local models
pkg install ollama
# Then use models like: interpreter --model ollama/llama2
```

#### 7. Start Open Interpreter
```bash
interpreter
```

---

## 🎯 Optimizations for High-End Devices

### Samsung Galaxy Fold 6 / Flagship Devices (8GB+ RAM)

Your device can handle advanced features! Here's how to optimize:

#### 1. Use Premium Models
```bash
# GPT-4o (recommended for best results)
interpreter --model gpt-4o

# Claude 3.5 Sonnet (excellent for coding)
interpreter --model claude-3-5-sonnet-20241022

# GPT-4 Turbo
interpreter --model gpt-4-turbo
```

#### 2. Increase Context Window
Edit your config file:
```bash
nano ~/.config/open-interpreter/config.yaml
```

Add/modify:
```yaml
model: "gpt-4o"
context_window: 8192  # Higher for 12GB+ RAM
max_tokens: 4000
temperature: 0.7
```

#### 3. Enable Auto-Run (Advanced Users)
```yaml
auto_run: true  # Automatically execute code (use with caution!)
safe_mode: "ask"  # Options: "off", "ask", "auto"
```

#### 4. Install ML/Data Science Libraries
```bash
pip install numpy pandas matplotlib scikit-learn scipy jupyter
```

---

## 🔧 System Requirements Checker

We've included a system checker to verify your setup:

```bash
chmod +x check-system.sh
./check-system.sh
```

This will:
- Check your device specifications
- Verify all required packages
- Recommend optimal settings
- Suggest improvements based on your hardware

---

## 🖥️ Using with UserLand

[UserLand](https://github.com/CypherpunkArmory/UserLand) is another option for running Linux on Android. Here's how to use Open Interpreter with UserLand:

### Setup in UserLand

1. **Install UserLand** from Play Store or F-Droid
2. **Create Ubuntu session** (recommended) or Debian
3. **Update system:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

4. **Install Python and dependencies:**
   ```bash
   sudo apt install -y python3 python3-pip git build-essential cmake
   pip3 install --upgrade pip
   pip3 install open-interpreter
   ```

5. **Set API key and run:**
   ```bash
   export OPENAI_API_KEY='your-key'
   interpreter
   ```

### Termux vs UserLand

| Feature | Termux | UserLand |
|---------|--------|----------|
| Performance | ⚡ Faster | Slower (emulation) |
| Setup | Easy | Moderate |
| Linux distro | Custom | Full Ubuntu/Debian |
| Storage access | Direct | Limited |
| Battery usage | Better | Higher |
| **Recommendation** | **Preferred** | Alternative |

**For best performance on Galaxy Fold 6, use Termux.**

---

## 🎨 Available Models & Providers

### Cloud Models (Require API Keys)

**OpenAI:**
- `gpt-4o` - Latest, most capable (recommended for 8GB+ RAM)
- `gpt-4-turbo` - Fast and powerful
- `gpt-3.5-turbo` - Fast and economical

**Anthropic:**
- `claude-3-5-sonnet-20241022` - Excellent for coding
- `claude-3-opus` - Most capable
- `claude-3-sonnet` - Balanced

**Others:**
- `groq/mixtral-8x7b-32768` - Fast inference via Groq
- `together/llama-3-70b` - Via Together.ai

### Local Models (No API Key)

Install Ollama and run models locally:
```bash
pkg install ollama
ollama pull llama2
interpreter --model ollama/llama2
```

Popular local models:
- `ollama/llama2` - General purpose
- `ollama/codellama` - Code-focused
- `ollama/mistral` - Efficient and capable

---

## 📱 Termux Configuration

### Enable External Apps

Edit Termux properties to allow external app integration:

```bash
nano ~/.termux/termux.properties
```

Add or uncomment:
```properties
allow-external-apps = true

# Optional: Extra keys for easier terminal usage
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
```

Reload configuration:
```bash
termux-reload-settings
```

### Configure Open Interpreter

The config file is located at:
```
~/.config/open-interpreter/config.yaml
```

**NOT** in `~/Downloads/config.yaml` (Android/Termux limitation)

Edit with:
```bash
nano ~/.config/open-interpreter/config.yaml
```

Or use the interactive config:
```bash
interpreter --config
```

---

## 💡 Usage Tips & Tricks

### Essential Commands

```bash
# Start with specific model
interpreter --model gpt-4o

# Use local mode (offline with local model)
interpreter --local

# Start in safe mode
interpreter --safe_mode ask

# Set custom temperature
interpreter --temperature 0.7

# Open config editor
interpreter --config

# Check version
interpreter --version
```

### Keyboard Shortcuts in Termux

- `Ctrl + C` - Stop current process (press twice to exit chat)
- `Ctrl + D` - Exit Open Interpreter
- `Volume Up + Q` - Show extra keys
- `Volume Up + K` - Toggle keyboard
- `Volume Up + V` - Paste

### Exiting Open Interpreter

**Method 1:** Press `Ctrl + C` twice
**Method 2:** Type `exit` or `quit`
**Method 3:** Press `Ctrl + D`

### Saving Conversations

```bash
# Start with conversation logging
interpreter --conversations

# View past conversations
interpreter --conversations list
```

---

## 🚨 Troubleshooting

### Common Issues

#### "Command not found: interpreter"
```bash
# Solution: Add Python bin to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### "No module named 'interpreter'"
```bash
# Solution: Reinstall Open Interpreter
pip uninstall open-interpreter
pip install open-interpreter --no-cache-dir
```

#### "Permission denied" errors
```bash
# Solution: Fix permissions
termux-setup-storage
# Grant permission and run again
```

#### Slow performance
```bash
# Solutions:
# 1. Use a faster model
interpreter --model gpt-3.5-turbo

# 2. Reduce context window
# Edit ~/.config/open-interpreter/config.yaml
# Set context_window: 2048

# 3. Close other apps to free RAM
```

#### "Failed to execute Python code"
```bash
# Solution: Ensure Python packages are installed
pkg install python python-pip
pip install --upgrade pip
```

#### API key not recognized
```bash
# Solution: Verify it's set
echo $OPENAI_API_KEY

# If empty, set it:
export OPENAI_API_KEY='your-key'
echo "export OPENAI_API_KEY='your-key'" >> ~/.bashrc
source ~/.bashrc
```

### Storage Issues

```bash
# Check available storage
df -h

# Clean package cache
pkg clean

# Remove unnecessary packages
pkg autoremove
```

### Getting Help

```bash
# Check system status
./check-system.sh

# View Open Interpreter help
interpreter --help

# Check Python version
python --version

# List installed packages
pip list
```

---

## 📊 Performance Benchmarks

### Samsung Galaxy Fold 6 (12GB RAM)

| Task | Performance | Notes |
|------|-------------|-------|
| GPT-4o | ⭐⭐⭐⭐⭐ | Excellent, recommended |
| Claude 3.5 | ⭐⭐⭐⭐⭐ | Excellent for code |
| GPT-3.5 | ⭐⭐⭐⭐⭐ | Very fast |
| Local models | ⭐⭐⭐⭐ | Good, requires setup |
| Large contexts (8K+) | ⭐⭐⭐⭐⭐ | Handles well |

### Mid-Range Devices (6-8GB RAM)

| Task | Performance | Notes |
|------|-------------|-------|
| GPT-4o | ⭐⭐⭐⭐ | Good |
| GPT-3.5 | ⭐⭐⭐⭐⭐ | Recommended |
| Local models | ⭐⭐⭐ | Usable |
| Large contexts | ⭐⭐⭐ | May be slow |

---

## 🔒 Security & Privacy

### Best Practices

1. **Protect API Keys**
   ```bash
   # Never share your ~/.bashrc or config.yaml
   # Use environment variables instead of hardcoding
   ```

2. **Use Safe Mode**
   ```bash
   interpreter --safe_mode ask  # Review code before execution
   ```

3. **Backup Important Data**
   ```bash
   # Use Termux backup feature
   # Or sync to cloud storage
   ```

4. **Local Models for Sensitive Work**
   ```bash
   # Use local models for private/sensitive code
   interpreter --model ollama/llama2
   ```

---

## 📚 Advanced Features

### Vision Mode (Analyze Images)

```bash
interpreter --vision
# Then provide image paths or URLs
```

### Voice Mode (Experimental)

```bash
# Install speech packages
pkg install espeak

# Use with speech output
interpreter --speak
```

### OS Mode (Limited Support)

⚠️ **Note:** Full OS mode is not currently supported on Android, but basic system commands work.

```bash
# Basic system operations work
interpreter "show my storage usage"
interpreter "list my recent files"
```

---

## 🆕 What's New in This Guide

- ✅ Automated setup script for easy installation
- ✅ System requirements checker
- ✅ Optimizations for high-end devices (Galaxy Fold 6, etc.)
- ✅ UserLand integration guide
- ✅ Multiple AI provider support (OpenAI, Anthropic, local models)
- ✅ Performance benchmarks
- ✅ Comprehensive troubleshooting
- ✅ Helper scripts for API key setup
- ✅ Advanced configuration options
- ✅ Security best practices

---

## 🎬 Example Use Cases

Check out these posts for examples of Open Interpreter on Android:

- [Basic Usage Example](https://x.com/MikeBirdTech/status/1707108619529916820)
- [Advanced Features](https://x.com/MikeBirdTech/status/1711798317288419382)

### What You Can Do

- 📝 Write and execute Python scripts
- 📊 Data analysis with pandas/numpy
- 🎨 Generate plots with matplotlib
- 🌐 Web scraping and API interactions
- 📱 Android automation via Termux-API
- 🔧 System administration tasks
- 💻 Code debugging and testing
- 📚 Learn programming interactively

---

## 🤝 Contributing

Found an issue or want to improve this guide? Contributions are welcome!

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Useful Links

- [Open Interpreter Official Docs](https://docs.openinterpreter.com/)
- [Termux Wiki](https://wiki.termux.com/)
- [Termux GitHub](https://github.com/termux/termux-app)
- [UserLand GitHub](https://github.com/CypherpunkArmory/UserLand)
- [Open Interpreter GitHub](https://github.com/KillianLucas/open-interpreter)

---

## ⚡ Quick Reference

```bash
# Installation
./setup.sh

# Check system
./check-system.sh

# Setup API key
./setup-api-key.sh

# Start Open Interpreter
interpreter

# Start with helper
./oi-start.sh

# Update Open Interpreter
pip install --upgrade open-interpreter

# Config location
~/.config/open-interpreter/config.yaml
```

---

Made with ❤️ for Android power users

**Perfect for Samsung Galaxy Fold 6 and other flagship Android devices!**
