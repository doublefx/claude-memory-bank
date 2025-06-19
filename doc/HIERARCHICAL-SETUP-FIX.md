# Hierarchical Setup - Quick Fix Guide

## Issue
When choosing option 3 (Auto-setup in all repositories), you might see:
```
Error: setup-memory-bank.sh not found in PATH
```

## Why This Happens
The automated setup script is looking for the setup command but:
1. The command might be `claude-memory-setup` or `cmb-setup` (not `setup-memory-bank.sh`)
2. Your shell might not have refreshed the PATH yet
3. The script might be installed but not executable

## Quick Fixes

### Option 1: Complete Current Setup First
1. Choose option 1 (setup only current directory)
2. Complete the setup
3. Then run the automated setup:
```bash
# Using Python (recommended)
python memory-bank/scripts/auto-setup-hierarchy.py

# Or using bash
bash memory-bank/scripts/setup-hierarchy.sh
```

### Option 2: Refresh Your Shell
```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc

# Then try again
cmb-setup
```

### Option 3: Use Full Path
```bash
~/.claude-memory-bank/setup-memory-bank.sh
```

### Option 4: Manual Hierarchical Setup
If automated setup isn't working, you can still set up each repository:

1. List all repositories:
```bash
find . -name ".git" -type d | while read gitdir; do
    echo "$(dirname "$gitdir")"
done
```

2. For each repository:
```bash
cd path/to/repo
cmb-setup --single
```

## Best Practice
For hierarchical projects:
1. Set up the root repository first
2. Use the Python automated script after: `python memory-bank/scripts/auto-setup-hierarchy.py`
3. This ensures all scripts are available and properly configured

## Updated Process (Recommended)
```bash
# Step 1: Setup root repository
cmb-setup
# Choose: 1 (current directory only)
# Choose: 1 (single-project)

# Step 2: Run automated setup for all nested repos
python memory-bank/scripts/auto-setup-hierarchy.py
# Choose: 1 (all repositories)
```

This two-step process avoids the PATH issues and ensures everything is properly configured.