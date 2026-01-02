#!/data/data/com.termux/files/usr/bin/bash

# Open Interpreter for Termux - Automated Setup Script
# Optimized for high-performance devices (8GB+ RAM)

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    print_error "This script must be run in Termux!"
    exit 1
fi

print_info "Starting Open Interpreter installation for Termux..."
print_info "This process may take 15-30 minutes depending on your device and connection."
echo ""

# Check device specs
print_info "Checking device specifications..."
TOTAL_RAM=$(free -m | awk 'NR==2{print $2}')
print_info "Detected RAM: ${TOTAL_RAM}MB"

if [ "$TOTAL_RAM" -lt 4000 ]; then
    print_warning "Your device has less than 4GB RAM. Open Interpreter may run slowly."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update packages
print_info "Updating packages and repositories..."
yes | pkg update && yes | pkg upgrade

print_success "Packages updated successfully!"

# Install required packages
print_info "Installing required packages..."
print_info "This will take a while. Please be patient..."

REQUIRED_PACKAGES=(
    "termux-api"
    "python"
    "python-pip"
    "cmake"
    "ninja"
    "patchelf"
    "build-essential"
    "matplotlib"
    "rust"
    "binutils"
    "libzmq"
    "git"
    "wget"
    "curl"
    "nano"
    "vim"
)

for package in "${REQUIRED_PACKAGES[@]}"; do
    print_info "Installing $package..."
    yes | pkg install "$package" 2>&1 | grep -v "Setting up\|Preparing to unpack\|Unpacking" || true
done

print_success "All packages installed successfully!"

# Setup storage
print_info "Setting up storage permissions..."
print_warning "Please grant storage permission when prompted!"
termux-setup-storage
sleep 2

# Verify storage setup
if [ -d "$HOME/storage" ]; then
    print_success "Storage permissions granted!"
else
    print_error "Storage setup failed. Please run 'termux-setup-storage' manually."
fi

# Upgrade pip
print_info "Upgrading pip to latest version..."
pip install --upgrade pip

# Install Open Interpreter with optimizations
print_info "Installing Open Interpreter..."
print_info "Installing with optimized dependencies for mobile devices..."

# For high-RAM devices, we can install additional features
if [ "$TOTAL_RAM" -gt 8000 ]; then
    print_info "High RAM detected! Installing with additional features..."
    pip install "open-interpreter[local,os,safe]" --no-cache-dir
else
    pip install open-interpreter --no-cache-dir
fi

print_success "Open Interpreter installed successfully!"

# Create config directory
CONFIG_DIR="$HOME/.config/open-interpreter"
mkdir -p "$CONFIG_DIR"

# Create a sample config file
print_info "Creating sample configuration..."
cat > "$CONFIG_DIR/config.yaml" << 'EOF'
# Open Interpreter Configuration for Termux
# Edit this file to customize your experience

# Model settings (choose your provider)
model: "gpt-4o"  # OpenAI model
# model: "claude-3-5-sonnet-20241022"  # Anthropic Claude (requires ANTHROPIC_API_KEY)
# model: "ollama/llama2"  # Local model via Ollama

# API settings
# api_key: "your-api-key-here"  # Uncomment and add your API key
# api_base: "https://api.openai.com/v1"  # Change for different providers

# Performance settings
auto_run: false  # Set to true to auto-approve code execution (use with caution!)
safe_mode: "ask"  # Options: "off", "ask", "auto"

# System settings
context_window: 4096  # Adjust based on available RAM
max_tokens: 2000

# Local mode (for offline usage with local models)
# local: true
# max_budget: 0.01

EOF

print_success "Configuration file created at: $CONFIG_DIR/config.yaml"

# Setup termux.properties for external apps
print_info "Configuring Termux properties..."
TERMUX_PROPS="$HOME/.termux/termux.properties"
mkdir -p "$HOME/.termux"

if [ ! -f "$TERMUX_PROPS" ]; then
    cat > "$TERMUX_PROPS" << 'EOF'
# Allow external apps to execute commands in Termux
allow-external-apps = true

# Extra keys for easier terminal usage
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
EOF
else
    if ! grep -q "allow-external-apps" "$TERMUX_PROPS"; then
        echo "allow-external-apps = true" >> "$TERMUX_PROPS"
    fi
fi

print_success "Termux properties configured!"

# Create helper scripts
print_info "Creating helper scripts..."

# Create API key setup script
cat > "$HOME/setup-api-key.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

echo "Open Interpreter - API Key Setup"
echo "=================================="
echo ""
echo "Choose your AI provider:"
echo "1) OpenAI (GPT-4, GPT-3.5)"
echo "2) Anthropic (Claude)"
echo "3) Both"
echo "4) Skip (use local models)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        read -p "Enter your OpenAI API key: " openai_key
        echo "export OPENAI_API_KEY='$openai_key'" >> ~/.bashrc
        echo "OpenAI API key set!"
        ;;
    2)
        read -p "Enter your Anthropic API key: " anthropic_key
        echo "export ANTHROPIC_API_KEY='$anthropic_key'" >> ~/.bashrc
        echo "Anthropic API key set!"
        ;;
    3)
        read -p "Enter your OpenAI API key: " openai_key
        read -p "Enter your Anthropic API key: " anthropic_key
        echo "export OPENAI_API_KEY='$openai_key'" >> ~/.bashrc
        echo "export ANTHROPIC_API_KEY='$anthropic_key'" >> ~/.bashrc
        echo "Both API keys set!"
        ;;
    4)
        echo "Skipping API key setup. You can set it later."
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

echo ""
echo "Reload your terminal or run: source ~/.bashrc"
EOF

chmod +x "$HOME/setup-api-key.sh"

# Create quick start script
cat > "$HOME/oi-start.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Quick start script for Open Interpreter
echo "Starting Open Interpreter..."

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo ""
    echo "WARNING: No API key detected!"
    echo "Run './setup-api-key.sh' to configure your API keys."
    echo "Or set manually: export OPENAI_API_KEY='your-key'"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

interpreter "$@"
EOF

chmod +x "$HOME/oi-start.sh"

print_success "Helper scripts created!"

# Display completion message
echo ""
echo "=========================================="
print_success "Installation Complete!"
echo "=========================================="
echo ""
print_info "Next steps:"
echo ""
echo "1. Set up your API key:"
echo "   ${GREEN}./setup-api-key.sh${NC}"
echo ""
echo "2. Or set it manually:"
echo "   ${GREEN}export OPENAI_API_KEY='your-key-here'${NC}"
echo "   ${GREEN}export ANTHROPIC_API_KEY='your-key-here'${NC}"
echo ""
echo "3. Start Open Interpreter:"
echo "   ${GREEN}interpreter${NC}"
echo "   or use the quick start:"
echo "   ${GREEN}./oi-start.sh${NC}"
echo ""
echo "4. Edit configuration (optional):"
echo "   ${GREEN}nano ~/.config/open-interpreter/config.yaml${NC}"
echo ""
print_info "Helpful tips:"
echo "  - Press Ctrl+C twice to exit Open Interpreter"
echo "  - Use 'interpreter --config' to open config editor"
echo "  - Check $HOME/.config/open-interpreter/ for configs"
echo ""
print_warning "Note: OS mode is not currently supported on Android"
echo ""
echo "For more info: https://github.com/THEFIG06/open-interpreter-termux"
echo ""
