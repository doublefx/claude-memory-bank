#!/bin/bash

# Sync Claude Memory Bank v2.2.0 from project to local installation
# This script updates the local installation with the latest project files

set -e

echo "🔄 Syncing Claude Memory Bank v2.2.0 to local installation..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define project directory (the claude-memory-bank project)
PROJECT_DIR="$SCRIPT_DIR/claude-memory-bank"

# Define local installation directory
LOCAL_DIR="$HOME/.claude-memory-bank"

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found at $PROJECT_DIR"
    echo "Please ensure the claude-memory-bank project is in the correct location"
    exit 1
fi

# Check if local installation exists
if [ ! -d "$LOCAL_DIR" ]; then
    echo "❌ Local installation not found at $LOCAL_DIR"
    echo "Please run setup-memory-bank.sh first"
    exit 1
fi

echo "📂 Project directory: $PROJECT_DIR"
echo "📂 Local directory: $LOCAL_DIR"

# Function to copy files
copy_file() {
    local src="$1"
    local dest="$2"
    
    cp "$src" "$dest"
    echo "  ✅ Updated: $(basename "$dest")"
}

# 1. Update CLAUDE.md
echo -e "\n📄 Updating CLAUDE.md..."
copy_file "$PROJECT_DIR/CLAUDE.md" "$LOCAL_DIR/CLAUDE.md"

# 2. Update starter-prompt.md
echo -e "\n📄 Updating starter-prompt.md..."
copy_file "$PROJECT_DIR/starter-prompt.md" "$LOCAL_DIR/starter-prompt.md"

# 3. Copy slash commands to user level (v2.2.0 change)
echo -e "\n🔧 Installing slash commands to user level..."
USER_COMMANDS_DIR="$HOME/.claude/commands/memory-bank"
if [ ! -d "$USER_COMMANDS_DIR" ]; then
    mkdir -p "$USER_COMMANDS_DIR"
    echo "  📁 Created user-level commands directory"
fi

# Copy from project, handling rename of memory-bank.md to activate.md
for cmd_file in "$PROJECT_DIR/.claude/commands/"*.md; do
    if [ -f "$cmd_file" ]; then
        filename=$(basename "$cmd_file")
        if [ "$filename" = "memory-bank.md" ] && [ -f "$PROJECT_DIR/.claude/commands/activate.md" ]; then
            # Use activate.md if it exists
            continue
        fi
        cp "$cmd_file" "$USER_COMMANDS_DIR/"
        echo "  ✅ Installed: $filename"
    fi
done

# Clean up old project-level commands
if [ -d "$LOCAL_DIR/.claude/commands" ]; then
    echo "  🧹 Cleaning up old project-level commands..."
    rm -rf "$LOCAL_DIR/.claude/commands"
fi

# 4. Update mode instructions
echo -e "\n📚 Updating mode instructions..."
for mode_file in "$PROJECT_DIR/.memory-bank/custom_modes/"*.md; do
    if [ -f "$mode_file" ]; then
        filename=$(basename "$mode_file")
        dest_file="$LOCAL_DIR/.memory-bank/custom_modes/$filename"
        copy_file "$mode_file" "$dest_file"
    fi
done

# 5. Copy templates (including temp-files.md)
echo -e "\n📋 Updating templates..."
if [ ! -d "$LOCAL_DIR/.memory-bank/templates" ]; then
    mkdir -p "$LOCAL_DIR/.memory-bank/templates"
    echo "  📁 Created templates directory"
fi

for template_file in "$PROJECT_DIR/templates/"*.md; do
    if [ -f "$template_file" ]; then
        cp "$template_file" "$LOCAL_DIR/.memory-bank/templates/"
        echo "  ✅ Updated: $(basename "$template_file")"
    fi
done

# 6. Check for .env file (v2.2.0 optimization)
echo -e "\n🔧 Checking .env optimization file..."
if [ ! -f "$LOCAL_DIR/.memory-bank/.env" ]; then
    echo "  📝 Creating .env file for initialization tracking..."
    cat > "$LOCAL_DIR/.memory-bank/.env" << 'EOF'
# Claude Memory Bank Environment Variables
# This file tracks initialization state to optimize performance

# Set to true after successful first initialization
MEMORY_BANK_INITIALIZED=true

# Version of the Memory Bank system
MEMORY_BANK_VERSION=2.2.0

# Date of initialization (will be set by VAN mode)
INITIALIZATION_DATE=$(date +%Y-%m-%d)
EOF
    echo "  ✅ Created .env file (marked as initialized for existing installation)"
else
    echo "  ✅ .env file already exists"
fi

# 7. Show version info
echo -e "\n✨ Synchronization complete!"
echo "📌 Local installation updated to v2.2.0"
echo ""
echo "🆕 New features in v2.2.0:"
echo "  • User-level slash commands - cleaner project directories"
echo "  • Commands at: ~/.claude/commands/memory-bank/"
echo "  • Auto-update when running claude-memory-update"
echo ""
echo "🔄 Breaking changes in v2.2.0:"
echo "  • Commands moved from /project:* to /user:memory-bank:*"
echo "  • Example: /user:memory-bank:ask, /user:memory-bank:van"
echo ""
echo "🚀 To use the new commands:"
echo "  • Try: /user:memory-bank:ask to explore without implementing"
echo "  • Use: /user:memory-bank:van to start a new task"
echo "  • Check: ~/.claude/commands/memory-bank/ for all commands"