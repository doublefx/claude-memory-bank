#!/bin/bash

# Memory Bank Hierarchical Setup Script v3
# Automatically sets up Memory Bank in all detected git repositories
# Fixed repository detection

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Memory Bank Hierarchical Setup${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

# Save the user's working directory
USER_DIR="$(pwd)"
echo "Running from: $USER_DIR"

# Check if detect-hierarchy.py exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DETECT_SCRIPT="$SCRIPT_DIR/detect-hierarchy.py"

if [ ! -f "$DETECT_SCRIPT" ]; then
    echo -e "${RED}Error: detect-hierarchy.py not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Find the setup script
SETUP_SCRIPT=""
if command -v claude-memory-setup &> /dev/null; then
    SETUP_SCRIPT="claude-memory-setup"
    echo -e "${GREEN}✓ Found setup command: claude-memory-setup${NC}"
elif [ -f "$USER_DIR/setup-memory-bank.sh" ]; then
    SETUP_SCRIPT="$USER_DIR/setup-memory-bank.sh"
    echo -e "${GREEN}✓ Found local setup script${NC}"
elif [ -f "$SCRIPT_DIR/../../setup-memory-bank.sh" ]; then
    SETUP_SCRIPT="$SCRIPT_DIR/../../setup-memory-bank.sh"
    echo -e "${GREEN}✓ Found setup script in template directory${NC}"
else
    echo -e "${RED}Error: setup-memory-bank.sh not found${NC}"
    echo "Please ensure setup-memory-bank.sh is in your PATH or current directory"
    exit 1
fi

# Detect git repositories from the user's directory
echo -e "${YELLOW}Detecting git repositories...${NC}"
cd "$USER_DIR"

# Use find to detect git repositories directly
repos=()
while IFS= read -r git_dir; do
    # Convert .git directory to repository path
    repo_path=$(dirname "$git_dir")
    # Make it relative to current directory
    if [ "$repo_path" = "." ]; then
        repos+=(".")
    else
        rel_path=$(realpath --relative-to="$USER_DIR" "$repo_path")
        repos+=("$rel_path")
    fi
done < <(find . -maxdepth 6 -name ".git" -type d 2>/dev/null | sort)

if [ ${#repos[@]} -eq 0 ]; then
    echo -e "${RED}No git repositories found in $USER_DIR${NC}"
    exit 1
fi

echo "Found ${#repos[@]} git repositories:"
for repo in "${repos[@]}"; do
    echo "  - $repo"
done
echo ""

# Ask user what to do
echo -e "${YELLOW}Setup Options:${NC}"
echo "1) Setup Memory Bank in ALL repositories automatically"
echo "2) Setup only in root repository"
echo "3) Choose which repositories to setup"
echo "4) Cancel"
echo ""
read -p "Select option (1-4): " choice

case $choice in
    1)
        selected_repos=("${repos[@]}")
        echo -e "\n${YELLOW}Setting up Memory Bank in all repositories...${NC}\n"
        ;;
    2)
        selected_repos=(".")
        echo -e "\n${YELLOW}Setting up Memory Bank in root repository only...${NC}\n"
        ;;
    3)
        selected_repos=()
        echo -e "\n${YELLOW}Select repositories to setup:${NC}"
        for i in "${!repos[@]}"; do
            echo "$((i+1))) ${repos[$i]}"
        done
        echo ""
        read -p "Enter repository numbers (comma-separated, e.g., 1,3,4): " selections
        IFS=',' read -ra indices <<< "$selections"
        for index in "${indices[@]}"; do
            index=$((index-1))
            if [ $index -ge 0 ] && [ $index -lt ${#repos[@]} ]; then
                selected_repos+=("${repos[$index]}")
            fi
        done
        ;;
    4)
        echo -e "${YELLOW}Setup cancelled${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

# Setup selected repositories
success_count=0
failed_repos=()

# Process each repository in a separate bash process to avoid exit issues
for repo in "${selected_repos[@]}"; do
    echo -e "${BLUE}Setting up: $repo${NC}"
    echo "----------------------------------------"
    
    # Create a temporary script for each setup to avoid subshell exit issues
    temp_script=$(mktemp)
    cat > "$temp_script" << 'SETUP_SCRIPT'
#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

repo="$1"
user_dir="$2"
SETUP_SCRIPT="$3"

cd "$user_dir"
if [ "$repo" != "." ]; then
    cd "$repo"
fi

# Check if .memory-bank already exists
if [ -d ".memory-bank" ]; then
    echo -e "${CYAN}Memory Bank already exists in $repo, skipping...${NC}"
    exit 0
fi

# Run setup
if [ "$repo" != "." ] && [ -f "../setup-memory-bank.sh" ]; then
    # Use parent's local copy for consistency
    ../setup-memory-bank.sh --single < /dev/null
    echo -e "${GREEN}✓ Successfully setup Memory Bank in $repo (using parent's script)${NC}"
elif [ -f "./setup-memory-bank.sh" ]; then
    # Use local copy if available
    ./setup-memory-bank.sh --single < /dev/null
    echo -e "${GREEN}✓ Successfully setup Memory Bank in $repo (using local script)${NC}"
elif [ -n "$SETUP_SCRIPT" ]; then
    # Fall back to specified script
    "$SETUP_SCRIPT" --single < /dev/null
    echo -e "${GREEN}✓ Successfully setup Memory Bank in $repo${NC}"
else
    echo -e "${RED}✗ Failed to find setup script for $repo${NC}"
    exit 1
fi

# Create hierarchy.json if not root
if [ "$repo" != "." ]; then
    echo -e "${YELLOW}Creating hierarchy reference...${NC}"
    
    # Calculate relative path to parent
    depth=$(echo "$repo" | tr -cd '/' | wc -c)
    parent_path=$(printf '../%.0s' $(seq 1 $((depth + 1))))
    parent_path="${parent_path%/}"
    
    # Create hierarchy.json
    cat > .memory-bank/hierarchy.json << EOF
{
  "version": "2.1",
  "current_project": {
    "path": ".",
    "name": "$(basename "$repo")",
    "type": "single-project"
  },
  "parent": {
    "path": "$parent_path",
    "memory_bank_path": "$parent_path/.memory-bank",
    "relationship": "subdirectory",
    "inherit_conventions": true,
    "inherit_patterns": "if_not_exists"
  },
  "pattern_resolution": {
    "strategy": "child_first",
    "inherit_from_parent": ["conventions", "shared_patterns"],
    "override_in_child": ["project_patterns", "technical_patterns"]
  },
  "references": {
    "parent_patterns": "$parent_path/.memory-bank/shared/patterns.md",
    "parent_conventions": "$parent_path/.memory-bank/shared/conventions.md"
  }
}
EOF
    echo -e "${GREEN}✓ Created hierarchy.json with parent reference${NC}"
fi
SETUP_SCRIPT
    
    chmod +x "$temp_script"
    
    # Run the setup script in a separate bash process
    if bash "$temp_script" "$repo" "$USER_DIR" "$SETUP_SCRIPT"; then
        success_count=$((success_count + 1))
    else
        failed_repos+=("$repo")
    fi
    
    # Clean up temp script
    rm -f "$temp_script"
    
    echo ""
done

# Summary
echo -e "${BLUE}Setup Summary${NC}"
echo "============="
echo -e "${GREEN}✓ Successfully setup: $success_count repositories${NC}"
if [ ${#failed_repos[@]} -gt 0 ]; then
    echo -e "${RED}✗ Failed: ${#failed_repos[@]} repositories${NC}"
    for repo in "${failed_repos[@]}"; do
        echo "  - $repo"
    done
fi

echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Review each project's context files in .memory-bank/context/"
echo "2. Update project-specific information in:"
echo "   - projectBrief.md"
echo "   - productContext.md"
echo "   - systemPatterns.md"
echo "   - techContext.md"
echo "3. Use @VAN mode to initialize each project's workflow"

if [ ${#selected_repos[@]} -gt 1 ]; then
    echo ""
    echo -e "${YELLOW}Tip: Child projects inherit patterns from parent via hierarchy.json${NC}"
fi