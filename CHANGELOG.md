# Changelog

All notable changes to Claude Memory Bank will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.0] - 2025-07-01

### Breaking Changes
- **Bootstrap File Moved**: CLAUDE.md renamed to .memory-bank/BOOTSTRAP.md
  - Prevents conflicts with user's Claude Code configurations
  - Bootstrap file now internal, accessed only via slash commands
  - No more CLAUDE.md files created in project root
  - `/user:memory-bank:activate` updated to read new location

### Changed
- setup-memory-bank.sh no longer creates CLAUDE.md
- install.sh status check updated for new location
- sync-from-project.sh updated to sync BOOTSTRAP.md
- All documentation updated to reflect new structure

### Migration Guide
1. Existing installations will continue to work
2. New installations use .memory-bank/BOOTSTRAP.md
3. Run `cmb-update` to get latest changes
4. No user action required for single user

## [2.2.0] - 2025-06-30

### Breaking Changes
- **Slash Commands Moved to User Level**: All slash commands now use user-level namespace
  - Old: `/project:ask`, `/project:van`, etc.
  - New: `/user:memory-bank:ask`, `/user:memory-bank:van`, etc.
  - Commands now installed at `~/.claude/commands/memory-bank/`
  - Run installer to add: `curl -sSL https://raw.githubusercontent.com/doublefx/claude-memory-bank/main/install.sh | bash`

### Added
- **.env Optimization**: Dramatically reduced token usage in VAN mode
  - Added `.memory-bank/.env` file to track initialization state
  - VAN mode now checks .env instead of analyzing all context files
  - 90%+ reduction in token usage for initialization checks
  - Backward compatible - handles missing .env files gracefully
- **Comprehensive Uninstall Command**: Safe removal of Memory Bank
  - New `claude-memory-uninstall` command with multiple options
  - `cmb-uninstall` alias for convenience
  - Dry-run mode to preview changes before deletion
  - Options for system-only, project-only, or complete removal
  - `--keep-knowledge` option to preserve context while removing infrastructure
  - Backup functionality to preserve data before removal
  - Automatic shell configuration cleanup

### Changed
- Renamed `memory-bank.md` command to `activate.md` for clarity
- Updated install.sh to manage user-level slash commands
- Updated setup-memory-bank.sh to clean up old project-level commands
- Commands are now updated automatically when running `claude-memory-update`
- VAN mode instructions simplified with .env optimization
- sync-from-project.sh now creates .env for existing installations

### Migration Guide
1. Run the installer to get new user-level commands
2. Old project-level commands will be automatically cleaned up by setup script
3. Update any scripts/docs that reference old command paths

## [2.1.0] - 2025-06-30

### Added
- **ASK Mode**: New 5th mode for read-only conversational exploration
  - Safe space for questions and requirements clarification
  - No file modifications allowed
  - Accessible via `@ASK` or `/project:ask` (now `/user:memory-bank:ask` in v2.2)
  - Guides users to appropriate workflow mode when ready
- **Claude Code Terminal Integration**: Full slash command support
  - Six slash commands in `.claude/commands/` directory
  - `/project:ask`, `/project:van`, `/project:plan`, `/project:implement`, `/project:reflect`
  - `/project:memory-bank` to force reading the bootstrap file
  - (All moved to user-level namespace in v2.2)
  - Each command maps to corresponding @ mode
- **Temporary File Tracking System**: New `temp-files.md` in active directory
  - Table format for tracking transient resources
  - REFLECT mode integration for cleanup prompts
  - Helps maintain clean project structure
- **Test Enhancements**: Comprehensive v2.1.0 feature verification
  - New `verify_v21_features()` function in test suite
  - Tests for slash commands, ASK mode, and temp file tracking
  - Conditional logic for multi-project test scenarios

### Changed
- Updated workflow from 4 modes to 5 modes (ASK → VAN → PLAN → IMPLEMENT → REFLECT)
- Enhanced all mode instructions with mandatory update checkboxes
- Improved QUICK-REFERENCE.md with new features and best practices
- Updated version to 2.1.0 throughout all documentation

### Fixed
- **Sub-project slash commands**: Fixed bug where sub-projects in multi-repo setups didn't receive slash commands
  - Updated `create_project_structure()` in setup-memory-bank.sh
  - Now properly copies `.claude/commands/` to all sub-projects
- **Test string matching**: Fixed grep pattern issues with `-F` flag for literal strings
- **Multi-project test logic**: Skip root-level temp-files.md check for multi-root projects

### Documentation
- Updated Memory Bank context files (projectBrief.md, systemPatterns.md)
- Enhanced technical documentation (architecture.md, implementation-guide.md, mode-specifications.md)
- Added v2.1.0 patterns for test implementation and bug fixes

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