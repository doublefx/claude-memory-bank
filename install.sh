#!/bin/bash

# Claude Memory Bank Global Installer v2.2
# Adaptation of the original cursor-memory-bank by @vanzan01 for Claude Code
# This installer sets up the global commands and prepares the system for project-specific setup
# v2.0: Added support for single-project and multi-project repositories
# v2.2: Migrated slash commands to user-level namespace

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

echo -e "${BLUE}Claude Memory Bank v2.2 - Global Installer${NC}"
echo -e "${BLUE}===========================================${NC}"
echo ""
echo "This installer will set up Claude Memory Bank v2.2 globally on your system."
echo "Supports both single-project and multi-project repositories."
echo "Installs Claude Code Terminal slash commands at user level."
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

# Install slash commands for Claude Code Terminal
install_slash_commands() {
    echo -e "${YELLOW}Installing Claude Code Terminal slash commands...${NC}"
    
    # Create user-level commands directory
    COMMANDS_DIR="$HOME/.claude/commands/memory-bank"
    mkdir -p "$COMMANDS_DIR"
    
    # Copy command files from the installation directory
    SOURCE_DIR="$INSTALL_DIR/claude-memory-bank/claude-memory-bank/.claude/commands"
    
    # First check the nested structure (development/cloned repo)
    if [ ! -d "$SOURCE_DIR" ]; then
        # Try the flatter structure (installed from release)
        SOURCE_DIR="$INSTALL_DIR/claude-memory-bank/.claude/commands"
    fi
    
    if [ -d "$SOURCE_DIR" ]; then
        # Copy all command files to user level
        if [ -f "$SOURCE_DIR/activate.md" ]; then
            cp "$SOURCE_DIR/activate.md" "$COMMANDS_DIR/"
        elif [ -f "$SOURCE_DIR/memory-bank.md" ]; then
            # Handle old naming convention
            cp "$SOURCE_DIR/memory-bank.md" "$COMMANDS_DIR/activate.md"
        fi
        
        cp "$SOURCE_DIR/ask.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/van.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/plan.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/implement.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/reflect.md" "$COMMANDS_DIR/" 2>/dev/null || true
        
        echo -e "${GREEN}✓ Slash commands installed to ~/.claude/commands/memory-bank/${NC}"
        echo -e "${GREEN}  Available commands:${NC}"
        echo -e "${GREEN}  - /user:memory-bank:activate${NC}"
        echo -e "${GREEN}  - /user:memory-bank:ask${NC}"
        echo -e "${GREEN}  - /user:memory-bank:van${NC}"
        echo -e "${GREEN}  - /user:memory-bank:plan${NC}"
        echo -e "${GREEN}  - /user:memory-bank:implement${NC}"
        echo -e "${GREEN}  - /user:memory-bank:reflect${NC}"
    else
        echo -e "${YELLOW}Warning: Slash command files not found in installation${NC}"
    fi
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
    echo "Run: curl -sSL https://raw.githubusercontent.com/doublefx/claude-memory-bank/main/install.sh | bash"
    exit 1
fi

bash "$SCRIPT_PATH" "$@"
EOF

    # claude-memory-update command
    cat > "$BIN_DIR/claude-memory-update" << 'EOF'
#!/bin/bash
# Claude Memory Bank Update Command

INSTALL_DIR="$HOME/.claude-memory-bank"
COMMANDS_DIR="$HOME/.claude/commands/memory-bank"

echo "Updating Claude Memory Bank..."
cd "$INSTALL_DIR/claude-memory-bank"
git pull origin main

# Update slash commands if they exist
if [ -d "$COMMANDS_DIR" ]; then
    echo "Updating slash commands..."
    SOURCE_DIR="$INSTALL_DIR/claude-memory-bank/claude-memory-bank/.claude/commands"
    
    if [ ! -d "$SOURCE_DIR" ]; then
        SOURCE_DIR="$INSTALL_DIR/claude-memory-bank/.claude/commands"
    fi
    
    if [ -d "$SOURCE_DIR" ]; then
        # Update command files
        if [ -f "$SOURCE_DIR/activate.md" ]; then
            cp "$SOURCE_DIR/activate.md" "$COMMANDS_DIR/"
        elif [ -f "$SOURCE_DIR/memory-bank.md" ]; then
            cp "$SOURCE_DIR/memory-bank.md" "$COMMANDS_DIR/activate.md"
        fi
        
        cp "$SOURCE_DIR/ask.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/van.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/plan.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/implement.md" "$COMMANDS_DIR/" 2>/dev/null || true
        cp "$SOURCE_DIR/reflect.md" "$COMMANDS_DIR/" 2>/dev/null || true
        
        echo "✓ Slash commands updated"
    fi
fi

echo "✓ Update complete"
EOF

    # claude-memory-status command
    cat > "$BIN_DIR/claude-memory-status" << 'EOF'
#!/bin/bash
# Claude Memory Bank Status Command

INSTALL_DIR="$HOME/.claude-memory-bank"

echo "Claude Memory Bank v2.2 Status"
echo "==============================="
echo "Installation directory: $INSTALL_DIR"

if [ -d "$INSTALL_DIR/claude-memory-bank" ]; then
    echo "✓ System installed"
    cd "$INSTALL_DIR/claude-memory-bank"
    echo "Version: v2.2 ($(git describe --tags --always 2>/dev/null || echo 'development'))"
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

    # claude-memory-uninstall command
    if [ -f "$INSTALL_DIR/claude-memory-bank/scripts/claude-memory-uninstall" ]; then
        cp "$INSTALL_DIR/claude-memory-bank/scripts/claude-memory-uninstall" "$BIN_DIR/claude-memory-uninstall"
    else
        # Fallback: create basic uninstall command if script not found
        cat > "$BIN_DIR/claude-memory-uninstall" << 'EOF'
#!/bin/bash
# Claude Memory Bank Uninstall Command (Basic)
echo "Error: Full uninstall script not found."
echo "Using basic uninstall. For full features, update Memory Bank first."
echo ""
echo "This will remove Claude Memory Bank. Continue? (y/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.claude-memory-bank"
    rm -f "$HOME/.local/bin/claude-memory-setup"
    rm -f "$HOME/.local/bin/claude-memory-update"
    rm -f "$HOME/.local/bin/claude-memory-status"
    rm -f "$HOME/.local/bin/claude-memory-uninstall"
    rm -rf "$HOME/.claude/commands/memory-bank"
    echo "✓ Basic uninstallation complete"
fi
EOF
    fi

    # Make commands executable
    chmod +x "$BIN_DIR/claude-memory-setup"
    chmod +x "$BIN_DIR/claude-memory-update"
    chmod +x "$BIN_DIR/claude-memory-status"
    chmod +x "$BIN_DIR/claude-memory-uninstall"
    
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
alias cmb-uninstall='claude-memory-uninstall'
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
    install_slash_commands
    create_global_commands
    setup_shell_integration
    
    echo ""
    echo -e "${GREEN}Claude Memory Bank v2.2 installation complete!${NC}"
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
    echo "  claude-memory-uninstall    - Safely remove Memory Bank"
    echo ""
    echo "Short aliases:"
    echo "  cmb-setup     - Setup project (supports all options)"
    echo "  cmb-status    - Check status"
    echo "  cmb-update    - Update system"
    echo "  cmb-uninstall - Remove Memory Bank"
    echo ""
    echo -e "${BLUE}Claude Code Terminal Slash Commands:${NC}"
    echo "  /user:memory-bank:activate - Initialize Memory Bank workflow"
    echo "  /user:memory-bank:ask      - Explore and discuss (read-only)"
    echo "  /user:memory-bank:van      - Initialize and assess context"
    echo "  /user:memory-bank:plan     - Create implementation strategy"
    echo "  /user:memory-bank:implement - Build and test"
    echo "  /user:memory-bank:reflect  - Validate and learn"
    echo ""
    echo -e "${BLUE}Version 2.2 Features:${NC}"
    echo "  - User-level slash commands for Claude Code Terminal"
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
        echo "Claude Memory Bank v2.2 Global Installer"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --uninstall    Remove Claude Memory Bank"
        echo ""
        echo "Version 2.2 features:"
        echo "  - User-level slash commands for Claude Code Terminal"
        echo "  - Single-project and multi-project repository support"
        echo "  - Automatic structure detection and cross-project task management"
        echo ""
        exit 0
        ;;
    --uninstall)
        echo -e "${YELLOW}Uninstalling Claude Memory Bank...${NC}"
        rm -rf "$INSTALL_DIR"
        rm -f "$BIN_DIR/claude-memory-setup"
        rm -f "$BIN_DIR/claude-memory-update"
        rm -f "$BIN_DIR/claude-memory-status"
        rm -f "$BIN_DIR/claude-memory-uninstall"
        # Remove slash commands
        rm -rf "$HOME/.claude/commands/memory-bank"
        echo -e "${GREEN}✓ Uninstallation complete${NC}"
        echo "Note: You may want to remove the PATH export and aliases from your shell configuration"
        exit 0
        ;;
    *)
        main
        ;;
esac