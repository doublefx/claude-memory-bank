# Hierarchical Project Support for Memory Bank v2.1

## Overview

Support for hierarchical project structures where projects contain other projects (submodules, nested repos, etc.). This design enables Memory Bank to work seamlessly across project boundaries while maintaining context isolation and enabling knowledge sharing.

## Detection Strategy

### Git-Based Detection
Use `.git` directories as project boundary markers:
```bash
# Find all git repositories in the tree
find . -name ".git" -type d | while read gitdir; do
    project_root=$(dirname "$gitdir")
    # Check if project has its own .memory-bank
done[HIERARCHY-EXAMPLE.md](HIERARCHY-EXAMPLE.md)[HIERARCHY-EXAMPLE.md](HIERARCHY-EXAMPLE.md)
```

### Memory Bank Location Strategies

#### Strategy 1: Distributed Memory Banks (Recommended)
Each git repository maintains its own `.memory-bank/`:
```
platform/ (.git)
├── .memory-bank/          # Platform-level memory bank
│   ├── context/
│   ├── active/
│   └── links/             # References to child projects
│       ├── services.link  # -> ../services/.memory-bank
│       └── libs.link      # -> ../libs/*/.memory-bank
├── services/ (.git)
│   └── .memory-bank/      # Services-level memory bank
│       ├── shared/
│       ├── api/
│       └── worker/
└── libs/
    ├── lib-a/ (.git)
    │   └── .memory-bank/  # Library-specific memory bank
    └── lib-b/ (.git)
        └── .memory-bank/
```

#### Strategy 2: Centralized with Links
Single .memory-bank at root with symbolic links:
```
platform/ (.git)
├── .memory-bank/
│   ├── platform/          # Root project context
│   ├── services/          # Link to services/.memory-bank
│   └── libs/
│       ├── lib-a/         # Link to libs/lib-a/.memory-bank
│       └── lib-b/         # Link to libs/lib-b/.memory-bank
```

## Implementation Changes

### 1. Setup Script Updates

```bash
# setup-memory-bank.sh additions

detect_hierarchy() {
    echo "Detecting project hierarchy..."
    
    # Find all .git directories
    local git_dirs=$(find . -name ".git" -type d -not -path "*/node_modules/*" 2>/dev/null)
    
    if [ $(echo "$git_dirs" | wc -l) -gt 1 ]; then
        echo "Hierarchical structure detected:"
        echo "$git_dirs" | while read gitdir; do
            local proj_root=$(dirname "$gitdir")
            echo "  - $proj_root"
        done
        
        echo ""
        echo "Setup options:"
        echo "1) Distributed - Each project gets its own .memory-bank"
        echo "2) Centralized - Single .memory-bank with links"
        echo "3) Custom - Choose per project"
        read -p "Choose approach [1]: " approach
    fi
}

setup_hierarchical() {
    local approach="$1"
    
    case $approach in
        "distributed")
            # Create .memory-bank in each git repo
            find . -name ".git" -type d | while read gitdir; do
                local proj_root=$(dirname "$gitdir")
                (cd "$proj_root" && setup-memory-bank.sh --auto)
            done
            ;;
        "centralized")
            # Create central .memory-bank with links
            create_central_hierarchy
            ;;
    esac
}
```

### 2. VAN Mode Updates

VAN mode needs to understand hierarchical relationships:

```markdown
## Hierarchical Project Detection

### On Startup:
1. Check current directory for .memory-bank
2. Search upward for parent .memory-bank
3. Search downward for child .memory-bank
4. Build project hierarchy map

### Context Loading:
```bash
# Load in order:
1. Parent project shared context (if exists)
2. Current project context
3. Child project summaries (if relevant)
```

### Cross-Project References:
- Use relative paths: `../parent/.memory-bank/shared/patterns.md`
- Or links: `./links/parent-patterns.md -> ../parent/.memory-bank/shared/patterns.md`
```

### 3. Auto-Update Script Changes

```python
class HierarchicalMemoryBank(MemoryBankAutomation):
    def __init__(self, project_root=".", project_name=None):
        super().__init__(project_root, project_name)
        self.hierarchy = self.detect_hierarchy()
        
    def detect_hierarchy(self):
        """Detect project hierarchy based on .git directories"""
        hierarchy = {
            "current": self.project_root,
            "parent": None,
            "children": [],
            "siblings": []
        }
        
        # Find parent with .memory-bank
        current = Path(self.project_root).parent
        while current != current.parent:
            if (current / ".memory-bank").exists():
                hierarchy["parent"] = current
                break
            if (current / ".git").exists():
                # Parent project without .memory-bank
                hierarchy["parent"] = current
                break
            current = current.parent
        
        # Find children with .git
        for git_dir in Path(self.project_root).rglob(".git"):
            if git_dir.is_dir() and git_dir.parent != Path(self.project_root):
                child_root = git_dir.parent
                if (child_root / ".memory-bank").exists():
                    hierarchy["children"].append({
                        "path": child_root,
                        "has_memory_bank": True
                    })
        
        return hierarchy
    
    def aggregate_patterns(self):
        """Aggregate patterns from hierarchy"""
        patterns = {}
        
        # Parent patterns (inherited)
        if self.hierarchy["parent"]:
            parent_patterns = self.hierarchy["parent"] / ".memory-bank/shared/patterns.md"
            if parent_patterns.exists():
                patterns["inherited"] = self.read_patterns(parent_patterns)
        
        # Current patterns
        patterns["local"] = self.scan_and_update_patterns()
        
        # Child patterns (aggregated)
        patterns["children"] = {}
        for child in self.hierarchy["children"]:
            if child["has_memory_bank"]:
                child_patterns = child["path"] / ".memory-bank/context/systemPatterns.md"
                if child_patterns.exists():
                    patterns["children"][child["path"].name] = self.read_patterns(child_patterns)
        
        return patterns
```

