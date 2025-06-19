#!/bin/bash

# Claude Memory Bank Project Setup Script v2.0
# Adaptation of the original cursor-memory-bank by @vanzan01 for Claude Code
# This script initializes the memory bank system for single or multi-project repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.claude-memory-bank"
TEMPLATE_DIR="$INSTALL_DIR/claude-memory-bank"
SETUP_TYPE=""
PROJECT_NAME=""

echo -e "${BLUE}Claude Memory Bank - Project Setup v2.0${NC}"
echo -e "${BLUE}=======================================${NC}"
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

# Detect existing setup type
detect_existing_setup() {
    if [ -d "memory-bank" ]; then
        if [ -d "memory-bank/shared" ]; then
            echo -e "${CYAN}Detected existing multi-project Memory Bank${NC}"
            SETUP_TYPE="multi"
            return 0
        else
            echo -e "${CYAN}Detected existing single-project Memory Bank${NC}"
            SETUP_TYPE="single"
            return 0
        fi
    fi
    return 1
}

# Choose setup type
choose_setup_type() {
    if detect_existing_setup; then
        if [ "$SETUP_TYPE" = "multi" ]; then
            echo ""
            echo -e "${YELLOW}This is a multi-project repository.${NC}"
            echo "Would you like to:"
            echo "1) Add a new project to the existing structure"
            echo "2) Reinitialize the entire memory bank (backup existing)"
            echo "3) Cancel"
            read -p "Choose an option (1-3): " -n 1 -r
            echo ""
            
            case $REPLY in
                1)
                    read -p "Enter the new project name: " PROJECT_NAME
                    if [ -z "$PROJECT_NAME" ]; then
                        echo -e "${RED}Project name cannot be empty.${NC}"
                        exit 1
                    fi
                    if [ -d "memory-bank/$PROJECT_NAME" ]; then
                        echo -e "${RED}Project '$PROJECT_NAME' already exists.${NC}"
                        exit 1
                    fi
                    ;;
                2)
                    echo "Backing up existing memory-bank to memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
                    mv memory-bank "memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
                    choose_new_setup_type
                    ;;
                *)
                    echo "Setup cancelled."
                    exit 0
                    ;;
            esac
        else
            # Single project exists
            echo -e "${YELLOW}Memory bank already exists in this directory.${NC}"
            read -p "Do you want to reinitialize? This will backup existing files. (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Backing up existing memory-bank to memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
                mv memory-bank "memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
                choose_new_setup_type
            else
                echo "Setup cancelled."
                exit 0
            fi
        fi
    else
        choose_new_setup_type
    fi
}

# Choose new setup type
choose_new_setup_type() {
    echo ""
    echo -e "${CYAN}Choose Memory Bank setup type:${NC}"
    echo "1) Single-project repository (default)"
    echo "2) Multi-project repository"
    read -p "Choose an option (1-2) [1]: " -n 1 -r
    echo ""
    
    case $REPLY in
        2)
            SETUP_TYPE="multi"
            echo ""
            echo -e "${YELLOW}Multi-project setup selected.${NC}"
            echo "You can add projects later using: setup-memory-bank.sh --add-project"
            ;;
        *)
            SETUP_TYPE="single"
            echo -e "${YELLOW}Single-project setup selected.${NC}"
            ;;
    esac
}

