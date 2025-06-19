#!/usr/bin/env python3
"""
Detect hierarchical project structure based on .git directories
Part of Memory Bank v2.1 - Hierarchical Project Support
"""

import json
import os
from pathlib import Path
import subprocess
from typing import Dict, List, Optional

class HierarchyDetector:
    def __init__(self, root_path: str = "."):
        self.root = Path(root_path).resolve()
        self.max_depth = 3  # Maximum scanning depth
        self.ignored_patterns = self._load_ignore_patterns()
    
    def _load_ignore_patterns(self) -> List[str]:
        """Load patterns from memory-bank-ignore file"""
        patterns = []
        ignore_file = self.root / "memory-bank-ignore"
        
        if ignore_file.exists():
            with open(ignore_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#'):
                        patterns.append(line)
        
        # Always ignore these
        patterns.extend(['.git/', 'node_modules/', '__pycache__/'])
        return patterns
    
    def _is_ignored(self, path: Path) -> bool:
        """Check if path matches any ignore pattern"""
        rel_path = str(path.relative_to(self.root))
        
        for pattern in self.ignored_patterns:
            if pattern.endswith('/'):
                # Directory pattern
                if rel_path.startswith(pattern[:-1]):
                    return True
            elif '*' in pattern:
                # Simple glob pattern
                import fnmatch
                if fnmatch.fnmatch(rel_path, pattern):
                    return True
            elif pattern in rel_path:
                return True
        
        return False
        
    def find_git_repos(self) -> List[Path]:
        """Find all .git directories under root, respecting depth and ignore patterns"""
        git_dirs = []
        
        # Use find command with maxdepth
        try:
            # Calculate maxdepth for find command
            find_depth = self.max_depth * 2  # Account for directory structure
            
            result = subprocess.run(
                ["find", str(self.root), "-maxdepth", str(find_depth),
                 "-name", ".git", "-type", "d", 
                 "-not", "-path", "*/node_modules/*",
                 "-not", "-path", "*/.git/*"],
                capture_output=True, text=True
            )
            
            for line in result.stdout.strip().split('\n'):
                if line:
                    git_dir = Path(line)
                    repo_path = git_dir.parent
                    
                    # Check depth from root
                    depth = len(repo_path.relative_to(self.root).parts)
                    if depth > self.max_depth:
                        continue
                    
                    # Check ignore patterns
                    if not self._is_ignored(repo_path):
                        git_dirs.append(repo_path)
                    
        except Exception as e:
            print(f"Error finding git repos: {e}")
            
        return sorted(git_dirs)
    
    def has_memory_bank(self, project_path: Path) -> bool:
        """Check if project has a memory bank"""
        return (project_path / "memory-bank").exists() or \
               (project_path / "memory-bank").exists()
    
    def get_memory_bank_type(self, project_path: Path) -> Optional[str]:
        """Determine memory bank type (single/multi/none)"""
        mb_path = None
        
        if (project_path / "memory-bank").exists():
            mb_path = project_path / "memory-bank"
        elif (project_path / "memory-bank").exists():
            mb_path = project_path / "memory-bank"
        else:
            return None
            
        # Check for shared folder to determine multi-project
        if (mb_path / "shared").exists():
            return "multi-project"
        else:
            return "single-project"
    
    def build_hierarchy(self) -> Dict:
        """Build complete hierarchy map"""
        git_repos = self.find_git_repos()
        
        hierarchy = {
            "root": str(self.root),
            "repos": []
        }
        
        for repo in git_repos:
            repo_info = {
                "path": str(repo.relative_to(self.root)),
                "absolute_path": str(repo),
                "has_memory_bank": self.has_memory_bank(repo),
                "memory_bank_type": self.get_memory_bank_type(repo),
                "depth": len(repo.relative_to(self.root).parts),
                "children": []
            }
            
            # Find children
            for other_repo in git_repos:
                if other_repo != repo and other_repo.is_relative_to(repo):
                    # Check if it's a direct child (no intermediate git repos)
                    is_direct_child = True
                    for part in other_repo.relative_to(repo).parts[:-1]:
                        intermediate = repo / part
                        if intermediate in git_repos:
                            is_direct_child = False
                            break
                    
                    if is_direct_child:
                        repo_info["children"].append(str(other_repo.relative_to(self.root)))
            
            hierarchy["repos"].append(repo_info)
        
        return hierarchy
    
    def suggest_setup(self, hierarchy: Dict) -> Dict:
        """Suggest Memory Bank setup based on hierarchy"""
        suggestions = {
            "approach": None,
            "actions": []
        }
        
        # Count repos with and without memory banks
        total_repos = len(hierarchy["repos"])
        with_mb = sum(1 for r in hierarchy["repos"] if r["has_memory_bank"])
        
        if total_repos == 1:
            # Single repository
            suggestions["approach"] = "single-repo"
            if with_mb == 0:
                suggestions["actions"].append("Run setup-memory-bank.sh in the repository")
        elif total_repos > 1 and hierarchy["repos"][0]["depth"] == 0:
            # Multiple repos, root is one of them
            suggestions["approach"] = "distributed-hierarchical"
            
            # Check which repos need memory banks
            for repo in hierarchy["repos"]:
                if not repo["has_memory_bank"]:
                    suggestions["actions"].append(
                        f"Setup memory-bank in {repo['path'] or 'root'}"
                    )
            
            # Suggest linking
            if with_mb > 1:
                suggestions["actions"].append(
                    "Consider adding hierarchy links between memory banks"
                )
        
        return suggestions
    
    def save_hierarchy_map(self, hierarchy: Dict, output_path: Optional[Path] = None):
        """Save hierarchy map to JSON file"""
        if output_path is None:
            # Find root memory bank
            for repo in hierarchy["repos"]:
                if repo["has_memory_bank"] and repo["depth"] == 0:
                    output_path = Path(repo["absolute_path"]) / "memory-bank" / "hierarchy.json"
                    break
            else:
                output_path = Path("hierarchy.json")
        
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_path, 'w') as f:
            json.dump(hierarchy, f, indent=2)
        
        print(f"Hierarchy map saved to: {output_path}")

