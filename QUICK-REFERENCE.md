# Claude Memory Bank v2.0 - Quick Reference

## 🚀 Quick Commands

### Setup
```bash
# Single-project (interactive)
setup-memory-bank.sh

# Force single-project
setup-memory-bank.sh --single

# Multi-project setup
setup-memory-bank.sh --multi

# Add project to multi-repo
setup-memory-bank.sh --add-project
```

### Workflow Modes
```
@VAN      # Initialize & assess (ALWAYS FIRST)
@PLAN     # Strategy & design (Level 2-3)
@IMPLEMENT # Build & test
@REFLECT   # Validate & learn
```

### Automation
```bash
# Single-project
python .memory-bank/scripts/auto-update.py --all
python .memory-bank/scripts/auto-update.py --health-check
python .memory-bank/scripts/auto-update.py --validate-structure

# Multi-project
python .memory-bank/scripts/auto-update.py --list-projects
python .memory-bank/scripts/auto-update.py --all --project-name api-service
```

## 📋 Complexity Levels

| Level | Duration | Workflow | Description |
|-------|----------|----------|-------------|
| **1** | < 1 hour | VAN → IMPLEMENT → REFLECT | Quick fixes, single file |
| **2** | 1hr-1day | VAN → PLAN → IMPLEMENT → REFLECT | Features, multiple files |
| **3** | 1+ days | VAN → PLAN (design) → IMPLEMENT → REFLECT | Complex, architectural |

## 📁 Directory Structure

### Single-Project
```
.memory-bank/
├── context/          # Foundation files
├── active/           # Current work
├── technical/        # Deep docs
├── decisions/        # Design log
├── qa/              # Validation
├── custom_modes/    # Instructions
└── scripts/         # Automation
```

### Multi-Project
```
.memory-bank/
├── shared/          # Cross-project
├── project-a/       # Full structure
├── project-b/       # Full structure
├── custom_modes/    # Instructions
└── scripts/         # Automation
```

## 🔑 Key Files

### Context Foundation (Created by VAN)
- `projectBrief.md` - Overview & goals
- `productContext.md` - User needs
- `systemPatterns.md` - Architecture
- `techContext.md` - Technical details

### Active Work
- `activeContext.md` - Current synthesis
- `tasks.md` - Task breakdown
- `progress.md` - Progress tracking

## 💡 Best Practices

1. **Always start with @VAN** - Creates/updates context
2. **Skip modes when obvious** - Level 1 can skip PLAN
3. **Update context continuously** - Living documentation
4. **Use project-name in multi-repo** - Specify target project
5. **Run --health-check weekly** - Monitor context freshness

## 🎯 Common Workflows

### New Feature (Level 2)
```
1. @VAN                    # Assess & update context
2. @PLAN                   # Create strategy
3. @IMPLEMENT              # Build with tests
4. @REFLECT                # Validate & update patterns
```

### Bug Fix (Level 1)
```
1. @VAN                    # Quick assessment
2. @IMPLEMENT              # Direct to fix
3. @REFLECT (optional)     # If patterns found
```

### Multi-Project Task
```
1. @VAN                    # Scans all projects
2. Choose project/task     # From presented options
3. Continue workflow       # Based on complexity
```

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| "tasks.md not found" | Run @VAN first |
| "project not found" | Use --project-name |
| "structure invalid" | Run --validate-structure |
| "context stale" | Run --health-check |

## 📊 Status Checks

```bash
# Global status
claude-memory-status

# Project health
python .memory-bank/scripts/auto-update.py --health-check

# Structure validation
python .memory-bank/scripts/auto-update.py --validate-structure

# List all tasks
python .memory-bank/scripts/auto-update.py --list-tasks
```

---
*Memory Bank v2.0 - Generic Context-Driven Workflow*  
*Original methodology by @vanzan01*