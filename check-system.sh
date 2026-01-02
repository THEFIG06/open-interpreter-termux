#!/data/data/com.termux/files/usr/bin/bash

# System Requirements Checker for Open Interpreter on Termux
# Checks device compatibility and provides recommendations

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Open Interpreter - Termux System Requirements Check  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_fail() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_header

# Check if running in Termux
print_check "Verifying Termux environment..."
if [ -d "/data/data/com.termux" ]; then
    print_pass "Running in Termux"
else
    print_fail "Not running in Termux! This script must be run in Termux."
    exit 1
fi
echo ""

# Check device information
print_check "Gathering device information..."
echo ""

# RAM Check
TOTAL_RAM=$(free -m | awk 'NR==2{print $2}')
AVAILABLE_RAM=$(free -m | awk 'NR==2{print $7}')

echo "RAM Information:"
echo "  Total RAM: ${TOTAL_RAM}MB"
echo "  Available RAM: ${AVAILABLE_RAM}MB"

if [ "$TOTAL_RAM" -ge 12000 ]; then
    print_pass "Excellent! 12GB+ RAM - Perfect for Open Interpreter with all features"
    RECOMMENDED_MODEL="gpt-4o or claude-3-5-sonnet (with local model support)"
elif [ "$TOTAL_RAM" -ge 8000 ]; then
    print_pass "Great! 8GB+ RAM - Excellent for Open Interpreter"
    RECOMMENDED_MODEL="gpt-4o or claude-3-5-sonnet"
elif [ "$TOTAL_RAM" -ge 6000 ]; then
    print_pass "Good! 6GB+ RAM - Works well with Open Interpreter"
    RECOMMENDED_MODEL="gpt-3.5-turbo or claude-3-sonnet"
elif [ "$TOTAL_RAM" -ge 4000 ]; then
    print_warn "4-6GB RAM - Should work, but may be slow with large contexts"
    RECOMMENDED_MODEL="gpt-3.5-turbo"
else
    print_fail "Less than 4GB RAM - May experience performance issues"
    RECOMMENDED_MODEL="gpt-3.5-turbo (with reduced context)"
fi
echo ""

# Storage Check
STORAGE_AVAIL=$(df -h /data/data/com.termux | awk 'NR==2{print $4}')
STORAGE_TOTAL=$(df -h /data/data/com.termux | awk 'NR==2{print $2}')

echo "Storage Information:"
echo "  Total Storage: ${STORAGE_TOTAL}"
echo "  Available Storage: ${STORAGE_AVAIL}"

STORAGE_AVAIL_MB=$(df -m /data/data/com.termux | awk 'NR==2{print $4}')
if [ "$STORAGE_AVAIL_MB" -ge 2000 ]; then
    print_pass "Sufficient storage available"
elif [ "$STORAGE_AVAIL_MB" -ge 1000 ]; then
    print_warn "Storage is getting low. Consider freeing up space."
else
    print_fail "Low storage! At least 1GB free recommended"
fi
echo ""

# Python Check
print_check "Checking Python installation..."
if command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
    print_pass "Python installed: $PYTHON_VERSION"

    # Check if version is 3.8+
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    if [ "$PYTHON_MAJOR" -ge 3 ] && [ "$PYTHON_MINOR" -ge 8 ]; then
        print_pass "Python version is compatible (3.8+)"
    else
        print_warn "Python 3.8+ recommended, you have $PYTHON_VERSION"
    fi
else
    print_fail "Python not installed! Run: pkg install python"
fi
echo ""

# Pip Check
print_check "Checking pip installation..."
if command -v pip &> /dev/null; then
    PIP_VERSION=$(pip --version | awk '{print $2}')
    print_pass "pip installed: $PIP_VERSION"
else
    print_fail "pip not installed! Run: pkg install python-pip"
fi
echo ""

# Check required packages
print_check "Checking required system packages..."
REQUIRED_PKGS=("termux-api" "cmake" "ninja" "git" "rust" "binutils")
MISSING_PKGS=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if dpkg -l | grep -q "^ii  $pkg"; then
        echo -e "  ${GREEN}✓${NC} $pkg"
    else
        echo -e "  ${RED}✗${NC} $pkg (not installed)"
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
    print_pass "All required packages installed"
