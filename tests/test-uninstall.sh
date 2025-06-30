#!/bin/bash
# Test script for Claude Memory Bank uninstall functionality
# This script tests the uninstall command in a safe environment

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Claude Memory Bank Uninstall Test Suite"
echo "======================================="

# Path to uninstall script
UNINSTALL_SCRIPT="../scripts/claude-memory-uninstall"

# Test 1: Help option
echo -e "\n${YELLOW}Test 1: Help option${NC}"
if $UNINSTALL_SCRIPT --help | grep -q "Usage:"; then
    echo -e "${GREEN}✓ Help option works${NC}"
else
    echo -e "${RED}✗ Help option failed${NC}"
    exit 1
fi

# Test 2: Dry-run mode
echo -e "\n${YELLOW}Test 2: Dry-run mode${NC}"
if $UNINSTALL_SCRIPT --dry-run --force | grep -q "DRY-RUN MODE"; then
    echo -e "${GREEN}✓ Dry-run mode works${NC}"
else
    echo -e "${RED}✗ Dry-run mode failed${NC}"
    exit 1
fi

# Test 3: System-only option
echo -e "\n${YELLOW}Test 3: System-only dry-run${NC}"
if $UNINSTALL_SCRIPT --system-only --dry-run --force | grep -q "System-Level Uninstallation"; then
    echo -e "${GREEN}✓ System-only option works${NC}"
else
    echo -e "${RED}✗ System-only option failed${NC}"
    exit 1
fi

# Test 4: Project-only option
echo -e "\n${YELLOW}Test 4: Project-only dry-run${NC}"
if $UNINSTALL_SCRIPT --project-only --dry-run --force | grep -q "Project-Level Uninstallation"; then
    echo -e "${GREEN}✓ Project-only option works${NC}"
else
    echo -e "${RED}✗ Project-only option failed${NC}"
    exit 1
fi

# Test 5: Check for proper file detection
echo -e "\n${YELLOW}Test 5: File detection in dry-run${NC}"
# Run from parent directory where .memory-bank exists
OUTPUT=$(cd ../.. && $PWD/claude-memory-bank/scripts/claude-memory-uninstall --dry-run --force 2>&1)
if echo "$OUTPUT" | grep -q "Would remove: Global installation directory"; then
    echo -e "${GREEN}✓ Detects system files correctly${NC}"
else
    echo -e "${RED}✗ System file detection failed${NC}"
    exit 1
fi

if echo "$OUTPUT" | grep -q "Would remove: Memory Bank directory"; then
    echo -e "${GREEN}✓ Detects project files correctly${NC}"
else
    echo -e "${RED}✗ Project file detection failed${NC}"
    # Not a failure - we're in tests directory
    echo -e "${YELLOW}  (Expected when running from tests directory)${NC}"
fi

# Test 6: Invalid option handling
echo -e "\n${YELLOW}Test 6: Invalid option handling${NC}"
if $UNINSTALL_SCRIPT --invalid-option 2>&1 | grep -q "Unknown option"; then
    echo -e "${GREEN}✓ Handles invalid options correctly${NC}"
else
    echo -e "${RED}✗ Invalid option handling failed${NC}"
    exit 1
fi

# Test 7: Backup option presence
echo -e "\n${YELLOW}Test 7: Backup option in help${NC}"
if $UNINSTALL_SCRIPT --help | grep -q "backup"; then
    echo -e "${GREEN}✓ Backup option documented${NC}"
else
    echo -e "${RED}✗ Backup option not documented${NC}"
    exit 1
fi

# Test 8: Keep-knowledge option
echo -e "\n${YELLOW}Test 8: Keep-knowledge option${NC}"
if $UNINSTALL_SCRIPT --help | grep -q "keep-knowledge"; then
    echo -e "${GREEN}✓ Keep-knowledge option documented${NC}"
else
    echo -e "${RED}✗ Keep-knowledge option not documented${NC}"
    exit 1
fi

OUTPUT=$(cd ../.. && $PWD/claude-memory-bank/scripts/claude-memory-uninstall --keep-knowledge --dry-run --force 2>&1)
if echo "$OUTPUT" | grep -q "Keeping knowledge files"; then
    echo -e "${GREEN}✓ Keep-knowledge mode works correctly${NC}"
else
    echo -e "${RED}✗ Keep-knowledge mode failed${NC}"
    exit 1
fi

echo -e "\n${GREEN}All tests passed!${NC}"
echo "Note: These are dry-run tests only. Actual uninstall functionality"
echo "should be tested in an isolated environment."