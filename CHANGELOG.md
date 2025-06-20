# Changelog

All notable changes to Claude Memory Bank will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-06-20

### Changed
- **BREAKING**: Redesigned as Memory Bank Hybrid System v2.0 - Context-Driven Workflow
- **BREAKING**: Changed folder name from `memory-bank` to `.memory-bank` (hidden) for cleaner project structure
- **BREAKING**: V1 to V2 migration now automatically handles ALL subdirectories in hierarchical projects
- Simplified from 6 modes to 4 modes (VAN, PLAN, IMPLEMENT, REFLECT)
- Shifted focus to context-first development with persistent context files
- Reduced complexity levels from 4 to 3 for streamlined workflow routing
- PLAN mode now incorporates design exploration for Level 3 tasks (previously CREATIVE mode)
- Enhanced multi-project support with automatic active task detection
- Improved project structure detection for single vs multi-project repositories
- Migration output formatting changed from bullet points to hyphens for better compatibility

### Added
- Context persistence as primary feature - context files created once and updated continuously
- Active task detection across multiple projects on startup
- Smart project switching in multi-project repositories
- Support for hierarchical project setup automation (non-interactive mode)
- Enhanced error recovery mechanisms for missing or stale context
- Automated v1.x to v2.0 migration that processes all subdirectories in one operation
- Comprehensive test suite with 7 scenarios covering all setup options
- Migration preserves hierarchy.json files during the upgrade process
- Local copy of setup-memory-bank.sh for --add-project functionality

### Fixed
- Fixed arithmetic operation bug in setup-hierarchy.sh causing script exit with `set -e` when incrementing from 0
- Fixed hierarchy scripts (setup-hierarchy.sh, detect-hierarchy.py, auto-setup-hierarchy.py) not being copied during setup
- Fixed setup-hierarchy.sh only processing root repository instead of all sub-projects
- Fixed v1 to v2 migration subshell variable scoping issues
- Fixed echo/printf handling for reliable newline output in migration function
- Fixed directory navigation in nested structures using absolute paths
- Fixed template path references from `memory-bank/` to `.memory-bank/`

### Removed
- Removed ARCHIVE mode (knowledge preservation now continuous through context updates)
- Removed CREATIVE mode (design exploration integrated into PLAN mode for Level 3)
- Removed Level 4 complexity (architectural changes now Level 3)
- Removed separate design exploration phase (now part of PLAN when needed)

## [1.0.0] - 2024-06-04

### Added
- Complete Claude Code adaptation of cursor-memory-bank methodology by @vanzan01
- 6-mode workflow system (VAN, PLAN, CREATIVE, IMPLEMENT, REFLECT, ARCHIVE)
- Complexity-based routing (Level 1-4) with automatic workflow path determination
- File-based configuration system for Claude Code integration
- Global installation system with one-line installer
- Project setup automation with `claude-memory-setup` command
- Comprehensive mode instruction files with mandatory actions and quality gates
- Creative phase integration using Claude's "Think" methodology
- Context preservation across Claude Code sessions via persistent files
- Automation enhancements with pattern detection and decision extraction
- Cross-project learning and pattern sharing capabilities

### Core Files
- `CLAUDE.md` - Complete Claude Code configuration with mode definitions
- `starter-prompt.md` - Initialization guide for first-time users
- `install.sh` - Global installation script with shell integration
- `setup-memory-bank.sh` - Project-specific setup automation
- `memory-bank/custom_modes/` - Six specialized mode instruction files
- `memory-bank/scripts/auto-update.py` - Automation and enhancement scripts

### Mode System
- **VAN Mode**: Project initialization and complexity assessment (MANDATORY entry point)
- **PLAN Mode**: Detailed implementation planning with creative component identification
- **CREATIVE Mode**: Structured design exploration with systematic option analysis
- **IMPLEMENT Mode**: Systematic code building with continuous progress tracking
- **REFLECT Mode**: Quality validation and lessons learned capture
- **ARCHIVE Mode**: Knowledge preservation and workflow completion (Level 3-4)

### Workflow Routing
- **Level 1**: VAN → IMPLEMENT (Quick bug fixes, < 30 minutes)
- **Level 2**: VAN → PLAN → IMPLEMENT → REFLECT (Simple enhancements, 2-8 hours)
- **Level 3**: VAN → PLAN → CREATIVE → IMPLEMENT → REFLECT → ARCHIVE (Complex features, 1-3 days)
- **Level 4**: VAN → PLAN → CREATIVE → IMPLEMENT → REFLECT → ARCHIVE (System architecture, 1+ weeks)

### Key Features
- **tasks.md as Sacred Source of Truth**: Central task tracking that cannot be bypassed
- **Mandatory Action Enforcement**: Each mode has required actions that must be completed
- **Quality Gate System**: Exit criteria must be met before mode transitions
- **Context Preservation**: File-based memory system maintains state across sessions
- **Creative Phase Rigor**: Level 3-4 components must complete full design exploration
- **Automation Integration**: Pattern detection, decision extraction, and maintenance tools

### Attribution
- Original methodology by @vanzan01 (cursor-memory-bank)
- Claude Code adaptation preserves 100% of workflow integrity
- File-based configuration system enables Claude Code integration
- Enhanced with automation and cross-project learning capabilities

### Documentation
- Comprehensive README with examples and troubleshooting
- Detailed mode instructions with step-by-step processes
- Installation and setup guides for various environments
- Contributing guidelines for community development
- MIT License with proper attribution to original methodology

---

## Development Notes

### Version 1.0.0 represents:
- **Complete methodology preservation** from cursor-memory-bank
- **Full Claude Code integration** with file-based configuration
- **Production-ready system** with comprehensive testing
- **Community-ready project** with proper documentation and licensing

### Future Development (planned):
- Enhanced pattern recognition and auto-extraction
- Integration with additional development tools
- Performance optimizations and user experience improvements
- Community-contributed enhancements and integrations

---

*Original methodology by @vanzan01 - Claude Code adaptation v1.0.0*