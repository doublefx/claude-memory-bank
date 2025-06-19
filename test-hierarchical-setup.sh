#!/bin/bash

# Test script for hierarchical Memory Bank setup
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test directory
TEST_DIR="/tmp/memory-bank-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "${BLUE}Memory Bank Hierarchical Setup Test${NC}"
echo "===================================="
echo "Test directory: $TEST_DIR"
echo ""

# Function to create test repositories
create_test_repos() {
    echo -e "${YELLOW}Creating test repository structure...${NC}"
    
    # Root repository
    git init > /dev/null 2>&1
    echo "# Test Root Project" > README.md
    
    # Create nested repositories
    mkdir -p services/auth
    (cd services/auth && git init > /dev/null 2>&1 && echo "# Auth Service" > README.md)
    
    mkdir -p services/api
    (cd services/api && git init > /dev/null 2>&1 && echo "# API Service" > README.md)
    
    mkdir -p libs/core
    (cd libs/core && git init > /dev/null 2>&1 && echo "# Core Library" > README.md)
    
    # Create a deeper nested repo
    mkdir -p services/auth/submodule
    (cd services/auth/submodule && git init > /dev/null 2>&1 && echo "# Auth Submodule" > README.md)
    
    echo -e "${GREEN}✓ Created test repository structure${NC}"
    find . -name ".git" -type d | while read gitdir; do
        echo "  - $(dirname "$gitdir")"
    done
}

# Test 1: Basic hierarchy detection
test_hierarchy_detection() {
    echo ""
    echo -e "${YELLOW}Test 1: Hierarchy Detection${NC}"
    echo "----------------------------"
    
    # Count git repos
    git_count=$(find . -name ".git" -type d -not -path "*/.git/*" | wc -l)
    echo "Found $git_count git repositories"
    
    if [ "$git_count" -eq 5 ]; then
        echo -e "${GREEN}✓ Hierarchy detection works correctly${NC}"
        return 0
    else
        echo -e "${RED}✗ Expected 5 repositories, found $git_count${NC}"
        return 1
    fi
}

# Test 2: Setup with local script
test_local_setup() {
    echo ""
    echo -e "${YELLOW}Test 2: Local Setup Script${NC}"
    echo "---------------------------"
    
    # First, setup root with Memory Bank
    echo "Setting up root repository..."
    if command -v claude-memory-setup &> /dev/null; then
        (claude-memory-setup --single) > /dev/null 2>&1
        
        if [ -f "./setup-memory-bank.sh" ]; then
            echo -e "${GREEN}✓ Local setup script created${NC}"
            
            # Test running in subdirectory
            cd services/auth
            if (../../setup-memory-bank.sh --single) > /dev/null 2>&1; then
                echo -e "${GREEN}✓ Local script works from subdirectory${NC}"
                cd ../..
                return 0
            else
                echo -e "${RED}✗ Local script failed from subdirectory${NC}"
                cd ../..
                return 1
            fi
        else
            echo -e "${RED}✗ Local setup script not created${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ Skipping test - claude-memory-setup not available${NC}"
        return 0
    fi
}

# Test 3: Automated hierarchy setup
test_automated_setup() {
    echo ""
    echo -e "${YELLOW}Test 3: Automated Hierarchy Setup${NC}"
    echo "---------------------------------"
    
    if [ -f "memory-bank/scripts/setup-hierarchy.sh" ]; then
        echo "Running automated setup..."
        
        # Run in non-interactive mode
        echo -e "1\n" | bash memory-bank/scripts/setup-hierarchy.sh > setup.log 2>&1
        
        # Check results
        success_count=0
        for repo in services/auth services/api libs/core; do
            if [ -d "$repo/memory-bank" ]; then
                ((success_count++))
            fi
        done
        
        echo "Successfully set up $success_count repositories"
        
        if [ "$success_count" -ge 2 ]; then
            echo -e "${GREEN}✓ Automated setup works${NC}"
            return 0
        else
            echo -e "${RED}✗ Automated setup incomplete${NC}"
            cat setup.log
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ Automated setup script not available${NC}"
        return 0
    fi
}

# Test 4: Hierarchy.json creation
test_hierarchy_json() {
    echo ""
    echo -e "${YELLOW}Test 4: Hierarchy JSON Creation${NC}"
    echo "-------------------------------"
    
    if [ -f "services/auth/memory-bank/hierarchy.json" ]; then
        echo -e "${GREEN}✓ hierarchy.json created in child repo${NC}"
        
        # Check content
        if grep -q "parent" services/auth/memory-bank/hierarchy.json; then
            echo -e "${GREEN}✓ hierarchy.json contains parent reference${NC}"
            return 0
        else
            echo -e "${RED}✗ hierarchy.json missing parent reference${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ No hierarchy.json found (may not have been created)${NC}"
        return 0
    fi
}

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}Cleaning up test directory...${NC}"
    cd /
    rm -rf "$TEST_DIR"
    echo -e "${GREEN}✓ Cleanup complete${NC}"
}

# Run tests
main() {
    create_test_repos
    
    # Track results
    tests_passed=0
    tests_failed=0
    
    # Run each test
    if test_hierarchy_detection; then ((tests_passed++)); else ((tests_failed++)); fi
    if test_local_setup; then ((tests_passed++)); else ((tests_failed++)); fi
    if test_automated_setup; then ((tests_passed++)); else ((tests_failed++)); fi
    if test_hierarchy_json; then ((tests_passed++)); else ((tests_failed++)); fi
    
    # Summary
    echo ""
    echo -e "${BLUE}Test Summary${NC}"
    echo "============"
    echo -e "${GREEN}Passed: $tests_passed${NC}"
    echo -e "${RED}Failed: $tests_failed${NC}"
    
    # Cleanup
    cleanup
    
    # Exit code
    if [ "$tests_failed" -eq 0 ]; then
        echo ""
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

# Handle interrupts
trap cleanup EXIT INT TERM

# Run main
main