# Create memory bank structure
create_structure() {
    echo -e "${YELLOW}Creating memory bank structure...${NC}"
    
    if [ "$SETUP_TYPE" = "multi" ]; then
        # Multi-project structure
        mkdir -p memory-bank/shared
        mkdir -p memory-bank/custom_modes
        mkdir -p memory-bank/scripts
        
        # Create shared files
        create_shared_files
        
        if [ -n "$PROJECT_NAME" ]; then
            # Adding a new project to existing multi-project
            create_project_structure "$PROJECT_NAME"
        fi
    else
        # Single-project structure
        mkdir -p memory-bank/custom_modes
        mkdir -p memory-bank/context
        mkdir -p memory-bank/active
        mkdir -p memory-bank/technical
        mkdir -p memory-bank/decisions
        mkdir -p memory-bank/qa
        mkdir -p memory-bank/scripts
        
        # Copy context templates
        copy_context_templates "memory-bank/context"
    fi
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# Create project structure for multi-project
create_project_structure() {
    local project="$1"
    echo -e "${YELLOW}Creating structure for project: $project${NC}"
    
    mkdir -p "memory-bank/$project/context"
    mkdir -p "memory-bank/$project/active"
    mkdir -p "memory-bank/$project/technical"
    mkdir -p "memory-bank/$project/decisions"
    mkdir -p "memory-bank/$project/qa"
    
    # Copy context templates
    copy_context_templates "memory-bank/$project/context"
    
    # Create project-specific templates
    create_templates_for_project "$project"
}

# Create shared files for multi-project
create_shared_files() {
    echo -e "${YELLOW}Creating shared files...${NC}"
    
    # patterns.md
    cat > memory-bank/shared/patterns.md << 'EOF'
# Shared Patterns

Patterns that are reusable across multiple projects.

## Code Patterns

### Error Handling
*To be populated as patterns are discovered*

### API Communication
*To be populated as patterns are discovered*

### Data Validation
*To be populated as patterns are discovered*

## Architectural Patterns

### Component Structure
*To be populated as patterns are discovered*

### Service Communication
*To be populated as patterns are discovered*

---
*This file contains patterns that have proven useful across multiple projects.*
EOF

    # conventions.md
    cat > memory-bank/shared/conventions.md << 'EOF'
# Shared Conventions

Global coding standards and conventions for all projects.

## Naming Conventions

### Files and Directories
- Use kebab-case for file names
- Use PascalCase for component files
- Group related files in directories

### Code
- Use camelCase for variables and functions
- Use PascalCase for classes and types
- Use UPPER_SNAKE_CASE for constants

## Code Style

### General
- Prefer explicit over implicit
- Write self-documenting code
- Keep functions small and focused

### Documentation
- Document complex logic
- Use JSDoc/docstrings for public APIs
- Keep comments up to date

---
*Update these conventions as team standards evolve.*
EOF
}

# Copy mode instruction files
copy_mode_files() {
    echo -e "${YELLOW}Installing mode instruction files...${NC}"
    
    # Copy all mode instruction files
    cp "$TEMPLATE_DIR/memory-bank/custom_modes/"*.md memory-bank/custom_modes/
    
    echo -e "${GREEN}✓ Mode instruction files installed${NC}"
}

# Create CLAUDE.md configuration
create_claude_config() {
    echo -e "${YELLOW}Creating Claude Code configuration...${NC}"
    
    # Copy the CLAUDE.md template
    cp "$TEMPLATE_DIR/CLAUDE.md" ./
    
    echo -e "${GREEN}✓ Claude Code configuration created${NC}"
}

# Create template files
create_templates() {
    echo -e "${YELLOW}Creating template files...${NC}"
    
    if [ "$SETUP_TYPE" = "multi" ]; then
        # Multi-project - no templates at root level
        echo -e "${CYAN}Templates will be created when projects are added${NC}"
    else
        # Single-project templates
        create_single_project_templates
    fi
}

# Copy context file templates
copy_context_templates() {
    local context_dir="$1"
    local active_dir="${context_dir%/context}/active"
    
    # Copy context templates if files don't exist
    if [ ! -f "$context_dir/projectBrief.md" ] && [ -f "$TEMPLATE_DIR/templates/projectBrief.md" ]; then
        cp "$TEMPLATE_DIR/templates/projectBrief.md" "$context_dir/"
        echo "   ✓ Created projectBrief.md from template"
    fi
    
    if [ ! -f "$context_dir/productContext.md" ] && [ -f "$TEMPLATE_DIR/templates/productContext.md" ]; then
        cp "$TEMPLATE_DIR/templates/productContext.md" "$context_dir/"
        echo "   ✓ Created productContext.md from template"
    fi
    
    if [ ! -f "$context_dir/systemPatterns.md" ] && [ -f "$TEMPLATE_DIR/templates/systemPatterns.md" ]; then
        cp "$TEMPLATE_DIR/templates/systemPatterns.md" "$context_dir/"
        echo "   ✓ Created systemPatterns.md from template"
    fi
    
    if [ ! -f "$context_dir/techContext.md" ] && [ -f "$TEMPLATE_DIR/templates/techContext.md" ]; then
        cp "$TEMPLATE_DIR/templates/techContext.md" "$context_dir/"
        echo "   ✓ Created techContext.md from template"
    fi
    
    # Copy active templates if they don't exist
    if [ ! -f "$active_dir/activeContext.md" ] && [ -f "$TEMPLATE_DIR/templates/activeContext.md" ]; then
        cp "$TEMPLATE_DIR/templates/activeContext.md" "$active_dir/"
        echo "   ✓ Created activeContext.md from template"
    fi
    
    if [ ! -f "$active_dir/progress.md" ] && [ -f "$TEMPLATE_DIR/templates/progress.md" ]; then
        cp "$TEMPLATE_DIR/templates/progress.md" "$active_dir/"
        echo "   ✓ Created progress.md from template"
    fi
}

# Create templates for single project
create_single_project_templates() {
    # Create tasks.md
    cat > memory-bank/active/tasks.md << 'EOF'
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

## Progress Tracking
- VAN: ⏸️ Not started
- PLAN: ⏸️ Not started
- IMPLEMENT: ⏸️ Not started
- REFLECT: ⏸️ Not started

---
*This file is managed by the Claude Memory Bank system.*
*Original methodology by @vanzan01, adapted for Claude Code.*
EOF

    # Create activeContext.md
    cat > memory-bank/active/activeContext.md << 'EOF'
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
    cat > memory-bank/active/progress.md << 'EOF'
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
To be populated during PLAN mode (Level 3 complexity).

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

# Create templates for a specific project in multi-project setup
create_templates_for_project() {
    local project="$1"
    echo -e "${YELLOW}Creating templates for project: $project${NC}"
    
    # Create tasks.md
    cat > "memory-bank/$project/active/tasks.md" << EOF
# Memory Bank Tasks - $project

> **Central Source of Truth for Task Tracking**
> 
> This file tracks tasks for the $project project.

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

## Progress Tracking
- VAN: ⏸️ Not started
- PLAN: ⏸️ Not started
- IMPLEMENT: ⏸️ Not started
- REFLECT: ⏸️ Not started

---
*Project: $project*
*Memory Bank System v2.0*
EOF

    # Create activeContext.md
    cat > "memory-bank/$project/active/activeContext.md" << EOF
# Active Context - $project

## Current Focus
No active task. Initialize with VAN mode.

## Current Mode
VAN (Ready to initialize)

## Next Actions
1. Run \`@VAN\` command to analyze project and create initial task breakdown
2. Follow workflow progression based on complexity assessment

## Context Notes
Project initialized but not yet analyzed.

---
*Project: $project*
*Last updated: Setup*
EOF

    # Create progress.md
    cat > "memory-bank/$project/active/progress.md" << EOF
# Progress Tracking - $project

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
*Project: $project*
*Last updated: Setup*
EOF

    # Create initial log file in decisions
    cat > "memory-bank/$project/decisions/log.md" << EOF
# Decision Log - $project

## Project Decisions
No decisions recorded yet.

## Architectural Decisions
To be populated during PLAN mode (Level 2+ complexity).

## Implementation Decisions
To be populated during IMPLEMENT mode.

---
*Project: $project*
*This file tracks important decisions made during the development process.*
EOF

    # Create validation results template
    cat > "memory-bank/$project/qa/validation-results.md" << EOF
# Validation Results - $project

## Quality Assurance Results
No validations performed yet.

## Test Results
To be populated during IMPLEMENT and REFLECT modes.

## Code Quality Metrics
To be measured and recorded here.

---
*Project: $project*
*This file tracks quality assurance and validation results.*
EOF
}

# Copy automation scripts
copy_scripts() {
    echo -e "${YELLOW}Installing automation scripts...${NC}"
    
    # Copy automation scripts
    if [ -f "$TEMPLATE_DIR/memory-bank/scripts/auto-update.py" ]; then
        cp "$TEMPLATE_DIR/memory-bank/scripts/auto-update.py" memory-bank/scripts/
        echo "  ✓ Copied auto-update.py"
    fi
    
    # Copy hierarchy scripts for hierarchical projects
    if [ -f "$TEMPLATE_DIR/memory-bank/scripts/setup-hierarchy.sh" ]; then
        cp "$TEMPLATE_DIR/memory-bank/scripts/setup-hierarchy.sh" memory-bank/scripts/
        chmod +x memory-bank/scripts/setup-hierarchy.sh
        echo "  ✓ Copied setup-hierarchy.sh"
    fi
    
    if [ -f "$TEMPLATE_DIR/memory-bank/scripts/detect-hierarchy.py" ]; then
        cp "$TEMPLATE_DIR/memory-bank/scripts/detect-hierarchy.py" memory-bank/scripts/
        chmod +x memory-bank/scripts/detect-hierarchy.py
        echo "  ✓ Copied detect-hierarchy.py"
    fi
    
    if [ -f "$TEMPLATE_DIR/memory-bank/scripts/auto-setup-hierarchy.py" ]; then
        cp "$TEMPLATE_DIR/memory-bank/scripts/auto-setup-hierarchy.py" memory-bank/scripts/
        chmod +x memory-bank/scripts/auto-setup-hierarchy.py
        echo "  ✓ Copied auto-setup-hierarchy.py"
    fi
    
    echo -e "${GREEN}✓ Automation scripts installed${NC}"
}

# Create starter prompt
create_starter_prompt() {
    echo -e "${YELLOW}Creating starter prompt...${NC}"
    
    # Copy starter prompt
    cp "$TEMPLATE_DIR/starter-prompt.md" ./
    
    # Copy quick reference card
    cp "$TEMPLATE_DIR/QUICK-REFERENCE.md" ./
    
    # Copy setup script to project root for easy access
    cp "$0" ./setup-memory-bank.sh
    chmod +x ./setup-memory-bank.sh
    echo -e "${CYAN}✓ Copied setup-memory-bank.sh to project root${NC}"
    
    # Copy memory-bank-ignore template if hierarchical structure detected
    if [ -f "$TEMPLATE_DIR/templates/memory-bank-ignore" ]; then
        cp "$TEMPLATE_DIR/templates/memory-bank-ignore" ./
        echo -e "${CYAN}✓ Created memory-bank-ignore for hierarchy control${NC}"
    fi
    
    echo -e "${GREEN}✓ Starter prompt and quick reference created${NC}"
}

# Hierarchy detection
detect_hierarchy() {
    echo -e "${YELLOW}Checking for hierarchical project structure...${NC}"
    
    # Count .git directories
    local git_count=$(find . -name ".git" -type d -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l)
    
    if [ "$git_count" -gt 1 ]; then
        echo -e "${CYAN}⚠️  Hierarchical structure detected: Found $git_count git repositories${NC}"
        echo ""
        echo "This appears to be a hierarchical project with nested repositories."
        echo "Memory Bank v2.1 supports hierarchy through distributed setup."
        echo ""
        echo "Note: The 'multi-project' option manages multiple projects in THIS repository."
        echo "      For nested git repos, each should have its own Memory Bank."
        echo ""
        echo "Options:"
        echo "1) Setup Memory Bank only in current directory"
        echo "2) Show detected repositories and exit"
        echo "3) Auto-setup in all repositories (if available)"
        read -p "Choose an option [1]: " -n 1 -r
        echo ""
        
        if [[ $REPLY == "2" ]]; then
            echo -e "${YELLOW}Detected repositories:${NC}"
            find . -name ".git" -type d -not -path "*/node_modules/*" -not -path "*/.git/*" | while read gitdir; do
                echo "  - $(dirname "$gitdir")"
            done
            echo ""
            echo "To set up Memory Bank in each repository:"
            echo "  Option 1: Complete setup here first, then run:"
            echo "           ./setup-memory-bank.sh (will be copied to project root)"
            echo "  Option 2: After setup, use automated setup:"
            echo "           python memory-bank/scripts/auto-setup-hierarchy.py"
            echo "           OR"
            echo "           bash memory-bank/scripts/setup-hierarchy.sh"
            exit 0
        elif [[ $REPLY == "3" ]]; then
            # Check if setup-memory-bank.sh exists locally (means we already ran setup here)
            if [ -f "./setup-memory-bank.sh" ] && [ -x "./setup-memory-bank.sh" ]; then
                echo -e "${CYAN}Using local setup script for hierarchical setup...${NC}"
                echo ""
                # The hierarchy script will use this local copy
                if [ -f "memory-bank/scripts/setup-hierarchy.sh" ]; then
                    bash "memory-bank/scripts/setup-hierarchy.sh"
                else
                    echo -e "${YELLOW}Running basic hierarchical setup...${NC}"
                    find . -name ".git" -type d -not -path "*/node_modules/*" -not -path "*/.git/*" | while read gitdir; do
                        repo=$(dirname "$gitdir")
                        if [ "$repo" != "." ]; then
                            echo "Setting up: $repo"
                            (cd "$repo" && ../setup-memory-bank.sh --single)
                        fi
                    done
                fi
                exit 0
            elif [ -f "memory-bank/scripts/setup-hierarchy.sh" ]; then
                echo -e "${CYAN}Launching automated hierarchical setup...${NC}"
                bash "memory-bank/scripts/setup-hierarchy.sh"
                exit 0
            elif [ -f "$TEMPLATE_DIR/memory-bank/scripts/setup-hierarchy.sh" ]; then
                echo -e "${CYAN}Launching automated hierarchical setup...${NC}"
                bash "$TEMPLATE_DIR/memory-bank/scripts/setup-hierarchy.sh"
                exit 0
            else
                echo -e "${YELLOW}Please complete the current setup first.${NC}"
                echo "After setup, you'll have these options:"
                echo "  1. ./setup-memory-bank.sh (in each sub-directory)"
                echo "  2. python memory-bank/scripts/auto-setup-hierarchy.py"
                echo "  3. bash memory-bank/scripts/setup-hierarchy.sh"
                echo ""
                echo "Continuing with current directory setup..."
            fi
        fi
    fi
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
    
    # Add project-specific patterns to technical folder
    case $project_type in
        "javascript")
            echo "# JavaScript Project Patterns" > memory-bank/technical/javascript-patterns.md
            echo "" >> memory-bank/technical/javascript-patterns.md
            echo "- Review package.json dependencies" >> memory-bank/technical/javascript-patterns.md
            echo "- Consider npm scripts and build process" >> memory-bank/technical/javascript-patterns.md
            echo "- Check for TypeScript configuration" >> memory-bank/technical/javascript-patterns.md
            ;;
        "python")
            echo "# Python Project Patterns" > memory-bank/technical/python-patterns.md
            echo "" >> memory-bank/technical/python-patterns.md
            echo "- Review requirements and virtual environment" >> memory-bank/technical/python-patterns.md
            echo "- Consider testing framework (pytest, unittest)" >> memory-bank/technical/python-patterns.md
            echo "- Check for type hints and docstrings" >> memory-bank/technical/python-patterns.md
            ;;
        "rust")
            echo "# Rust Project Patterns" > memory-bank/technical/rust-patterns.md
            echo "" >> memory-bank/technical/rust-patterns.md
            echo "- Review Cargo.toml dependencies" >> memory-bank/technical/rust-patterns.md
            echo "- Consider Rust testing and documentation patterns" >> memory-bank/technical/rust-patterns.md
            echo "- Check for clippy and fmt configuration" >> memory-bank/technical/rust-patterns.md
            ;;
    esac
}

# Display next steps
show_next_steps() {
    echo ""
    echo -e "${GREEN}Memory Bank setup complete!${NC}"
    echo ""
    echo -e "${BLUE}Repository Type: ${CYAN}${SETUP_TYPE^}-project${NC}"
    if [ -n "$PROJECT_NAME" ]; then
        echo -e "${BLUE}Project Added: ${CYAN}$PROJECT_NAME${NC}"
    fi
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Review the starter-prompt.md file for initialization instructions"
    echo "2. Start Claude Code and load the CLAUDE.md configuration"
    echo "3. Use the @VAN command to begin your first workflow"
    
    if [ "$SETUP_TYPE" = "multi" ]; then
        echo ""
        echo -e "${BLUE}Multi-Project Commands:${NC}"
        echo "  setup-memory-bank.sh --add-project    - Add a new project"
        echo "  python memory-bank/scripts/auto-update.py --list-projects"
        echo ""
        echo -e "${BLUE}When using automation:${NC}"
        echo "  python memory-bank/scripts/auto-update.py --health-check --project-name <name>"
    fi
    
    echo ""
    echo -e "${BLUE}Available Mode Commands:${NC}"
    echo "  @VAN        - Initialize and create/update context files"
    echo "  @PLAN       - Create strategy with integrated design (Level 2-3)"
    echo "  @IMPLEMENT  - Build following context and plan"
    echo "  @REFLECT    - Validate and update context with learnings"
    echo ""
    echo -e "${BLUE}Key Files Created:${NC}"
    echo "  CLAUDE.md                    - Claude Code configuration"
    echo "  starter-prompt.md            - Initialization instructions"
    
    if [ "$SETUP_TYPE" = "multi" ]; then
        echo "  memory-bank/shared/          - Cross-project patterns and conventions"
        if [ -n "$PROJECT_NAME" ]; then
            echo "  memory-bank/$PROJECT_NAME/   - Project-specific memory bank"
        fi
    else
        echo "  memory-bank/context/         - Foundation files (4 context files)"
        echo "  memory-bank/active/          - Current work tracking"
        echo "  memory-bank/technical/       - Deep implementation docs"
        echo "  memory-bank/decisions/       - Design decisions and rationale"
    fi
    
    echo ""
    echo -e "${YELLOW}Original methodology by @vanzan01${NC}"
    echo -e "${YELLOW}Memory Bank System v2.0 - Context-Driven Workflow${NC}"
}

# Main setup process
main() {
    verify_installation
    detect_hierarchy
    choose_setup_type
    create_structure
    
    # Only copy mode files for single project
    if [ "$SETUP_TYPE" = "single" ] || [ -z "$PROJECT_NAME" ]; then
        copy_mode_files
    fi
    
    create_claude_config
    create_templates
    copy_scripts
    create_starter_prompt
    
    # Only detect project type for single project
    if [ "$SETUP_TYPE" = "single" ]; then
        detect_project_type
    fi
    
    show_next_steps
}

# Add project to existing multi-project setup
add_project() {
    if [ ! -d "memory-bank/shared" ]; then
        echo -e "${RED}Error: This is not a multi-project Memory Bank.${NC}"
        echo "Current directory must contain a multi-project Memory Bank setup."
        exit 1
    fi
    
    read -p "Enter the project name: " PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${RED}Project name cannot be empty.${NC}"
        exit 1
    fi
    
    if [ -d "memory-bank/$PROJECT_NAME" ]; then
        echo -e "${RED}Project '$PROJECT_NAME' already exists.${NC}"
        exit 1
    fi
    
    SETUP_TYPE="multi"
    create_project_structure "$PROJECT_NAME"
    show_next_steps
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Claude Memory Bank Project Setup v2.0"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h        Show this help message"
        echo "  --add-project     Add a new project to existing multi-project setup"
        echo "  --single          Force single-project setup (no prompts)"
        echo "  --multi           Force multi-project setup (no prompts)"
        echo ""
        echo "This script initializes the Claude Memory Bank system in the current directory."
        echo "It supports both single-project and multi-project repositories."
        exit 0
        ;;
    --add-project)
        verify_installation
        add_project
        ;;
    --single)
        SETUP_TYPE="single"
        verify_installation
        if [ -d "memory-bank" ]; then
            echo "Backing up existing memory-bank to memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
            mv memory-bank "memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        create_structure
        copy_mode_files
        create_claude_config
        create_templates
        copy_scripts
        create_starter_prompt
        detect_project_type
        show_next_steps
        ;;
    --multi)
        SETUP_TYPE="multi"
        verify_installation
        if [ -d "memory-bank" ]; then
            echo "Backing up existing memory-bank to memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
            mv memory-bank "memory-bank.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        create_structure
        copy_mode_files
        create_claude_config
        create_templates
        copy_scripts
        create_starter_prompt
        show_next_steps
        ;;
    *)
        main
        ;;
esac