### 4. New Directory Structure

```
.memory-bank/
├── hierarchy/                    # Hierarchical relationship info
│   ├── map.json                 # Project hierarchy map
│   ├── parent.link -> ../..     # Link to parent project
│   └── children/                # Links to child projects
├── shared/                      # Shared resources
│   ├── patterns.md             # Local + inherited patterns
│   └── conventions.md          # Local + inherited conventions
└── [standard structure]
```

### 5. Cross-Project Commands

```bash
# Navigate hierarchy
python auto-update.py --show-hierarchy
python auto-update.py --aggregate-patterns --include-children
python auto-update.py --sync-from-parent
python auto-update.py --promote-to-parent

# Cross-project operations
@VAN --scan-hierarchy     # Scan entire hierarchy
@PLAN --consider-parent   # Include parent context
@REFLECT --share-upward   # Promote patterns to parent
```

## Benefits

1. **Context Inheritance**: Child projects inherit patterns from parents
2. **Isolated Development**: Each project maintains its own context
3. **Knowledge Bubbling**: Patterns can be promoted upward
4. **Flexible Structure**: Works with any git-based hierarchy
5. **Gradual Adoption**: Projects can add Memory Bank independently

## Migration Path

For existing Memory Bank installations:
1. Run detection to identify hierarchy
2. Choose distributed or centralized approach
3. Run migration script to restructure
4. Update links and references

## Example Scenarios

### Scenario 1: Microservices in Monorepo
```
platform/
├── memory-bank/              # Platform patterns
└── services/
    ├── auth/ (.git)
    │   └── memory-bank/      # Auth-specific patterns
    └── api/ (.git)
        └── memory-bank/      # API-specific patterns
```

### Scenario 2: Library Development
```
sdk/
├── memory-bank/              # SDK-wide patterns
├── core/ (.git)
│   └── memory-bank/         # Core library patterns
└── plugins/
    ├── plugin-a/ (.git)
    │   └── memory-bank/     # Plugin A patterns
    └── plugin-b/ (.git)
        └── memory-bank/     # Plugin B patterns
```

## Known Issues & Fixes

### Issue: Multi-project setup in hierarchical structure
When choosing multi-project setup in a hierarchical structure, the setup may fail with:
```
cp: target 'memory-bank/custom_modes/': No such file or directory
```

**Fix**: Ensure `custom_modes` and `scripts` directories are created for multi-project setup:
```bash
mkdir -p memory-bank/shared
mkdir -p memory-bank/custom_modes  # Add this
mkdir -p memory-bank/scripts       # Add this
```

### Clarification: Multi-project vs Hierarchical
- **Multi-project**: Multiple projects in the SAME repository (no nested .git)
- **Hierarchical**: Nested git repositories (each needs its own Memory Bank)

### Automated Setup Available
The setup process now intelligently uses local copies:

```bash
# Method 1: During initial detection
1. Choose option 3 when hierarchical structure is detected
2. If you've already set up the root, it will use ./setup-memory-bank.sh

# Method 2: After root setup
python memory-bank/scripts/auto-setup-hierarchy.py
# OR
bash memory-bank/scripts/setup-hierarchy.sh

# Method 3: Simple approach using local copy
./setup-memory-bank.sh  # In root after setup
cd child-project && ../setup-memory-bank.sh --single
```

The hierarchy scripts automatically prefer local copies of setup-memory-bank.sh for consistency.

### About CLAUDE.md Files
- **Root Level**: One CLAUDE.md at the workspace root is usually sufficient
- **Sub-projects**: Only need their own CLAUDE.md if:
  - Opened independently in Claude Code
  - Have different coding standards
  - Managed by different teams
- **Recommendation**: Start with one CLAUDE.md at root, add more only if needed

## Design Decisions (Implemented)

1. **Pattern Inheritance**: Child projects automatically inherit parent conventions ONLY if they don't have their own
   - Strategy: "child_first" - child patterns always take precedence
   - Conventions are inherited by default
   - Project-specific patterns override parent patterns

2. **Conflict Resolution**: Parent patterns apply only if child doesn't define them
   - Child patterns always win
   - No pattern merging - explicit override
   - Clear precedence: child > parent

3. **Ignore Support**: Yes, `memory-bank-ignore` file supported
   - Similar to .gitignore syntax
   - Excludes directories from hierarchy scanning
   - Default ignores: node_modules/, .git/, __pycache__/

4. **Scanning Depth**: Maximum 3 levels deep
   - Prevents excessive recursion
   - Covers most practical hierarchies
   - Configurable in detect-hierarchy.py

5. **Reference Type**: JSON references (not symbolic links)
   - Better cross-platform compatibility
   - Explicit path documentation
   - Easier to version control

---
*Hierarchical Project Support - Memory Bank v2.1 Design*