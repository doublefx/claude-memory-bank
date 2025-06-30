#!/bin/bash

# Claude Memory Bank Global Installer v2.0
# Adaptation of the original cursor-memory-bank by @vanzan01 for Claude Code
# This installer sets up the global commands and prepares the system for project-specific setup
# v2.0: Added support for single-project and multi-project repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.claude-memory-bank"
BIN_DIR="$HOME/.local/bin"
REPO_URL="https://github.com/doublefx/claude-memory-bank"

echo -e "${BLUE}Claude Memory Bank v2.0 - Global Installer${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""
echo "This installer will set up Claude Memory Bank v2.0 globally on your system."
echo "Supports both single-project and multi-project repositories."
echo "Original methodology by @vanzan01, adapted for Claude Code."
echo ""

# Check dependencies
check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Error: Python 3 is required but not installed.${NC}"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: Git is required but not installed.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Dependencies satisfied${NC}"
}

# Create directories
create_directories() {
    echo -e "${YELLOW}Creating installation directories...${NC}"
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$BIN_DIR"
    mkdir -p "$INSTALL_DIR/templates"
    mkdir -p "$INSTALL_DIR/scripts"
    
    echo -e "${GREEN}✓ Directories created${NC}"
}

# Install the system
install_system() {
    echo -e "${YELLOW}Installing Claude Memory Bank...${NC}"
    
    # Clone or download the repository to the install directory
    if [ -d "$INSTALL_DIR/claude-memory-bank" ]; then
        echo "Updating existing installation..."
        cd "$INSTALL_DIR/claude-memory-bank"
        git pull origin main
    else
        echo "Installing from source..."
        cd "$INSTALL_DIR"
        # Copy from current directory if we're in development
        if [ -f "setup-memory-bank.sh" ]; then
            cp -r . "$INSTALL_DIR/claude-memory-bank/"
        else
            git clone "$REPO_URL" claude-memory-bank
        fi
    fi
    
    echo -e "${GREEN}✓ System installed${NC}"
}

# Create global commands
create_global_commands() {
    echo -e "${YELLOW}Creating global commands...${NC}"
    
    # claude-memory-setup command
    cat > "$BIN_DIR/claude-memory-setup" << 'EOF'
#!/bin/bash
# Claude Memory Bank Project Setup Command

INSTALL_DIR="$HOME/.claude-memory-bank"
SCRIPT_PATH="$INSTALL_DIR/claude-memory-bank/setup-memory-bank.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: Claude Memory Bank not properly installed."
    echo "Run: curl -sSL \"https://github.com/doublefx/claude-memory-bank/install.sh\" | bash"
    exit 1
fi

bash "$SCRIPT_PATH" "$@"
EOF

    # claude-memory-update command
    cat > "$BIN_DIR/claude-memory-update" << 'EOF'
#!/bin/bash
# Claude Memory Bank Update Command

INSTALL_DIR="$HOME/.claude-memory-bank"

echo "Updating Claude Memory Bank..."
cd "$INSTALL_DIR/claude-memory-bank"
git pull origin main

echo "✓ Update complete"
EOF

    # claude-memory-status command
    cat > "$BIN_DIR/claude-memory-status" << 'EOF'
#!/bin/bash
# Claude Memory Bank Status Command

INSTALL_DIR="$HOME/.claude-memory-bank"

echo "Claude Memory Bank v2.0 Status"
echo "==============================="
echo "Installation directory: $INSTALL_DIR"

if [ -d "$INSTALL_DIR/claude-memory-bank" ]; then
    echo "✓ System installed"
    cd "$INSTALL_DIR/claude-memory-bank"
    echo "Version: v2.0 ($(git describe --tags --always 2>/dev/null || echo 'development'))"
    echo "Last updated: $(git log -1 --format=%cd --date=short 2>/dev/null || echo 'unknown')"
else
    echo "✗ System not installed"
fi

echo ""
echo "Project status:"
if [ -f ".memory-bank/tasks.md" ] || [ -d ".memory-bank/shared" ]; then
    echo "✓ Memory bank initialized in current directory"
    if [ -d ".memory-bank/shared" ]; then
        echo "✓ Multi-project repository detected"
        # Count projects
        project_count=$(find .memory-bank -maxdepth 1 -type d ! -name ".memory-bank" ! -name "shared" ! -name "custom_modes" ! -name "scripts" | wc -l)
        echo "  Projects: $project_count"
    else
        echo "✓ Single-project repository"
    fi
    if [ -f "CLAUDE.md" ]; then
        echo "✓ Claude Code configuration present"
    else
        echo "✗ Claude Code configuration missing"
    fi
else
    echo "✗ No memory bank in current directory"
    echo "Run 'claude-memory-setup' to initialize"
fi
EOF

    # Make commands executable
    chmod +x "$BIN_DIR/claude-memory-setup"
    chmod +x "$BIN_DIR/claude-memory-update"
    chmod +x "$BIN_DIR/claude-memory-status"
    
    echo -e "${GREEN}✓ Global commands created${NC}"
}

