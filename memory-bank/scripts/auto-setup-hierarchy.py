#!/usr/bin/env python3
"""
Automated hierarchical Memory Bank setup
Sets up Memory Bank in all detected git repositories
"""

import os
import subprocess
import sys
from pathlib import Path
from typing import List, Tuple

class HierarchicalSetup:
    def __init__(self, root_path: str = "."):
        self.root = Path(root_path).resolve()
        self.setup_script = self._find_setup_script()
        self.repos = []
        
    def _find_setup_script(self) -> Path:
        """Find the setup-memory-bank.sh script"""
        # Check common locations
        locations = [
            Path.home() / ".claude-memory-bank" / "setup-memory-bank.sh",
            Path("/usr/local/bin/setup-memory-bank.sh"),
            Path.home() / ".local/bin/claude-memory-setup",
        ]
        
        for loc in locations:
            if loc.exists():
                return loc
                
        # Check various command names in PATH
        commands = ["claude-memory-setup", "cmb-setup", "setup-memory-bank.sh"]
        for cmd in commands:
            try:
                result = subprocess.run(["which", cmd], 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    return Path(result.stdout.strip())
            except:
                pass
                
        # Try to find it relative to this script
        script_dir = Path(__file__).parent.parent.parent
        setup_script = script_dir / "setup-memory-bank.sh"
        if setup_script.exists():
            return setup_script
            
        return None
        
    def find_git_repos(self) -> List[Path]:
        """Find all git repositories"""
        repos = []
        
        try:
            result = subprocess.run(
                ["find", str(self.root), "-maxdepth", "6",
                 "-name", ".git", "-type", "d",
                 "-not", "-path", "*/node_modules/*",
                 "-not", "-path", "*/.git/*"],
                capture_output=True, text=True
            )
            
            for line in result.stdout.strip().split('\n'):
                if line:
                    git_dir = Path(line)
                    repos.append(git_dir.parent)
                    
        except Exception as e:
            print(f"Error finding git repos: {e}")
            
        return sorted(repos)
        
    def check_existing_setup(self, repo: Path) -> bool:
        """Check if Memory Bank already exists"""
        return (repo / "memory-bank").exists() or (repo / "memory-bank").exists()
        
    def create_hierarchy_json(self, repo: Path, parent: Path):
        """Create hierarchy.json linking to parent"""
        # Calculate relative path to parent
        try:
            rel_path = os.path.relpath(parent, repo)
        except:
            rel_path = "../.."
            
        hierarchy = {
            "version": "2.1",
            "current_project": {
                "path": ".",
                "name": repo.name,
                "type": "single-project"
            },
            "parent": {
                "path": rel_path,
                "memory_bank_path": f"{rel_path}/memory-bank",
                "relationship": "subdirectory",
                "inherit_conventions": True,
                "inherit_patterns": "if_not_exists"
            },
            "pattern_resolution": {
                "strategy": "child_first",
                "inherit_from_parent": ["conventions", "shared_patterns"],
                "override_in_child": ["project_patterns", "technical_patterns"]
            },
            "references": {
                "parent_patterns": f"{rel_path}/memory-bank/shared/patterns.md",
                "parent_conventions": f"{rel_path}/memory-bank/shared/conventions.md"
            }
        }
        
        import json
        hierarchy_path = repo / "memory-bank" / "hierarchy.json"
        with open(hierarchy_path, 'w') as f:
            json.dump(hierarchy, f, indent=2)
            
    def setup_repo(self, repo: Path) -> bool:
        """Setup Memory Bank in a repository"""
        print(f"\n{'='*60}")
        print(f"Setting up: {repo}")
        print('='*60)
        
        # Check if already exists
        if self.check_existing_setup(repo):
            print(f"✓ Memory Bank already exists, skipping...")
            return True
            
        # Save current directory
        cwd = os.getcwd()
        
        try:
            # Change to repo directory
            os.chdir(repo)
            
            # Run setup script
            if self.setup_script:
                result = subprocess.run([str(self.setup_script), "--single"])
                success = result.returncode == 0
            else:
                # Manual setup if script not found
                print("Setting up manually...")
                subprocess.run(["mkdir", "-p", "memory-bank/context"])
                subprocess.run(["mkdir", "-p", "memory-bank/active"])
                subprocess.run(["mkdir", "-p", "memory-bank/technical"])
                subprocess.run(["mkdir", "-p", "memory-bank/decisions"])
                subprocess.run(["mkdir", "-p", "memory-bank/qa"])
                subprocess.run(["mkdir", "-p", "memory-bank/custom_modes"])
                subprocess.run(["mkdir", "-p", "memory-bank/scripts"])
                success = True
                
            if success and repo != self.root:
                # Create hierarchy.json for non-root repos
                self.create_hierarchy_json(repo, self.root)
                print("✓ Created hierarchy.json")
                
            return success
            
        except Exception as e:
            print(f"✗ Error: {e}")
            return False
        finally:
            os.chdir(cwd)
            
    def run(self):
        """Run the hierarchical setup"""
        print("Memory Bank Hierarchical Setup")
        print("==============================\n")
        
        # Find repos
        print("Detecting git repositories...")
        self.repos = self.find_git_repos()
        
        if not self.repos:
            print("No git repositories found!")
            return
            
        print(f"Found {len(self.repos)} repositories:")
        for repo in self.repos:
            rel_path = repo.relative_to(self.root) if repo != self.root else "."
            print(f"  - {rel_path}")
            
        # Ask for confirmation
        print("\nSetup Options:")
        print("1) Setup Memory Bank in ALL repositories automatically")
        print("2) Setup only in root repository")
        print("3) Cancel")
        
        choice = input("Choose an option [1]: ").strip() or "1"
        
        if choice == "2":
            self.setup_repo(self.root)
            return
        elif choice == "3":
            print("Setup cancelled.")
            return
            
        # Setup all repos
        success_count = 0
        failed_repos = []
        
        for repo in self.repos:
            if self.setup_repo(repo):
                success_count += 1
            else:
                failed_repos.append(repo)
                
        # Summary
        print(f"\n{'='*60}")
        print("Setup Summary")
        print('='*60)
        print(f"✓ Successful: {success_count} repositories")
        
        if failed_repos:
            print(f"✗ Failed: {len(failed_repos)} repositories")
            for repo in failed_repos:
                print(f"  - {repo}")
                
        print("\nHierarchical setup complete!")
        print("\nNext steps:")
        print("1. Run @VAN in any repository")
        print("2. Child projects will inherit parent patterns")
        print("3. Use detect-hierarchy.py to visualize structure")

def main():
    setup = HierarchicalSetup()
    
    if not setup.setup_script:
        print("Warning: setup-memory-bank.sh not found in PATH")
        print("Will create basic structure manually")
        
    setup.run()

if __name__ == "__main__":
    main()