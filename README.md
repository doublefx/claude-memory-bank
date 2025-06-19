# Claude Memory Bank

> **Memory Bank System v2.0 - Generic Context-Driven Workflow**  
> Based on original methodology by [@vanzan01](https://github.com/vanzan01/cursor-memory-bank)  
> Supports both single-project and multi-project repositories  
> Combines context preservation with streamlined workflow (4 modes)

A context-driven development system for Claude Code that automatically adapts to your repository structure. Whether you're working on a single project or managing multiple projects in a monorepo, the Memory Bank system provides persistent context and structured workflows.

```mermaid
flowchart TD
    subgraph "Context Foundation"
        PB[📄 projectBrief.md] --> PC[🎯 productContext.md]
        PB --> SP[🏗️ systemPatterns.md]
        PB --> TC[⚙️ techContext.md]
    end
    
    subgraph "Workflow Modes"
        VAN[🔍 VAN: Initialize] --> PLAN[📋 PLAN: Strategy]
        VAN --> IMPLEMENT[⚒️ IMPLEMENT: Build]
        PLAN --> IMPLEMENT
        IMPLEMENT --> REFLECT[✅ REFLECT: Validate]
    end
    
    PC --> AC[💡 activeContext.md]
    SP --> AC
    TC --> AC
```

## 🎯 Core Objectives

The Memory Bank v2.0 system evolves to support flexible project structures while maintaining workflow quality:

- **4-Mode Workflow**: Simplified VAN → PLAN → IMPLEMENT → REFLECT progression
- **Auto-Detection**: Automatically identifies single vs multi-project repositories
- **Context First**: All work begins with understanding through context files
- **Project Isolation**: Each project maintains independent context in multi-project
- **Shared Patterns**: Cross-project learnings in multi-project repos
- **Adaptive Routing**: 3 complexity levels determine required modes
- **Living Documentation**: Context files evolve with each task
- **Active Task Awareness**: Scans and presents ongoing work across projects

## 🔄 Evolution: From Original to Hybrid

### Original System (6 Modes)
The original cursor-memory-bank used a comprehensive 6-mode workflow:
- **VAN** → **PLAN** → **CREATIVE** → **IMPLEMENT** → **REFLECT** → **ARCHIVE**
- Task-focused with `tasks.md` as central truth
- Separate CREATIVE mode for all design work
- Mandatory ARCHIVE mode for Level 3-4 tasks
- 4 complexity levels with rigid routing

### Memory Bank v2.0 (4 Modes) - Why It's Better

#### 1. **Reduced Complexity**
- **From 6 to 4 modes**: Eliminated redundant steps
- **CREATIVE merged into PLAN**: Design exploration happens where planning occurs
- **ARCHIVE eliminated**: Context files serve as living documentation
- **Result**: 33% fewer modes to navigate

#### 2. **Context-Driven Development**
- **4 Foundation Files**: `projectBrief.md`, `productContext.md`, `systemPatterns.md`, `techContext.md`
- **Persistent Understanding**: Context survives across tasks and sessions
- **Pattern Evolution**: Discoveries immediately enrich future work
- **Result**: Every decision is informed by accumulated knowledge

#### 3. **Flexible Workflow**
- **3 complexity levels** (vs 4): Simpler assessment
- **Optional modes**: Skip PLAN for Level 1 quick fixes
- **Integrated design**: No separate creative phase overhead
- **Result**: Right-sized process for each task

#### 4. **Living Documentation**
- **No duplicate archiving**: Knowledge goes directly to context files
- **Immediate availability**: Insights ready for next task
- **Continuous evolution**: Documentation grows organically
- **Result**: Always up-to-date, never stale

#### 5. **Better Developer Experience**
- **Faster onboarding**: Read context files to understand everything
- **Less ceremony**: Focus on building, not process
- **Natural flow**: Context → Plan → Build → Learn
- **Result**: More time coding, less time documenting

#### 6. **Multi-Project Support (v2.0)**
- **Auto-detection**: Recognizes repository structure
- **Task continuity**: Resume work across sessions
- **Shared patterns**: Cross-project learning
- **Project isolation**: Independent context per project
- **Result**: Scales from simple to complex repositories

## 🚀 Quick Start

### One-Line Installation
```bash
curl -sSL https://raw.githubusercontent.com/Jaabiruu/claude-memory-bank/main/install.sh | bash
```

### Project Setup

#### Single-Project Repository
```bash
# Navigate to your project
cd your-project

# Initialize Memory Bank (interactive)
setup-memory-bank.sh
# OR force single-project
setup-memory-bank.sh --single

# After setup, you can use the local copy:
./setup-memory-bank.sh --help
```

#### Multi-Project Repository
```bash
# Navigate to repository root
cd your-monorepo

# Initialize multi-project Memory Bank
setup-memory-bank.sh --multi

# Add projects later (using local copy)
./setup-memory-bank.sh --add-project
# Or with project name
./setup-memory-bank.sh --add-project project-name
```

### Start Working
```bash
# Start Claude Code and begin with VAN mode
@VAN
# VAN will detect structure and guide you
```

## 📋 System Requirements

- **Claude Code**: Latest version recommended
- **Python 3.7+**: For automation scripts
- **Git**: For decision extraction and version control
- **Bash/Shell**: For installation and setup scripts

## 📁 Installation Structure

After installation, the file structure is:
```
~/.claude-memory-bank/
├── claude-memory-bank/          # Git repository with templates
│   ├── setup-memory-bank.sh    # The actual setup script
│   ├── memory-bank/            # Template files
│   └── ...                     # Other template files
└── (no files at root level)    # Commands are in ~/.local/bin/
```

The `cmb-setup` command points to the script inside `claude-memory-bank/`.

## 🏗️ Architecture Overview

### Mode System
```
┌─────────────────────────────────────────────────────────┐
│                   MODE ROUTING (HYBRID)                 │
├─────────────────────────────────────────────────────────┤
│ Level 1: VAN → IMPLEMENT → REFLECT                    │
│ Level 2: VAN → PLAN → IMPLEMENT → REFLECT             │
│ Level 3: VAN → PLAN (with design) → IMPLEMENT → REFLECT│
└─────────────────────────────────────────────────────────┘
```

### File System

#### Single-Project Structure
```
project/
├── CLAUDE.md                    # Claude Code configuration
├── starter-prompt.md            # Initialization guide
├── memory-bank/
│   ├── custom_modes/            # Mode instruction files
│   │   ├── van_instructions.md
│   │   ├── plan_instructions.md
│   │   ├── implement_instructions.md
│   │   └── reflect_instructions.md
│   ├── context/                 # Foundation files
│   │   ├── projectBrief.md
│   │   ├── productContext.md
│   │   ├── systemPatterns.md
│   │   └── techContext.md
│   ├── active/                  # Current work
│   │   ├── tasks.md
│   │   ├── activeContext.md
│   │   └── progress.md
│   ├── technical/               # Deep implementation docs
│   ├── decisions/               # Design decisions
│   │   └── log.md
│   ├── qa/                      # Quality assurance
│   │   └── validation-results.md
│   └── scripts/                 # Automation tools
│       └── auto-update.py
```

#### Multi-Project Structure
```
monorepo/
├── CLAUDE.md                    # Claude Code configuration
├── starter-prompt.md            # Initialization guide
├── memory-bank/
│   ├── custom_modes/            # Mode instruction files
│   ├── shared/                  # Cross-project resources
│   │   ├── patterns.md          # Reusable patterns
│   │   └── conventions.md       # Global standards
│   ├── api-service/             # Project 1
│   │   ├── context/             # Project-specific context
│   │   ├── active/              # Current work
│   │   ├── technical/           # Implementation docs
│   │   ├── decisions/           # Project decisions
│   │   └── qa/                  # Project QA
│   ├── web-app/                 # Project 2
│   │   └── [same structure]
│   └── scripts/                 # Automation tools
```

## 🔧 Mode Detailed Documentation

### 🔍 VAN Mode - Initialization & Assessment
**Purpose**: Structure detection, project analysis and complexity assessment  
**Entry**: `@VAN` (MANDATORY starting point)  
**Output**: Context files, tasks.md with complexity level and routing

```markdown
Responsibilities:
- Detect single vs multi-project repository structure
- For multi-project: Scan all projects for active tasks
- Analyze project structure and requirements
- Create/update 4 context foundation files
- Assess complexity level (1-3) using defined criteria
- Route to appropriate next mode

Multi-Project Features:
- Lists all projects with active tasks
- Presents task continuation options
- Isolates context per project
- Reads shared patterns first
```

**Complexity Levels**:
- **Level 1**: Quick bug fix (< 1 hour) → IMPLEMENT
- **Level 2**: Feature/Enhancement (1 hour - 1 day) → PLAN
- **Level 3**: Complex feature (1+ days) → PLAN (with design)

### 📋 PLAN Mode - Strategy & Design
**Purpose**: Context-informed implementation strategy  
**Entry**: `@PLAN` (after VAN for Level 2-3)  
**Output**: Implementation plan with integrated design exploration

```markdown
Responsibilities:
- Create strategy using context files
- For Level 3: Include design exploration
- Document decisions in design-log.md
- Identify risks and mitigation strategies
```

### ⚙️ Context Files (Created by VAN)
**Purpose**: Foundation for all development work  
**Files**: 4 persistent context files

```markdown
Context Foundation:
- projectBrief.md: Overview and goals
- productContext.md: User needs and features
- systemPatterns.md: Architecture and conventions
- techContext.md: Technical implementation details
```

**Living Documentation**: Context files evolve with each task

### ⚒️ IMPLEMENT Mode - Build & Test
**Purpose**: Execute implementation following context and plan  
**Entry**: `@IMPLEMENT` (after VAN for Level 1, after PLAN for Level 2-3)  
**Output**: Working implementation with comprehensive testing

```markdown
Implementation Approach:
- Level 1: Focused bug fixing with immediate testing
- Level 2: Sequential component implementation  
- Level 3: Phased implementation applying design decisions
```

### 🔍 REFLECT Mode - Validate & Learn
**Purpose**: Quality validation and context updates  
**Entry**: `@REFLECT` (after IMPLEMENT)  
**Output**: Validation results and updated context files

```markdown
Validation & Learning:
- Requirements verification
- Test execution and validation
- Update context files with discoveries
- Document patterns and anti-patterns
- Context files serve as living documentation
```

## 🎛️ Advanced Features

### 🤖 Automation Scripts

#### Single-Project Commands
```bash
# Check context health
python memory-bank/scripts/auto-update.py --health-check

# Auto-detect code patterns
python memory-bank/scripts/auto-update.py --scan-patterns

# Extract decisions from git history  
python memory-bank/scripts/auto-update.py --extract-decisions

# List available tasks
python memory-bank/scripts/auto-update.py --list-tasks

# Run all automation
python memory-bank/scripts/auto-update.py --all
```

#### Hierarchical Project Analysis
```bash
# Detect nested repositories
python memory-bank/scripts/detect-hierarchy.py

# Save hierarchy map
python memory-bank/scripts/detect-hierarchy.py --save

# Output JSON structure
python memory-bank/scripts/detect-hierarchy.py --json
```

#### Automated Hierarchical Setup
```bash
# After initial setup in root, auto-setup all nested repos
python memory-bank/scripts/auto-setup-hierarchy.py

# Or use the bash version if available
bash memory-bank/scripts/setup-hierarchy.sh
```

#### Multi-Project Commands
```bash
# List all projects
python memory-bank/scripts/auto-update.py --list-projects

# Project-specific operations
python memory-bank/scripts/auto-update.py --health-check --project-name api-service
python memory-bank/scripts/auto-update.py --scan-patterns --project-name web-app

# Run all for specific project
python memory-bank/scripts/auto-update.py --all --project-name mobile-app
```

### 🔄 Cross-Project Learning
- Pattern detection and extraction
- Decision history analysis
- Best practices sharing
- Template evolution

### 📊 Progress Tracking
- Real-time workflow status
- Complexity assessment accuracy
- Time estimation improvements
- Quality metrics evolution

## 🛠️ Usage Examples

### Example 1: Simple Bug Fix (Level 1)
```
User: Fix the login validation error

@VAN
> Analyzes: Level 1 - Simple bug fix, single function change
> Creates: tasks.md with targeted fix plan
> Routes: Direct to IMPLEMENT

@IMPLEMENT  
> Fixes: Authentication validation logic
> Tests: Login scenarios
> Documents: Change details
> Routes: To REFLECT (optional for Level 1)
```

### Example 2: Multi-Project Task Selection
```
User: I need to work on the API improvements

@VAN
> Detects: Multi-project repository structure
> Scans: All projects for active tasks
> Finds: Active tasks in api-service and auth-service
> Presents: Task selection options

"Active tasks found:
1. api-service: 'Add rate limiting' (Level 2, in IMPLEMENT)
2. auth-service: 'Implement OAuth2' (Level 3, in PLAN)
3. Start new API task"

User: Continue with rate limiting

> Loads: api-service context and active work
> Routes: To IMPLEMENT mode to continue
```

### Example 3: Complex Feature (Level 3)
```
User: Add user dashboard with analytics

@VAN
> Analyzes: Level 3 - Complex feature, multiple components
> Creates/Updates: All 4 context files
> Synthesizes: activeContext.md
> Routes: To PLAN mode

@PLAN
> Plans: Multi-phase implementation strategy
> Explores: Dashboard design options (3 approaches)
> Decides: Recommended approach with justification
> Documents: Decisions in log.md
> Routes: To IMPLEMENT mode

@IMPLEMENT
> Builds: Phase 1 - Data layer
> Builds: Phase 2 - UI components
> Builds: Phase 3 - Integration
> Tests: Comprehensive validation
> Routes: To REFLECT mode

@REFLECT
> Validates: All requirements met
> Updates: Context files with new patterns
> Proposes: Dashboard pattern for shared/ (if multi-project)
> Completes: Workflow cycle
```

## 📚 Key Principles

### 🎯 Workflow Integrity
- **Never skip VAN mode**: Every workflow must start with proper initialization
- **Follow complexity routing**: Level determines required workflow path
- **Complete each mode**: Meet exit criteria before proceeding
- **Preserve context**: File-based system maintains state across sessions

### 📋 Context Files as Foundation
- 4 context files created/updated by VAN mode
- All decisions reference context for consistency
- Context evolves with each task
- Living documentation eliminates separate archive

### 🎨 Design Integration
- Level 3 tasks include design exploration in PLAN mode
- Context files guide all design decisions
- Pros/cons analysis for complex features
- Decisions documented in design-log.md

### ✅ Quality Gate Enforcement
- Each mode has mandatory exit criteria
- Cannot proceed without meeting requirements
- Validation checkpoints ensure completeness
- System prevents workflow shortcuts

## 📁 Git Configuration

### Recommended .gitignore Entries

Add these entries to your project's `.gitignore` to exclude Memory Bank temporary files:

```gitignore
# Memory Bank temporary files
memory-bank/**/*.tmp
memory-bank/**/*.bak
memory-bank/**/*.swp
memory-bank/**/.DS_Store
memory-bank/**/~*
memory-bank/**/#*#
```

**Note**: DO NOT ignore the entire `memory-bank/` directory, as it contains important context and documentation that should be version controlled.

## 🔧 Troubleshooting

### Common Issues

#### "tasks.md not found"
**Solution**: Start with `@VAN` mode to initialize properly.

#### "Mode not responding correctly"  
**Solution**: Check memory-bank/activeContext.md for current status. Ensure previous mode completed all exit criteria.

#### "Design exploration seems incomplete"
**Solution**: For Level 3 tasks, ensure PLAN mode includes thorough design exploration with multiple options.

#### "System confused about workflow state"
**Solution**: Review memory-bank/progress.md and activeContext.md. Use appropriate mode command to continue from current state.

### Recovery Commands
```bash
# Check system status
claude-memory-status

# View current workflow state
cat memory-bank/activeContext.md
cat memory-bank/progress.md

# Reset for new workflow
@VAN  # Start fresh cycle
```

## 🤝 Contributing

This project maintains the original cursor-memory-bank methodology by @vanzan01 while adapting it for Claude Code. Contributions should preserve the core workflow integrity while enhancing Claude Code integration.

### Development Setup
```bash
# Clone repository
git clone https://github.com/USER/claude-memory-bank.git
cd claude-memory-bank

# Install locally for testing
bash install.sh

# Test single-project setup
cd test-project
setup-memory-bank.sh --single

# Test multi-project setup
cd ../test-monorepo
setup-memory-bank.sh --multi
setup-memory-bank.sh --add-project
```

## 📖 Documentation

- **[Starter Guide](starter-prompt.md)**: Quick start instructions
- **[Mode Instructions](memory-bank/custom_modes/)**: Detailed mode documentation
- **[Configuration](CLAUDE.md)**: Complete Claude Code configuration
- **[Automation](memory-bank/scripts/)**: Automation and enhancement tools

## 🙏 Acknowledgments

- **[@vanzan01](https://github.com/vanzan01)**: Original cursor-memory-bank methodology creator
- **Anthropic**: Claude "Think" tool methodology integrated into PLAN mode
- **Claude Code Team**: File-based configuration system that enables this adaptation

## 🆕 What's New in v2.0

- **Structure Detection**: Automatically identifies repository type
- **Multi-Project Support**: Manage multiple projects in one repo
- **Active Task Scanning**: Find and resume work across projects
- **Shared Patterns**: Cross-project knowledge sharing
- **Enhanced Automation**: Project-aware scripts
- **Simplified Setup**: Interactive or forced setup options

### v2.1 Preview - Hierarchical Projects
- **Nested Repository Detection**: Identifies git submodules and nested repos
- **Hierarchy Analysis**: `detect-hierarchy.py` script maps project relationships
- **Automated Setup**: `auto-setup-hierarchy.py` sets up all repos at once
- **Distributed Setup**: Each repository maintains its own Memory Bank
- **Pattern Inheritance**: Child projects can reference parent patterns
- **No Breaking Changes**: Fully backward compatible with v2.0

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🎯 System Status

**Version**: 2.0  
**Status**: Production Ready  
**Features**: Single & Multi-Project Support  
**Compatibility**: Claude Code (all versions)  
**Methodology**: Context-driven with adaptive structure detection  

**Original**: [cursor-memory-bank](https://github.com/vanzan01/cursor-memory-bank) by @vanzan01  
**Adaptation**: Complete Claude Code integration with file-based configuration  

---

*Structured development workflows for the Claude Code era*