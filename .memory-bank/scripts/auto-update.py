#!/usr/bin/env python3
"""
Claude Memory Bank Auto-Update Script
Automation for the context-driven workflow system

Features:
- Pattern detection and context file updates
- Pitfall → Solution extraction from progress logs
- Git decision extraction and documentation
- Context file health monitoring
- Automated pattern promotion from discoveries
- Support for both single and multi-project repositories

Memory Bank System v2.0 - Context-driven workflow
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
    def __init__(self, project_root=".", project_name=None):
        self.project_root = Path(project_root)
        self.memory_bank = self.project_root / ".memory-bank"
        self.project_name = project_name
        self.is_multi_project = False
        self.project_path = self.memory_bank
        self.shared_path = None
        self.detect_structure()
        self.ensure_memory_bank_exists()
    
    def detect_structure(self):
        """Detect if this is a single or multi-project repository"""
        if not self.memory_bank.exists():
            raise FileNotFoundError("Memory Bank not found. Run @VAN mode first to initialize.")
        
        # Check for shared folder to determine multi-project
        shared_path = self.memory_bank / "shared"
        if shared_path.exists() and shared_path.is_dir():
            self.is_multi_project = True
            self.shared_path = shared_path
            
            # If multi-project, we need a project name
            if self.project_name:
                self.project_path = self.memory_bank / self.project_name
                if not self.project_path.exists():
                    raise ValueError(f"Project '{self.project_name}' not found in multi-project repository")
            else:
                # List available projects
                projects = [d.name for d in self.memory_bank.iterdir() 
                           if d.is_dir() and d.name != "shared"]
                if projects:
                    print(f"Multi-project repository detected. Available projects: {', '.join(projects)}")
                    print("Please specify a project with --project-name")
                    raise ValueError("Project name required for multi-project repository")
    
    def ensure_memory_bank_exists(self):
        """Ensure memory bank directory structure exists"""
        # For single project, ensure basic structure
        if not self.is_multi_project:
            required_dirs = ["context", "active", "decisions", "qa", "technical"]
            for dir_name in required_dirs:
                (self.memory_bank / dir_name).mkdir(exist_ok=True)
        else:
            # For multi-project, ensure project structure
            if self.project_path != self.memory_bank:
                required_dirs = ["context", "active", "decisions", "qa", "technical"]
                for dir_name in required_dirs:
                    (self.project_path / dir_name).mkdir(exist_ok=True)
    
    def scan_and_update_patterns(self):
        """Scan codebase and update systemPatterns.md with discoveries"""
        patterns = self._scan_code_patterns()
        
        # Read existing systemPatterns.md from correct location
        patterns_file = self.project_path / "context" / "systemPatterns.md"
        if patterns_file.exists():
            with open(patterns_file, 'r') as f:
                existing_content = f.read()
        else:
            existing_content = ""
        
        # Update with new patterns
        new_patterns_section = self._format_patterns_for_context(patterns)
        
        if new_patterns_section and "## Auto-Discovered Patterns" not in existing_content:
            # Append new section
            with open(patterns_file, 'a') as f:
                f.write("\n\n## Auto-Discovered Patterns\n")
                f.write(f"*Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M')}*\n\n")
                f.write(new_patterns_section)
        
        # If multi-project and pattern seems reusable, suggest for shared
        if self.is_multi_project and self._is_pattern_reusable(patterns):
            print("💡 Some patterns might be suitable for shared/patterns.md")
        
        return patterns
    
    def _is_pattern_reusable(self, patterns):
        """Check if patterns might be reusable across projects"""
        # Simple heuristic: if we found similar patterns in multiple files
        total_patterns = sum(len(p) for p in patterns.values())
        return total_patterns > 10
    
    def extract_pitfall_solutions(self):
        """Extract pitfall → solution patterns from progress.md"""
        progress_file = self.project_path / "active" / "progress.md"
        if not progress_file.exists():
            return []
        
        with open(progress_file, 'r') as f:
            content = f.read()
        
        # Pattern to find issues and solutions
        issue_pattern = r'\*\*Issue\*\*:\s*(.+?)(?:\n\s*-\s*\*\*Context\*\*:\s*(.+?))?(?:\n\s*-\s*\*\*Solution\*\*:\s*(.+?))?(?:\n\s*-\s*\*\*Pattern\*\*:\s*(.+?))?'
        
        pitfalls = []
        for match in re.finditer(issue_pattern, content, re.MULTILINE | re.DOTALL):
            issue = match.group(1).strip() if match.group(1) else ""
            context = match.group(2).strip() if match.group(2) else ""
            solution = match.group(3).strip() if match.group(3) else ""
            pattern = match.group(4).strip() if match.group(4) else ""
            
            if issue and solution:
                pitfalls.append({
                    "issue": issue,
                    "context": context,
                    "solution": solution,
                    "pattern": pattern,
                    "timestamp": self._extract_timestamp_before(content, match.start())
                })
        
        # Update systemPatterns.md with anti-patterns
        self._update_antipatterns(pitfalls)
        
        return pitfalls
    
    def _extract_timestamp_before(self, content, position):
        """Extract the nearest timestamp before a position"""
        # Look for timestamp pattern before the position
        timestamp_pattern = r'## \[(.+?)\]'
        timestamps = list(re.finditer(timestamp_pattern, content[:position]))
        if timestamps:
            return timestamps[-1].group(1)
        return "unknown"
    
    def _update_antipatterns(self, pitfalls):
        """Update systemPatterns.md with discovered anti-patterns"""
        if not pitfalls:
            return
        
        patterns_file = self.project_path / "context" / "systemPatterns.md"
        
        # Format anti-patterns section
        antipatterns_content = "\n## Discovered Anti-patterns\n\n"
        for pitfall in pitfalls:
            antipatterns_content += f"### {pitfall['issue']}\n"
            if pitfall['context']:
                antipatterns_content += f"**Context**: {pitfall['context']}\n\n"
            antipatterns_content += f"**Problem**: {pitfall['issue']}\n\n"
            antipatterns_content += f"**Solution**: {pitfall['solution']}\n\n"
            if pitfall['pattern']:
                antipatterns_content += f"**Pattern**: {pitfall['pattern']}\n\n"
            antipatterns_content += f"*Discovered: {pitfall['timestamp']}*\n\n"
        
        # Check if anti-patterns section exists
        if patterns_file.exists():
            with open(patterns_file, 'r') as f:
                content = f.read()
            
            if "## Discovered Anti-patterns" not in content:
                with open(patterns_file, 'a') as f:
                    f.write(antipatterns_content)
    
    def monitor_context_health(self):
        """Monitor health of context files and suggest updates"""
        health_report = {
            "timestamp": datetime.now().isoformat(),
            "structure": "multi-project" if self.is_multi_project else "single-project",
            "project": self.project_name if self.is_multi_project else "single",
            "context_files": {},
            "recommendations": [],
            "overall_health": 100
        }
        
        context_files = {
            "projectBrief.md": {"required": True, "max_age_days": 90},
            "productContext.md": {"required": True, "max_age_days": 30},
            "systemPatterns.md": {"required": True, "max_age_days": 14},
            "techContext.md": {"required": True, "max_age_days": 30}
        }
        
        # Check shared patterns if multi-project
        if self.is_multi_project and self.shared_path:
            shared_patterns = self.shared_path / "patterns.md"
            if shared_patterns.exists():
                age_days = (datetime.now().timestamp() - shared_patterns.stat().st_mtime) / (24 * 3600)
                health_report["shared_patterns_age_days"] = round(age_days, 1)
                if age_days > 30:
                    health_report["recommendations"].append(
                        f"Review shared/patterns.md - last updated {age_days:.0f} days ago"
                    )
        
        for filename, config in context_files.items():
            file_path = self.project_path / "context" / filename
            file_health = {"exists": file_path.exists()}
            
            if file_path.exists():
                # Check age
                mod_time = file_path.stat().st_mtime
                age_days = (datetime.now().timestamp() - mod_time) / (24 * 3600)
                file_health["age_days"] = round(age_days, 1)
                file_health["size_bytes"] = file_path.stat().st_size
                
                # Check if update needed
                if age_days > config["max_age_days"]:
                    health_report["recommendations"].append(
                        f"Update {filename} - last modified {age_days:.0f} days ago"
                    )
                    health_report["overall_health"] -= 10
                
                # Check if too small (likely incomplete)
                if file_health["size_bytes"] < 100:
                    health_report["recommendations"].append(
                        f"Expand {filename} - only {file_health['size_bytes']} bytes"
                    )
                    health_report["overall_health"] -= 15
            else:
                file_health["age_days"] = None
                file_health["size_bytes"] = 0
                if config["required"]:
                    health_report["recommendations"].append(
                        f"Create {filename} - required context file missing"
                    )
                    health_report["overall_health"] -= 25
            
            health_report["context_files"][filename] = file_health
        
        # Check active work health
        active_files = ["activeContext.md", "tasks.md", "progress.md"]
        for filename in active_files:
            file_path = self.project_path / "active" / filename
            if file_path.exists():
                age_hours = (datetime.now().timestamp() - file_path.stat().st_mtime) / 3600
                if age_hours > 48:
                    health_report["recommendations"].append(
                        f"Review {filename} - inactive for {age_hours:.0f} hours"
                    )
        
        health_report["overall_health"] = max(0, health_report["overall_health"])
        
        # Save health report in project directory
        health_file = self.project_path / "health-report.json"
        with open(health_file, 'w') as f:
            json.dump(health_report, f, indent=2)
        
        return health_report
    
    def validate_structure(self):
        """Validate Memory Bank directory structure and report issues"""
        validation_report = {
            "timestamp": datetime.now().isoformat(),
            "structure_type": "multi-project" if self.is_multi_project else "single-project",
            "project": self.project_name if self.is_multi_project else "single",
            "valid": True,
            "errors": [],
            "warnings": [],
            "structure": {}
        }
        
        # Define required structure based on type
        if self.is_multi_project:
            # Multi-project structure
            required_dirs = {
                "custom_modes": "Mode instruction files",
                "shared": "Cross-project resources",
                "scripts": "Automation scripts"
            }
            
            # Check top-level directories
            for dir_name, description in required_dirs.items():
                dir_path = self.memory_bank / dir_name
                if not dir_path.exists():
                    validation_report["errors"].append(f"Missing required directory: {dir_name} ({description})")
                    validation_report["valid"] = False
                else:
                    validation_report["structure"][dir_name] = "✓"
            
            # Check project structure
            if self.project_name:
                project_dirs = {
                    "context": ["projectBrief.md", "productContext.md", "systemPatterns.md", "techContext.md"],
                    "active": ["activeContext.md", "tasks.md", "progress.md"],
                    "technical": [],
                    "decisions": ["log.md"],
                    "qa": []
                }
                
                for dir_name, required_files in project_dirs.items():
                    dir_path = self.project_path / dir_name
                    if not dir_path.exists():
                        validation_report["warnings"].append(f"Missing {dir_name}/ in project '{self.project_name}'")
                    else:
                        validation_report["structure"][f"{self.project_name}/{dir_name}"] = "✓"
                        
                        # Check required files
                        for file_name in required_files:
                            file_path = dir_path / file_name
                            if not file_path.exists():
                                validation_report["warnings"].append(
                                    f"Missing {file_name} in {self.project_name}/{dir_name}/"
                                )
        else:
            # Single-project structure
            required_dirs = {
                "context": ["projectBrief.md", "productContext.md", "systemPatterns.md", "techContext.md"],
                "active": ["activeContext.md", "tasks.md", "progress.md"],
                "technical": [],
                "decisions": ["log.md"],
                "qa": [],
                "custom_modes": ["van_instructions.md", "plan_instructions.md", 
                               "implement_instructions.md", "reflect_instructions.md"],
                "scripts": ["auto-update.py"]
            }
            
            for dir_name, required_files in required_dirs.items():
                dir_path = self.memory_bank / dir_name
                if not dir_path.exists():
                    validation_report["errors"].append(f"Missing required directory: {dir_name}/")
                    validation_report["valid"] = False
                else:
                    validation_report["structure"][dir_name] = "✓"
                    
                    # Check required files
                    for file_name in required_files:
                        file_path = dir_path / file_name
                        if not file_path.exists():
                            validation_report["warnings"].append(f"Missing {file_name} in {dir_name}/")
        
        # Check root files (BOOTSTRAP.md is now internal at .memory-bank/)
        root_files = ["../starter-prompt.md"]
        for file_name in root_files:
            file_path = self.memory_bank / file_name
            if not file_path.exists():
                validation_report["warnings"].append(f"Missing {file_name}")
        
        # Check for BOOTSTRAP.md in .memory-bank
        bootstrap_path = self.memory_bank / "BOOTSTRAP.md"
        if not bootstrap_path.exists():
            validation_report["errors"].append("Missing BOOTSTRAP.md in .memory-bank/")
        
        # Generate summary
        error_count = len(validation_report["errors"])
        warning_count = len(validation_report["warnings"])
        
        if error_count == 0 and warning_count == 0:
            validation_report["summary"] = "✅ Memory Bank structure is valid and complete"
        elif error_count == 0:
            validation_report["summary"] = f"⚠️  Structure valid with {warning_count} warning(s)"
        else:
            validation_report["summary"] = f"❌ Structure invalid: {error_count} error(s), {warning_count} warning(s)"
        
        return validation_report
    
    def extract_git_decisions(self):
        """Extract architectural decisions from git history"""
        decisions = []
        
        try:
            # Get detailed git log
            result = subprocess.run(
                ['git', 'log', '--pretty=format:%H|%ai|%s|%b', '--since="30 days ago"'],
                capture_output=True, text=True, cwd=self.project_root
            )
            
            if result.returncode != 0:
                return decisions
            
            decision_keywords = [
                'refactor', 'architecture', 'design', 'pattern', 'implement',
                'migrate', 'optimize', 'restructure', 'introduce', 'decision'
            ]
            
            for line in result.stdout.strip().split('\n'):
                if not line:
                    continue
                
                parts = line.split('|', 3)
                if len(parts) < 3:
                    continue
                
                commit_hash, date, subject = parts[:3]
                body = parts[3] if len(parts) > 3 else ""
                full_message = subject + " " + body
                
                # Check for decision indicators
                if any(keyword in full_message.lower() for keyword in decision_keywords):
                    # Extract decision details
                    decision = {
                        "hash": commit_hash[:8],
                        "date": date.split()[0],
                        "subject": subject,
                        "type": self._classify_decision(full_message.lower()),
                        "impact": self._assess_impact(full_message)
                    }
                    
                    # Look for "why" in commit body
                    why_match = re.search(r'(?:why|because|reason)[:.]?\s*(.+?)(?:\n|$)', body, re.IGNORECASE)
                    if why_match:
                        decision["rationale"] = why_match.group(1).strip()
                    
                    decisions.append(decision)
            
            # Update design-log.md
            self._update_design_log(decisions)
            
        except Exception as e:
            print(f"Error extracting git decisions: {e}")
        
        return decisions
    
    def _classify_decision(self, message):
        """Classify decision type from message"""
        classifications = {
            "refactoring": ['refactor', 'restructure', 'reorganize'],
            "architecture": ['architecture', 'design', 'pattern'],
            "feature": ['add', 'implement', 'introduce', 'create'],
            "optimization": ['optimize', 'improve', 'performance', 'speed'],
            "migration": ['migrate', 'upgrade', 'update'],
            "cleanup": ['remove', 'cleanup', 'delete']
        }
        
        for decision_type, keywords in classifications.items():
            if any(keyword in message for keyword in keywords):
                return decision_type
        
        return "other"
    
    def _assess_impact(self, message):
        """Assess impact level of decision"""
        high_impact = ['major', 'breaking', 'architecture', 'redesign', 'overhaul']
        medium_impact = ['refactor', 'enhance', 'improve', 'update']
        
        message_lower = message.lower()
        if any(word in message_lower for word in high_impact):
            return "high"
        elif any(word in message_lower for word in medium_impact):
            return "medium"
        return "low"
    
    def _update_design_log(self, decisions):
        """Update log.md with extracted decisions"""
        if not decisions:
            return
        
        design_log = self.project_path / "decisions" / "log.md"
        
        # Read existing content
        existing_content = ""
        if design_log.exists():
            with open(design_log, 'r') as f:
                existing_content = f.read()
        
        # Add auto-extracted section if not present
        if "## Auto-Extracted from Git History" not in existing_content:
            with open(design_log, 'a') as f:
                f.write("\n\n## Auto-Extracted from Git History\n")
                f.write(f"*Updated: {datetime.now().strftime('%Y-%m-%d')}*\n\n")
                
                # Group by type
                by_type = {}
                for decision in decisions:
                    if decision['type'] not in by_type:
                        by_type[decision['type']] = []
                    by_type[decision['type']].append(decision)
                
                for decision_type, type_decisions in by_type.items():
                    f.write(f"### {decision_type.title()}\n\n")
                    for d in type_decisions:
                        f.write(f"**{d['subject']}** ({d['hash']})\n")
                        f.write(f"- Date: {d['date']}\n")
                        f.write(f"- Impact: {d['impact']}\n")
                        if 'rationale' in d:
                            f.write(f"- Rationale: {d['rationale']}\n")
                        f.write("\n")
    
    def _scan_code_patterns(self):
        """Scan codebase for patterns"""
        patterns = {
            "utilities": [],
            "components": [],
            "error_patterns": [],
            "api_patterns": []
        }
        
        # Scan for different file types
        for ext in ['.py', '.js', '.ts', '.jsx', '.tsx']:
            for file_path in self.project_root.rglob(f"*{ext}"):
                if any(skip in str(file_path) for skip in ['node_modules', 'dist', 'build', '.git']):
                    continue
                
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Look for error handling patterns
                    error_patterns = re.findall(r'(?:try|catch|throw|Error|Exception)', content)
                    if error_patterns:
                        patterns["error_patterns"].append({
                            "file": str(file_path.relative_to(self.project_root)),
                            "count": len(error_patterns)
                        })
                    
                    # Look for API patterns
                    api_patterns = re.findall(r'(?:fetch|axios|request|api|endpoint)', content, re.IGNORECASE)
                    if api_patterns:
                        patterns["api_patterns"].append({
                            "file": str(file_path.relative_to(self.project_root)),
                            "count": len(api_patterns)
                        })
                
                except Exception:
                    continue
        
        return patterns
    
    def promote_to_shared(self, pattern_type, pattern_content):
        """Promote a pattern to shared/patterns.md in multi-project repos"""
        if not self.is_multi_project:
            print("Pattern promotion only available in multi-project repositories")
            return
        
        shared_patterns = self.shared_path / "patterns.md"
        
        # Ensure file exists
        if not shared_patterns.exists():
            with open(shared_patterns, 'w') as f:
                f.write("# Shared Patterns\n\n")
                f.write("Patterns that are reusable across multiple projects.\n\n")
        
        # Append pattern
        with open(shared_patterns, 'a') as f:
            f.write(f"\n## {pattern_type}\n")
            f.write(f"*Added: {datetime.now().strftime('%Y-%m-%d')}*\n\n")
            f.write(pattern_content)
            f.write("\n")
        
        print(f"✅ Pattern promoted to shared/patterns.md")
    
    def _format_patterns_for_context(self, patterns):
        """Format discovered patterns for systemPatterns.md"""
        if not any(patterns.values()):
            return ""
        
        content = ""
        
        if patterns["error_patterns"]:
            content += "### Error Handling Patterns Found\n"
            for p in sorted(patterns["error_patterns"], key=lambda x: x["count"], reverse=True)[:5]:
                content += f"- `{p['file']}` - {p['count']} error handling constructs\n"
            content += "\n"
        
        if patterns["api_patterns"]:
            content += "### API Communication Patterns Found\n"
            for p in sorted(patterns["api_patterns"], key=lambda x: x["count"], reverse=True)[:5]:
                content += f"- `{p['file']}` - {p['count']} API-related patterns\n"
            content += "\n"
        
        return content

def main():
    parser = argparse.ArgumentParser(
        description="🤖 Claude Memory Bank Automation - Context-Driven Workflow System v2.0",
        epilog="""