def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Detect hierarchical project structure for Memory Bank"
    )
    parser.add_argument(
        "--root", default=".",
        help="Root directory to scan (default: current directory)"
    )
    parser.add_argument(
        "--save", action="store_true",
        help="Save hierarchy map to memory-bank/hierarchy.json"
    )
    parser.add_argument(
        "--json", action="store_true",
        help="Output raw JSON"
    )
    
    args = parser.parse_args()
    
    detector = HierarchyDetector(args.root)
    hierarchy = detector.build_hierarchy()
    
    if args.json:
        print(json.dumps(hierarchy, indent=2))
    else:
        # Pretty print hierarchy
        print(f"\n🔍 Project Hierarchy Analysis")
        print(f"{'=' * 50}")
        print(f"Root: {hierarchy['root']}")
        print(f"Git repositories found: {len(hierarchy['repos'])}")
        print()
        
        # Display tree structure
        for repo in sorted(hierarchy['repos'], key=lambda r: r['depth']):
            indent = "  " * repo['depth']
            name = repo['path'] or "[root]"
            mb_status = "✓" if repo['has_memory_bank'] else "✗"
            mb_type = f" ({repo['memory_bank_type']})" if repo['memory_bank_type'] else ""
            
            print(f"{indent}{name}")
            print(f"{indent}  └─ Memory Bank: {mb_status}{mb_type}")
            
            if repo['children']:
                print(f"{indent}  └─ Children: {', '.join(repo['children'])}")
        
        # Show suggestions
        print(f"\n💡 Setup Suggestions")
        print(f"{'=' * 50}")
        suggestions = detector.suggest_setup(hierarchy)
        print(f"Recommended approach: {suggestions['approach']}")
        
        if suggestions['actions']:
            print("\nRecommended actions:")
            for i, action in enumerate(suggestions['actions'], 1):
                print(f"{i}. {action}")
    
    if args.save:
        detector.save_hierarchy_map(hierarchy)

if __name__ == "__main__":
    main()