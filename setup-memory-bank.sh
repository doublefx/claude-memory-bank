#!/bin/bash

# Claude Memory Bank Project Setup Script
# Adaptation of the original cursor-memory-bank by @vanzan01 for Claude Code
# This script initializes the memory bank system in a project directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.claude-memory-bank"
TEMPLATE_DIR="$INSTALL_DIR/claude-memory-bank"

echo -e "${BLUE}Claude Memory Bank - Project Setup${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""

# Verify installation
verify_installation() {
    if [ ! -d "$INSTALL_DIR/claude-memory-bank" ]; then
        echo -e "${RED}Error: Claude Memory Bank not installed globally.${NC}"
        echo "Please run the global installer first:"
        echo "curl -sSL https://repo-url/install.sh | bash"
        exit 1
    fi
}

# Check if already initialized
check_existing() {
    if [ -d "memory-bank" ]; then
        echo -e "${YELLOW}Memory bank already exists in this directory.${NC}"
        read -p "Do you want to reinitialize? This will backup existing files. (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Backing up existing memory-bank to memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
            mv memory-bank "memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
        else
            echo "Setup cancelled."
            exit 0
        fi
    fi
}

# Create memory bank structure
create_structure() {
    echo -e "${YELLOW}Creating memory bank structure...${NC}"
    
    # Main directory structure
    mkdir -p memory-bank/custom_modes
    mkdir -p memory-bank/decisions
    mkdir -p memory-bank/qa
    mkdir -p memory-bank/archive
    mkdir -p memory-bank/project-specific/{patterns,context,decisions,snippets}
    mkdir -p memory-bank/shared/{best-practices,common-patterns}
    mkdir -p memory-bank/scripts
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# Copy mode instruction files
copy_mode_files() {
    echo -e "${YELLOW}Installing mode instruction files...${NC}"
    
    # Copy all mode instruction files
    cp "$TEMPLATE_DIR/memory-bank/custom_modes/"*.md memory-bank/custom_modes/
    
    echo -e "${GREEN}✓ Mode instruction files installed${NC}"
}

# Create claude.md configuration
create_claude_config() {
    echo -e "${YELLOW}Creating Claude Code configuration...${NC}"
    
    # Copy the claude.md template
    cp "$TEMPLATE_DIR/claude.md" ./
    
    echo -e "${GREEN}✓ Claude Code configuration created${NC}"
}

# Create template files
create_templates() {
    echo -e "${YELLOW}Creating template files...${NC}"
    
    # Create tasks.md
    cat > memory-bank/tasks.md << 'EOF'
# Memory Bank Tasks

> **Central Source of Truth for Task Tracking**
> 
> This file is automatically created by the VAN mode and serves as the single source of truth for all task management. Do not edit manually - use the appropriate modes to update.

## Current Task Status
- **Status**: Not initialized
- **Complexity Level**: TBD
- **Current Mode**: None
- **Next Mode**: VAN

## Task Overview
No tasks currently defined. Run VAN mode to initialize.

## Task List
1. [ ] Initialize project with VAN mode

## Implementation Plan
To be created by PLAN mode.

## Creative Phase Components
To be identified by PLAN mode.

## Progress Tracking
- VAN: ⏸️ Not started
- PLAN: ⏸️ Not started  
- CREATIVE: ⏸️ Not started
- IMPLEMENT: ⏸️ Not started
- REFLECT: ⏸️ Not started
- ARCHIVE: ⏸️ Not started

---
*This file is managed by the Claude Memory Bank system.*
*Original methodology by @vanzan01, adapted for Claude Code.*
EOF

    # Create activeContext.md
    cat > memory-bank/activeContext.md << 'EOF'
# Active Context

## Current Focus
No active task. Initialize with VAN mode.

## Current Mode
VAN (Ready to initialize)

## Next Actions
1. Run `@VAN` command to analyze project and create initial task breakdown
2. Follow workflow progression based on complexity assessment

## Context Notes
Project initialized but not yet analyzed.

---
*Last updated: Setup*
EOF

    # Create progress.md
    cat > memory-bank/progress.md << 'EOF'
# Progress Tracking

## Project Status
- **Initialized**: Yes
- **Active Tasks**: 0
- **Completed Tasks**: 0

## Workflow Progress
No workflows initiated yet.

## Recent Activity
- Project setup completed
- Memory bank structure created
- Ready for VAN mode initialization

---
*Last updated: Setup*
EOF

    # Create initial log file in decisions
    cat > memory-bank/decisions/log.md << 'EOF'
# Decision Log

## Project Decisions
No decisions recorded yet.

## Architectural Decisions
To be populated during CREATIVE mode.

## Implementation Decisions
To be populated during IMPLEMENT mode.

---
*This file tracks important decisions made during the development process.*
EOF

    # Create validation results template
    cat > memory-bank/qa/validation-results.md << 'EOF'
# Validation Results

## Quality Assurance Results
No validations performed yet.

## Test Results
To be populated during IMPLEMENT and REFLECT modes.

## Code Quality Metrics
To be measured and recorded here.

---
*This file tracks quality assurance and validation results.*
EOF

    echo -e "${GREEN}✓ Template files created${NC}"
}

# Copy automation scripts
copy_scripts() {
    echo -e "${YELLOW}Installing automation scripts...${NC}"
    
    # Copy automation scripts
    if [ -f "$TEMPLATE_DIR/memory-bank/scripts/auto-update.py" ]; then
        cp "$TEMPLATE_DIR/memory-bank/scripts/auto-update.py" memory-bank/scripts/
    fi
    
    echo -e "${GREEN}✓ Automation scripts installed${NC}"
}

# Create starter prompt
create_starter_prompt() {
    echo -e "${YELLOW}Creating starter prompt...${NC}"
    
    # Copy starter prompt
    cp "$TEMPLATE_DIR/starter-prompt.md" ./
    
    echo -e "${GREEN}✓ Starter prompt created${NC}"
}

# Project type detection
detect_project_type() {
    echo -e "${YELLOW}Detecting project type...${NC}"
    
    PROJECT_TYPE="general"
    
    if [ -f "package.json" ]; then
        PROJECT_TYPE="javascript"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        PROJECT_TYPE="python"
    elif [ -f "Cargo.toml" ]; then
        PROJECT_TYPE="rust"
    elif [ -f "go.mod" ]; then
        PROJECT_TYPE="go"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        PROJECT_TYPE="java"
    fi
    
    echo "Project type detected: $PROJECT_TYPE"
    
    # Update templates based on project type
    update_templates_for_project_type "$PROJECT_TYPE"
}

# Update templates based on project type
update_templates_for_project_type() {
    local project_type="$1"
    
    # Add project-specific patterns and context
    case $project_type in
        "javascript")
            echo "- Review package.json dependencies" >> memory-bank/project-specific/context/javascript-patterns.md
            echo "- Consider npm scripts and build process" >> memory-bank/project-specific/context/javascript-patterns.md
            ;;
        "python")
            echo "- Review requirements and virtual environment" >> memory-bank/project-specific/context/python-patterns.md
            echo "- Consider testing framework (pytest, unittest)" >> memory-bank/project-specific/context/python-patterns.md
            ;;
        "rust")
            echo "- Review Cargo.toml dependencies" >> memory-bank/project-specific/context/rust-patterns.md
            echo "- Consider Rust testing and documentation patterns" >> memory-bank/project-specific/context/rust-patterns.md
            ;;
    esac
}