else
    print_warn "Missing packages: ${MISSING_PKGS[*]}"
    echo "  Install with: pkg install ${MISSING_PKGS[*]}"
fi
echo ""

# Check Open Interpreter installation
print_check "Checking Open Interpreter installation..."
if pip list 2>/dev/null | grep -q "open-interpreter"; then
    OI_VERSION=$(pip show open-interpreter 2>/dev/null | grep Version | awk '{print $2}')
    print_pass "Open Interpreter installed: v$OI_VERSION"

    # Check for updates
    print_check "Checking for updates..."
    LATEST_VERSION=$(pip index versions open-interpreter 2>/dev/null | grep "open-interpreter" | head -1 | awk '{print $2}' | tr -d '()')
    if [ "$OI_VERSION" == "$LATEST_VERSION" ]; then
        print_pass "Open Interpreter is up to date"
    else
        print_warn "Update available: v$OI_VERSION → v$LATEST_VERSION"
        echo "  Update with: pip install --upgrade open-interpreter"
    fi
else
    print_warn "Open Interpreter not installed"
    echo "  Install with: pip install open-interpreter"
fi
echo ""

# Check API Keys
print_check "Checking API configuration..."
if [ ! -z "$OPENAI_API_KEY" ]; then
    print_pass "OpenAI API key configured"
elif [ ! -z "$ANTHROPIC_API_KEY" ]; then
    print_pass "Anthropic API key configured"
else
    print_warn "No API keys found in environment"
    echo "  Set with: export OPENAI_API_KEY='your-key'"
    echo "  Or run: ./setup-api-key.sh"
fi
echo ""

# Check storage permissions
print_check "Checking storage permissions..."
if [ -d "$HOME/storage" ]; then
    print_pass "Storage permissions granted"
else
    print_warn "Storage permissions not set up"
    echo "  Set up with: termux-setup-storage"
fi
echo ""

# Check termux.properties
print_check "Checking Termux configuration..."
if [ -f "$HOME/.termux/termux.properties" ]; then
    if grep -q "allow-external-apps.*true" "$HOME/.termux/termux.properties"; then
        print_pass "External apps enabled"
    else
        print_warn "External apps not enabled in termux.properties"
        echo "  Enable with: echo 'allow-external-apps = true' >> ~/.termux/termux.properties"
    fi
else
    print_warn "termux.properties not found"
fi
echo ""

# Network Check
print_check "Checking network connectivity..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    print_pass "Internet connection active"
else
    print_warn "No internet connection detected"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      SUMMARY                           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Device Profile:"
echo "  RAM: ${TOTAL_RAM}MB"
echo "  Storage: ${STORAGE_AVAIL} available"
echo "  Recommended Model: ${RECOMMENDED_MODEL}"
echo ""

# Recommendations based on RAM
if [ "$TOTAL_RAM" -ge 12000 ]; then
    echo "🚀 Performance Recommendations (High-End Device):"
    echo ""
    echo "  Your Samsung Galaxy Fold 6 is perfect for Open Interpreter!"
    echo ""
    echo "  Optimizations you can enable:"
    echo "  • Use GPT-4o or Claude 3.5 Sonnet for best results"
    echo "  • Increase context_window to 8192 in config.yaml"
    echo "  • Consider running local models with Ollama"
    echo "  • Enable auto_run for faster execution (use with caution)"
    echo "  • Install additional ML libraries (numpy, pandas, scipy)"
    echo ""
    echo "  Advanced setup:"
    echo "  pip install 'open-interpreter[local,os,safe]'"
    echo "  pip install ollama numpy pandas scipy scikit-learn"
    echo ""
fi

# Overall status
if [ ${#MISSING_PKGS[@]} -eq 0 ] && command -v python &> /dev/null; then
    echo -e "${GREEN}✓ System ready for Open Interpreter!${NC}"
else
    echo -e "${YELLOW}⚠ System needs configuration. See warnings above.${NC}"
fi
echo ""

# Quick start reminder
if pip list 2>/dev/null | grep -q "open-interpreter"; then
    echo "Quick Start:"
    echo "  ${GREEN}interpreter${NC}  - Start Open Interpreter"
    echo "  ${GREEN}./oi-start.sh${NC}  - Start with helper script"
    echo ""
fi