Examples:
  Single-project:
    %(prog)s --health-check
    %(prog)s --scan-patterns
    %(prog)s --all
    
  Multi-project:
    %(prog)s --list-projects
    %(prog)s --health-check --project-name api-service
    %(prog)s --all --project-name web-app
    
For detailed task descriptions:
    %(prog)s --list-tasks
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    # Task automation group
    tasks = parser.add_argument_group('🔧 Automation Tasks')
    tasks.add_argument("--scan-patterns", action="store_true", 
                       help="Scan codebase for patterns and update systemPatterns.md")
    tasks.add_argument("--extract-pitfalls", action="store_true", 
                       help="Extract issue→solution patterns from progress.md")
    tasks.add_argument("--extract-decisions", action="store_true", 
                       help="Mine git history for architectural decisions (last 30 days)")
    tasks.add_argument("--health-check", action="store_true", 
                       help="Check context files health and generate recommendations")
    tasks.add_argument("--validate-structure", action="store_true",
                       help="Validate Memory Bank directory structure and report issues")
    tasks.add_argument("--all", action="store_true", 
                       help="Run all automation tasks in sequence")
    
    # Configuration group
    config = parser.add_argument_group('⚙️  Configuration')
    config.add_argument("--project-root", default=".", metavar="PATH",
                        help="Project root directory (default: current directory)")
    config.add_argument("--project-name", metavar="NAME",
                        help="Project name (required for multi-project repositories)")
    
    # Information group
    info = parser.add_argument_group('ℹ️  Information')
    info.add_argument("--list-projects", action="store_true",
                      help="List available projects in multi-project repository")
    info.add_argument("--list-tasks", action="store_true",
                      help="Show detailed descriptions of all automation tasks")
    
    args = parser.parse_args()
    
    # Handle list-tasks
    if args.list_tasks:
        print("🤖 Claude Memory Bank Automation Tasks\n")
        print("=" * 60)
        
        tasks = [
            {
                "flag": "--scan-patterns",
                "name": "Pattern Scanner",
                "description": "Scans your codebase for common patterns and updates systemPatterns.md",
                "details": [
                    "• Identifies error handling patterns",
                    "• Finds API communication patterns",
                    "• Discovers utility functions and components",
                    "• Auto-updates context/systemPatterns.md",
                    "• Suggests patterns for shared/ in multi-project repos"
                ]
            },
            {
                "flag": "--extract-pitfalls",
                "name": "Pitfall Extractor",
                "description": "Extracts issue → solution patterns from progress.md",
                "details": [
                    "• Parses progress logs for documented issues",
                    "• Captures solutions and workarounds",
                    "• Creates anti-patterns documentation",
                    "• Updates systemPatterns.md with lessons learned",
                    "• Helps prevent repeating past mistakes"
                ]
            },
            {
                "flag": "--extract-decisions",
                "name": "Decision Miner",
                "description": "Mines git history for architectural decisions",
                "details": [
                    "• Analyzes commit messages from last 30 days",
                    "• Identifies refactoring and design changes",
                    "• Extracts rationale from commit bodies",
                    "• Categorizes by impact (high/medium/low)",
                    "• Updates decisions/log.md automatically"
                ]
            },
            {
                "flag": "--health-check",
                "name": "Context Health Monitor",
                "description": "Checks the health and freshness of context files",
                "details": [
                    "• Verifies all required context files exist",
                    "• Checks file age against recommended limits",
                    "• Monitors file sizes for completeness",
                    "• Tracks active work staleness",
                    "• Generates health report with recommendations"
                ]
            },
            {
                "flag": "--validate-structure",
                "name": "Structure Validator",
                "description": "Validates Memory Bank directory structure",
                "details": [
                    "• Checks all required directories exist",
                    "• Verifies essential files are present",
                    "• Validates single vs multi-project setup",
                    "• Reports errors and warnings",
                    "• Ensures structural integrity"
                ]
            },
            {
                "flag": "--all",
                "name": "Full Automation Suite",
                "description": "Runs all automation tasks in sequence",
                "details": [
                    "• Executes all tasks above",
                    "• Provides comprehensive repository analysis",
                    "• Updates all relevant documentation",
                    "• Best for periodic maintenance",
                    "• Generates complete health assessment"
                ]
            }
        ]
        
        for task in tasks:
            print(f"\n📌 {task['flag']}")
            print(f"   {task['name']}: {task['description']}")
            print("\n   What it does:")
            for detail in task['details']:
                print(f"   {detail}")
        
        print("\n" + "=" * 60)
        print("\n💡 Usage Examples:\n")
        print("   Single-project:")
        print("   python auto-update-hybrid.py --health-check")
        print("   python auto-update-hybrid.py --all")
        print("\n   Multi-project:")
        print("   python auto-update-hybrid.py --list-projects")
        print("   python auto-update-hybrid.py --scan-patterns --project-name api-service")
        print("   python auto-update-hybrid.py --all --project-name web-app")
        print()
        return
    
    # Handle list-projects separately
    if args.list_projects:
        memory_bank = Path(args.project_root) / ".memory-bank"
        if memory_bank.exists():
            shared_path = memory_bank / "shared"
            if shared_path.exists():
                projects = [d.name for d in memory_bank.iterdir() 
                           if d.is_dir() and d.name != "shared"]
                print(f"Available projects: {', '.join(projects)}")
            else:
                print("This is a single-project repository")
        else:
            print("Memory Bank not found")
        return
    
    automation = MemoryBankAutomation(args.project_root, args.project_name)
    
    # Print repository type
    if automation.is_multi_project:
        print(f"🏢 Multi-project repository - Working on: {automation.project_name}")
    else:
        print("🏠 Single-project repository")
    print()
    
    if args.all or args.scan_patterns:
        print("📊 Scanning for code patterns...")
        patterns = automation.scan_and_update_patterns()
        total = sum(len(v) for v in patterns.values())
        print(f"   Found {total} patterns across codebase")
    
    if args.all or args.extract_pitfalls:
        print("🔍 Extracting pitfall → solution patterns...")
        pitfalls = automation.extract_pitfall_solutions()
        print(f"   Extracted {len(pitfalls)} pitfall solutions")
    
    if args.all or args.extract_decisions:
        print("📝 Extracting decisions from git history...")
        decisions = automation.extract_git_decisions()
        print(f"   Found {len(decisions)} architectural decisions")
    
    if args.all or args.health_check:
        print("🏥 Checking context files health...")
        health = automation.monitor_context_health()
        print(f"   Overall health: {health['overall_health']}%")
        if health['recommendations']:
            print("   Recommendations:")
            for rec in health['recommendations']:
                print(f"   - {rec}")
    
    if args.all or args.validate_structure:
        print("🏗️  Validating Memory Bank structure...")
        validation = automation.validate_structure()
        print(f"   {validation['summary']}")
        
        if validation['errors']:
            print("   ❌ Errors:")
            for error in validation['errors']:
                print(f"      - {error}")
        
        if validation['warnings']:
            print("   ⚠️  Warnings:")
            for warning in validation['warnings']:
                print(f"      - {warning}")
    
    if not any(vars(args).values()):
        parser.print_help()

if __name__ == "__main__":
    main()