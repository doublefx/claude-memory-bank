#!/usr/bin/env python3
"""
Claude Memory Bank Auto-Update Script
Automation enhancements for the Memory Bank system

Features:
- Auto-pattern detection from codebase scanning
- Auto-decision extraction from git commit messages
- Mode-aware maintenance and updates
- Cross-project pattern sharing

Original methodology by @vanzan01, adapted for Claude Code
"""

import os
import json
import re
import subprocess
import argparse
from datetime import datetime
from pathlib import Path
import ast

class MemoryBankAutomation:
    def __init__(self, project_root="."):
        self.project_root = Path(project_root)
        self.memory_bank = self.project_root / "memory-bank"
        self.ensure_memory_bank_exists()
    
    def ensure_memory_bank_exists(self):
        """Ensure memory bank directory structure exists"""
        if not self.memory_bank.exists():
            raise FileNotFoundError("Memory bank not found. Run claude-memory-setup first.")
    
    def scan_code_patterns(self):
        """Scan codebase for reusable patterns and functions"""
        patterns = {
            "functions": [],
            "classes": [],
            "patterns": [],
            "utilities": []
        }
        
        # Common file extensions to scan
        extensions = ['.py', '.js', '.ts', '.jsx', '.tsx', '.java', '.cpp', '.c', '.cs']
        
        for ext in extensions:
            for file_path in self.project_root.rglob(f"*{ext}"):
                if "memory-bank" in str(file_path) or "node_modules" in str(file_path):
                    continue
                
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Extract patterns based on file type
                    if ext == '.py':
                        patterns.update(self._extract_python_patterns(content, file_path))
                    elif ext in ['.js', '.ts', '.jsx', '.tsx']:
                        patterns.update(self._extract_javascript_patterns(content, file_path))
                    
                except (UnicodeDecodeError, PermissionError):
                    continue
        
        # Save patterns to memory bank
        self._save_patterns(patterns)
        return patterns
    
    def _extract_python_patterns(self, content, file_path):
        """Extract reusable patterns from Python code"""
        patterns = {"functions": [], "classes": [], "patterns": [], "utilities": []}
        
        try:
            tree = ast.parse(content)
            
            for node in ast.walk(tree):
                if isinstance(node, ast.FunctionDef):
                    # Look for utility functions
                    if self._is_utility_function(node):
                        patterns["utilities"].append({
                            "name": node.name,
                            "file": str(file_path),
                            "line": node.lineno,
                            "docstring": ast.get_docstring(node),
                            "args": [arg.arg for arg in node.args.args]
                        })
                
                elif isinstance(node, ast.ClassDef):
                    # Look for reusable classes
                    if self._is_reusable_class(node):
                        patterns["classes"].append({
                            "name": node.name,
                            "file": str(file_path),
                            "line": node.lineno,
                            "docstring": ast.get_docstring(node),
                            "methods": [n.name for n in node.body if isinstance(n, ast.FunctionDef)]
                        })
        
        except SyntaxError:
            pass
        
        return patterns
    
    def _extract_javascript_patterns(self, content, file_path):
        """Extract reusable patterns from JavaScript/TypeScript code"""
        patterns = {"functions": [], "classes": [], "patterns": [], "utilities": []}
        
        # Simple regex patterns for common JS structures
        function_pattern = r'(?:function\s+(\w+)|const\s+(\w+)\s*=\s*(?:async\s+)?\()'
        class_pattern = r'class\s+(\w+)'
        
        # Find functions
        for match in re.finditer(function_pattern, content):
            func_name = match.group(1) or match.group(2)
            if func_name and self._is_utility_name(func_name):
                patterns["utilities"].append({
                    "name": func_name,
                    "file": str(file_path),
                    "line": content[:match.start()].count('\n') + 1,
                    "type": "function"
                })
        
        # Find classes
        for match in re.finditer(class_pattern, content):
            class_name = match.group(1)
            patterns["classes"].append({
                "name": class_name,
                "file": str(file_path),
                "line": content[:match.start()].count('\n') + 1,
                "type": "class"
            })
        
        return patterns
    
    def _is_utility_function(self, node):
        """Check if a function is likely a utility function"""
        name = node.name.lower()
        utility_keywords = ['util', 'helper', 'format', 'parse', 'convert', 'validate', 'check']
        return any(keyword in name for keyword in utility_keywords)
    
    def _is_reusable_class(self, node):
        """Check if a class is likely reusable"""
        name = node.name.lower()
        reusable_keywords = ['base', 'abstract', 'util', 'helper', 'manager', 'service']
        return any(keyword in name for keyword in reusable_keywords)
    
    def _is_utility_name(self, name):
        """Check if a name suggests a utility function"""
        name = name.lower()
        utility_keywords = ['util', 'helper', 'format', 'parse', 'convert', 'validate', 'check']
        return any(keyword in name for keyword in utility_keywords)
    
    def _save_patterns(self, patterns):
        """Save patterns to memory bank"""
        patterns_dir = self.memory_bank / "project-specific" / "patterns"
        patterns_dir.mkdir(parents=True, exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        patterns_file = patterns_dir / f"auto-detected-patterns-{timestamp}.json"
        
        with open(patterns_file, 'w') as f:
            json.dump(patterns, f, indent=2)
        
        # Update patterns summary
        self._update_patterns_summary(patterns)
    
    def _update_patterns_summary(self, patterns):
        """Update the patterns summary markdown file"""
        patterns_dir = self.memory_bank / "project-specific" / "patterns"
        summary_file = patterns_dir / "auto-detected-summary.md"
        
        with open(summary_file, 'w') as f:
            f.write("# Auto-Detected Code Patterns\n\n")
            f.write(f"**Last Updated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("## Utility Functions\n")
            for func in patterns.get("utilities", []):
                f.write(f"- **{func['name']}** in `{func['file']}` (line {func['line']})\n")
            
            f.write("\n## Reusable Classes\n")
            for cls in patterns.get("classes", []):
                f.write(f"- **{cls['name']}** in `{cls['file']}` (line {cls['line']})\n")
                if 'methods' in cls:
                    f.write(f"  - Methods: {', '.join(cls['methods'])}\n")
            
            f.write("\n---\n*Auto-generated by Memory Bank automation*\n")
    
    def extract_git_decisions(self):
        """Extract architectural decisions from git commit messages"""
        try:
            # Get git log with commit messages
            result = subprocess.run(
                ['git', 'log', '--oneline', '--since="30 days ago"'],
                capture_output=True, text=True, cwd=self.project_root
            )
            
            if result.returncode != 0:
                return []
            
            commits = result.stdout.strip().split('\n')
            decisions = []
            
            # Keywords that indicate architectural decisions
            decision_keywords = [
                'refactor', 'restructure', 'redesign', 'architecture',
                'pattern', 'design', 'implement', 'add', 'remove',
                'upgrade', 'migrate', 'optimize'
            ]
            
            for commit in commits:
                if not commit.strip():
                    continue
                
                hash_msg = commit.split(' ', 1)
                if len(hash_msg) < 2:
                    continue
                
                commit_hash, message = hash_msg
                message_lower = message.lower()
                
                # Check if commit message indicates a decision
                if any(keyword in message_lower for keyword in decision_keywords):
                    decisions.append({
                        "hash": commit_hash,
                        "message": message,
                        "date": self._get_commit_date(commit_hash),
                        "type": self._classify_decision(message_lower)
                    })
            
            # Save decisions to memory bank
            self._save_decisions(decisions)
            return decisions
        
        except FileNotFoundError:
            return []  # Git not available
    
    def _get_commit_date(self, commit_hash):
        """Get the date of a commit"""
        try:
            result = subprocess.run(
                ['git', 'show', '-s', '--format=%ci', commit_hash],
                capture_output=True, text=True, cwd=self.project_root
            )
            return result.stdout.strip() if result.returncode == 0 else ""
        except:
            return ""
    
    def _classify_decision(self, message):
        """Classify the type of decision based on commit message"""
        if any(word in message for word in ['refactor', 'restructure', 'redesign']):
            return "refactoring"
        elif any(word in message for word in ['add', 'implement', 'create']):
            return "feature"
        elif any(word in message for word in ['remove', 'delete', 'cleanup']):
            return "cleanup"
        elif any(word in message for word in ['upgrade', 'migrate', 'update']):
            return "upgrade"
        elif any(word in message for word in ['optimize', 'improve', 'performance']):
            return "optimization"
        else:
            return "other"
    
    def _save_decisions(self, decisions):
        """Save extracted decisions to memory bank"""
        decisions_dir = self.memory_bank / "decisions"
        decisions_file = decisions_dir / "auto-extracted-decisions.md"
        
        with open(decisions_file, 'w') as f:
            f.write("# Auto-Extracted Decisions from Git History\n\n")
            f.write(f"**Extracted**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            # Group decisions by type
            by_type = {}
            for decision in decisions:
                decision_type = decision['type']
                if decision_type not in by_type:
                    by_type[decision_type] = []
                by_type[decision_type].append(decision)
            
            for decision_type, type_decisions in by_type.items():
                f.write(f"## {decision_type.capitalize()} Decisions\n\n")
                for decision in type_decisions:
                    f.write(f"- **{decision['message']}** ({decision['hash']})\n")
                    if decision['date']:
                        f.write(f"  - Date: {decision['date']}\n")
                f.write("\n")
            
            f.write("---\n*Auto-extracted by Memory Bank automation*\n")
    
    def update_memory_bank_status(self):
        """Update memory bank status and maintenance"""
        status = {
            "last_updated": datetime.now().isoformat(),
            "patterns_detected": len(self._load_patterns()),
            "decisions_extracted": len(self._load_decisions()),
            "active_mode": self._get_active_mode(),
            "project_health": self._assess_project_health()
        }
        
        # Save status
        status_file = self.memory_bank / "status.json"
        with open(status_file, 'w') as f:
            json.dump(status, f, indent=2)
        
        return status
    
    def _load_patterns(self):
        """Load existing patterns"""
        patterns_dir = self.memory_bank / "project-specific" / "patterns"
        if not patterns_dir.exists():
            return []
        
        patterns = []
        for pattern_file in patterns_dir.glob("auto-detected-patterns-*.json"):
            try:
                with open(pattern_file, 'r') as f:
                    data = json.load(f)
                    patterns.extend(data.get("utilities", []))
                    patterns.extend(data.get("classes", []))
            except:
                continue
        
        return patterns
    
    def _load_decisions(self):
        """Load existing decisions"""
        decisions_file = self.memory_bank / "decisions" / "auto-extracted-decisions.md"
        if not decisions_file.exists():
            return []
        
        # Simple count of decision lines
        try:
            with open(decisions_file, 'r') as f:
                content = f.read()
                return len([line for line in content.split('\n') if line.strip().startswith('- **')])
        except:
            return 0
    
    def _get_active_mode(self):
        """Get current active mode from activeContext.md"""
        active_context_file = self.memory_bank / "activeContext.md"
        if not active_context_file.exists():
            return "unknown"
        
        try:
            with open(active_context_file, 'r') as f:
                content = f.read()
                # Look for mode indicators
                if "VAN" in content:
                    return "VAN"
                elif "PLAN" in content:
                    return "PLAN"
                elif "CREATIVE" in content:
                    return "CREATIVE"
                elif "IMPLEMENT" in content:
                    return "IMPLEMENT"
                elif "REFLECT" in content:
                    return "REFLECT"
                elif "ARCHIVE" in content:
                    return "ARCHIVE"
                else:
                    return "unknown"
        except:
            return "unknown"
    
    def _assess_project_health(self):
        """Assess overall project health"""
        health_score = 100
        issues = []
        
        # Check if tasks.md exists
        if not (self.memory_bank / "tasks.md").exists():
            health_score -= 30
            issues.append("tasks.md missing")
        
        # Check if progress.md exists
        if not (self.memory_bank / "progress.md").exists():
            health_score -= 20
            issues.append("progress.md missing")
        
        # Check for recent activity
        active_context_file = self.memory_bank / "activeContext.md"
        if active_context_file.exists():
            mod_time = active_context_file.stat().st_mtime
            age_hours = (datetime.now().timestamp() - mod_time) / 3600
            if age_hours > 24:
                health_score -= 10
                issues.append("no recent activity")
        
        return {
            "score": max(0, health_score),
            "issues": issues,
            "status": "healthy" if health_score > 80 else "needs_attention" if health_score > 50 else "critical"
        }

def main():
    parser = argparse.ArgumentParser(description="Claude Memory Bank Automation")
    parser.add_argument("--scan-patterns", action="store_true", help="Scan for code patterns")
    parser.add_argument("--extract-decisions", action="store_true", help="Extract decisions from git")
    parser.add_argument("--update-status", action="store_true", help="Update memory bank status")
    parser.add_argument("--all", action="store_true", help="Run all automation tasks")
    parser.add_argument("--project-root", default=".", help="Project root directory")
    
    args = parser.parse_args()
    
    automation = MemoryBankAutomation(args.project_root)
    
    if args.all or args.scan_patterns:
        print("Scanning for code patterns...")
        patterns = automation.scan_code_patterns()
        print(f"Found {len(patterns.get('utilities', []))} utility functions and {len(patterns.get('classes', []))} classes")
    
    if args.all or args.extract_decisions:
        print("Extracting decisions from git history...")
        decisions = automation.extract_git_decisions()
        print(f"Extracted {len(decisions)} decisions from recent commits")
    
    if args.all or args.update_status:
        print("Updating memory bank status...")
        status = automation.update_memory_bank_status()
        print(f"Status: {status['project_health']['status']} (score: {status['project_health']['score']})")
    
    if not any([args.scan_patterns, args.extract_decisions, args.update_status, args.all]):
        parser.print_help()

if __name__ == "__main__":
    main()