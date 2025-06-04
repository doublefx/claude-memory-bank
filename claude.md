# Claude Code Memory Bank Configuration

> **Memory Bank System v1.0** - Claude Code Adaptation  
> Original methodology by @vanzan01, adapted for Claude Code  
> Preserves 100% of workflow integrity with file-based configuration

## System Overview

You are Claude Code running the Memory Bank system - a structured, hierarchical workflow for software development that maintains context across all development phases. This system uses 6 specialized modes with complexity-based routing to ensure optimal development approaches.

### Core Workflow Modes

1. **VAN** - Project initialization and complexity assessment (MANDATORY entry point)
2. **PLAN** - Detailed implementation planning 
3. **CREATIVE** - Design and architecture exploration using "Think" methodology
4. **IMPLEMENT** - Systematic code building with progress tracking
5. **REFLECT** - Quality validation and lessons learned capture
6. **ARCHIVE** - Knowledge preservation and workflow completion (Level 3-4)

### Complexity-Based Routing

- **Level 1**: VAN → IMPLEMENT (Quick bug fixes)
- **Level 2**: VAN → PLAN → IMPLEMENT → REFLECT (Simple enhancements)
- **Level 3**: VAN → PLAN → CREATIVE → IMPLEMENT → REFLECT → ARCHIVE (Complex features)
- **Level 4**: VAN → PLAN → CREATIVE → IMPLEMENT → REFLECT → ARCHIVE (System architecture)

## Mode Commands

### @VAN - Initialization and Complexity Assessment
**Purpose**: Analyze project, assess complexity, create tasks.md as single source of truth  
**Mandatory Action**: MUST create/update memory-bank/tasks.md  
**Next Mode**: PLAN (Level 2-4) or IMPLEMENT (Level 1)

When `@VAN` is invoked:
1. Read memory-bank/custom_modes/van_instructions.md
2. Follow ALL mandatory actions (cannot be skipped)
3. Analyze project structure and requirements
4. Determine complexity level (1-4) using provided criteria
5. Create comprehensive tasks.md with required structure
6. Update memory-bank/activeContext.md and progress.md
7. Recommend next mode based on complexity assessment

### @PLAN - Implementation Planning  
**Purpose**: Create detailed implementation plan based on VAN assessment  
**Prerequisites**: VAN mode completed, tasks.md exists  
**Next Mode**: CREATIVE (if Level 3-4 components need design) or IMPLEMENT

When `@PLAN` is invoked:
1. Read memory-bank/custom_modes/plan_instructions.md
2. Verify VAN mode completion and complexity level
3. Create implementation plan appropriate to complexity level
4. Identify components requiring creative phases (Level 3-4)
5. Document challenges and risk mitigation strategies
6. Update memory-bank/tasks.md with implementation plan
7. Recommend CREATIVE mode (if design decisions needed) or IMPLEMENT mode

### @CREATIVE - Design and Architecture Exploration
**Purpose**: Structured design exploration for components requiring design decisions  
**Prerequisites**: PLAN mode completed with creative components identified  
**Methodology**: Claude's "Think" tool approach with systematic option analysis  
**Next Mode**: IMPLEMENT

When `@CREATIVE` is invoked:
1. Read memory-bank/custom_modes/creative_instructions.md
2. Read memory-bank/tasks.md for flagged creative components
3. For EACH flagged component, complete full creative phase:
   - 🎨🎨🎨 ENTERING CREATIVE PHASE: [COMPONENT]
   - Generate 2-4 design options
   - Analyze pros/cons systematically
   - Select and justify recommended approach
   - Document implementation guidelines
   - 🎨🎨🎨 EXITING CREATIVE PHASE
4. Create memory-bank/decisions/design-options.md
5. Update memory-bank/tasks.md with design decisions

### @IMPLEMENT - Systematic Code Implementation
**Purpose**: Execute implementation plan systematically with continuous progress tracking  
**Prerequisites**: PLAN completed (and CREATIVE for Level 3-4 with design components)  
**Next Mode**: REFLECT

When `@IMPLEMENT` is invoked:
1. Read memory-bank/custom_modes/implement_instructions.md
2. Read implementation plan from memory-bank/tasks.md
3. Read design decisions from memory-bank/decisions/design-options.md (Level 3-4)
4. Execute implementation based on complexity level:
   - Level 1: Targeted bug fix with immediate testing
   - Level 2: Sequential component implementation
   - Level 3-4: Phased implementation applying creative decisions
5. Test each component as implemented
6. Create memory-bank/implementation-log.md
7. Update memory-bank/progress.md continuously
8. Verify all requirements met before completion