# Setup shell integration
setup_shell_integration() {
    echo -e "${YELLOW}Setting up shell integration...${NC}"
    
    # Detect shell
    SHELL_RC=""
    if [ "$SHELL" = "/bin/bash" ] || [ "$SHELL" = "/usr/bin/bash" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        echo -e "${YELLOW}Warning: Shell not detected. You may need to manually add $BIN_DIR to your PATH${NC}"
        return
    fi
    
    # Add bin directory to PATH if not already present
    if [ -f "$SHELL_RC" ]; then
        if ! grep -q "$BIN_DIR" "$SHELL_RC"; then
            echo "" >> "$SHELL_RC"
            echo "# Claude Memory Bank" >> "$SHELL_RC"
            echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_RC"
            echo -e "${GREEN}✓ Added to $SHELL_RC${NC}"
        else
            echo -e "${GREEN}✓ PATH already configured${NC}"
        fi
    fi
    
    # Add convenient aliases
    if [ -f "$SHELL_RC" ]; then
        if ! grep -q "claude-memory-bank aliases" "$SHELL_RC"; then
            cat >> "$SHELL_RC" << 'EOF'

# Claude Memory Bank aliases
alias cmb-setup='claude-memory-setup'
alias cmb-status='claude-memory-status'
alias cmb-update='claude-memory-update'
EOF
            echo -e "${GREEN}✓ Aliases added${NC}"
        fi
    fi
}

# Main installation process
main() {
    echo -e "${BLUE}Starting installation...${NC}"
    echo ""
    
    check_dependencies
    create_directories
    install_system
    create_global_commands
    setup_shell_integration
    
    echo ""
    echo -e "${GREEN}Claude Memory Bank v2.0 installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
    echo "2. Navigate to a project directory"
    echo "3. Run: claude-memory-setup"
    echo ""
    echo "Available commands:"
    echo "  claude-memory-setup        - Initialize memory bank in current project"
    echo "  claude-memory-setup --single    - Force single-project setup"
    echo "  claude-memory-setup --multi     - Force multi-project setup"
    echo "  claude-memory-setup --add-project - Add project to multi-repo"
    echo "  claude-memory-status       - Check installation and project status"
    echo "  claude-memory-update       - Update to latest version"
    echo ""
    echo "Short aliases:"
    echo "  cmb-setup   - Setup project (supports all options)"
    echo "  cmb-status  - Check status"
    echo "  cmb-update  - Update system"
    echo ""
    echo -e "${BLUE}Version 2.0 Features:${NC}"
    echo "  - Automatic single/multi-project detection"
    echo "  - Cross-project task scanning"
    echo "  - Shared patterns for multi-project repos"
    echo "  - Living context documentation"
    echo ""
    echo -e "${BLUE}Original methodology by @vanzan01${NC}"
    echo -e "${BLUE}Claude Code adaptation preserves 100% of workflow integrity${NC}"
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Claude Memory Bank v2.0 Global Installer"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --uninstall    Remove Claude Memory Bank"
        echo ""
        echo "Version 2.0 supports both single-project and multi-project repositories"
        echo "with automatic structure detection and cross-project task management."
        echo ""
        exit 0
        ;;
    --uninstall)
        echo -e "${YELLOW}Uninstalling Claude Memory Bank...${NC}"
        rm -rf "$INSTALL_DIR"
        rm -f "$BIN_DIR/claude-memory-setup"
        rm -f "$BIN_DIR/claude-memory-update"
        rm -f "$BIN_DIR/claude-memory-status"
        echo -e "${GREEN}✓ Uninstallation complete${NC}"
        echo "Note: You may want to remove the PATH export from your shell configuration"
        exit 0
        ;;
    *)
        main
        ;;
esac