# Display next steps
show_next_steps() {
    echo ""
    echo -e "${GREEN}Memory Bank setup complete!${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Review the starter-prompt.md file for initialization instructions"
    echo "2. Start Claude Code and load the claude.md configuration"
    echo "3. Use the @VAN command to begin your first workflow"
    echo ""
    echo -e "${BLUE}Available Mode Commands:${NC}"
    echo "  @VAN        - Initialize and analyze project"
    echo "  @PLAN       - Create implementation plan"
    echo "  @CREATIVE   - Design and architecture work"
    echo "  @IMPLEMENT  - Build the planned changes"
    echo "  @REFLECT    - Review and validate work"
    echo "  @ARCHIVE    - Document and finalize"
    echo ""
    echo -e "${BLUE}Key Files Created:${NC}"
    echo "  claude.md                    - Claude Code configuration"
    echo "  starter-prompt.md            - Initialization instructions"
    echo "  memory-bank/tasks.md         - Central task tracking"
    echo "  memory-bank/activeContext.md - Current work focus"
    echo "  memory-bank/progress.md      - Implementation status"
    echo ""
    echo -e "${YELLOW}Original methodology by @vanzan01${NC}"
    echo -e "${YELLOW}Adapted for Claude Code with 100% workflow preservation${NC}"
}

# Main setup process
main() {
    verify_installation
    check_existing
    create_structure
    copy_mode_files
    create_claude_config
    create_templates
    copy_scripts
    create_starter_prompt
    detect_project_type
    show_next_steps
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Claude Memory Bank Project Setup"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --force        Force setup even if directory exists"
        echo ""
        echo "This script initializes the Claude Memory Bank system in the current directory."
        exit 0
        ;;
    --force)
        # Skip existing check for force mode
        verify_installation
        create_structure
        copy_mode_files
        create_claude_config
        create_templates
        copy_scripts
        create_starter_prompt
        detect_project_type
        show_next_steps
        ;;
    *)
        main
        ;;
esac