### @REFLECT - Quality Validation and Lessons Learned
**Purpose**: Comprehensive validation and learning capture  
**Prerequisites**: IMPLEMENT mode completed  
**Next Mode**: ARCHIVE (Level 3-4) or workflow completion (Level 1-2)

When `@REFLECT` is invoked:
1. Read memory-bank/custom_modes/reflect_instructions.md
2. Read memory-bank/implementation-log.md for implementation details
3. Validate implementation against original requirements
4. Test functionality comprehensively
5. Evaluate design decisions (Level 3-4)
6. Document successes, challenges, and lessons learned
7. Create memory-bank/qa/validation-results.md
8. Recommend ARCHIVE mode (Level 3-4) or workflow completion (Level 1-2)

### @ARCHIVE - Knowledge Preservation and Workflow Completion
**Purpose**: Formal documentation and knowledge preservation for complex projects  
**Prerequisites**: REFLECT mode completed for Level 3-4 tasks  
**Result**: Complete workflow cycle finished

When `@ARCHIVE` is invoked:
1. Read memory-bank/custom_modes/archive_instructions.md
2. Read memory-bank/qa/validation-results.md for reflection insights
3. Create comprehensive archive document in memory-bank/archive/
4. Extract reusable patterns and best practices
5. Update memory-bank/shared/ with learned patterns
6. Finalize all memory-bank files
7. Reset memory-bank/activeContext.md for next cycle
8. Mark workflow as COMPLETE

## Critical System Rules

### Mandatory Requirements
1. **tasks.md is SACRED**: This is the single source of truth and CANNOT be optional
2. **VAN mode CANNOT be skipped**: Every workflow MUST start with VAN mode initialization
3. **Complexity routing MUST be followed**: Level determines which modes are required
4. **Creative phases CANNOT be rushed**: Level 3-4 components must complete full creative process
5. **Mode transitions require completion**: Cannot skip to next mode without meeting exit criteria

### File System Enforcement
- **memory-bank/tasks.md**: Central source of truth (created by VAN, updated by all modes)
- **memory-bank/activeContext.md**: Current work focus (updated by each mode)
- **memory-bank/progress.md**: Implementation status (continuously updated)
- **memory-bank/decisions/**: Design decisions and logs
- **memory-bank/qa/**: Quality assurance and validation results
- **memory-bank/archive/**: Completed project documentation (Level 3-4)

### Quality Gates
Each mode has specific exit criteria that MUST be met before proceeding:
- VAN: Complexity assessed, tasks.md created with complete structure
- PLAN: Implementation plan complete, creative components identified
- CREATIVE: All flagged components have design decisions with justification
- IMPLEMENT: All functionality built, tested, and documented
- REFLECT: Quality validated, lessons learned captured
- ARCHIVE: Knowledge preserved, workflow cycle complete

## Error Prevention

### Common Mistakes to Avoid
1. **Skipping VAN mode**: Never proceed without proper initialization
2. **Incomplete tasks.md**: VAN must create comprehensive task breakdown
3. **Rushing creative phases**: Level 3-4 components need thorough design exploration
4. **Missing mode transitions**: Always complete current mode before moving to next
5. **Ignoring complexity routing**: Follow the specific workflow path for each level

### Recovery Procedures
- If tasks.md is missing: Return to VAN mode immediately
- If complexity assessment unclear: Re-run VAN mode analysis
- If creative decisions insufficient: Return to CREATIVE mode for flagged components
- If implementation incomplete: Continue IMPLEMENT mode until all requirements met

## System Initialization

### First Use
1. Ensure memory-bank/ directory structure exists
2. Review starter-prompt.md for detailed setup instructions
3. Start with `@VAN` command to initialize first workflow
4. Follow complexity-based routing for subsequent modes

### Subsequent Use
1. Check memory-bank/activeContext.md for current status
2. If no active workflow: Start with `@VAN` for new task
3. If workflow in progress: Continue with next recommended mode
4. Always respect mode prerequisites and exit criteria

## Context Preservation

The Memory Bank system maintains context through persistent files:
- **tasks.md**: Complete task tracking and workflow state
- **activeContext.md**: Current focus and next actions
- **progress.md**: Implementation status and recent activity
- **decisions/**: Design decisions and reasoning
- **qa/**: Quality validation results
- **archive/**: Completed project knowledge

This file-based approach ensures context preservation across Claude Code sessions while maintaining the full workflow integrity of the original cursor-memory-bank methodology.

---

**Original Methodology**: @vanzan01 (cursor-memory-bank)  
**Claude Code Adaptation**: Preserves 100% workflow integrity with file-based configuration  
**System Version**: 1.0 - Complete Claude Code integration