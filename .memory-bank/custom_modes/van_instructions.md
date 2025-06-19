# VAN MODE - INITIALIZE & ASSESS (HYBRID)

> **Role**: Establish context foundation and assess task complexity
>
> **Entry Command**: `@VAN`
>
> **Primary Output**: Context files and complexity assessment

## CORE RESPONSIBILITIES

You are operating in VAN MODE - the mandatory entry point for all Memory Bank workflows. Your responsibilities in the hybrid system are:

1. **Project Structure Detection**: Identify single vs multi-project repository
2. **Context Creation/Update**: Establish or refresh the four context foundation files
3. **Active Task Scanning**: In multi-project repos, scan all projects for active work
4. **Project Analysis**: Deep understanding of project structure and purpose
5. **Complexity Assessment**: Determine appropriate workflow level (1-3)
6. **Task Initialization**: Create initial tasks.md with assessment
7. **Context Synthesis**: Generate activeContext.md from foundation files
8. **Workflow Routing**: Direct to appropriate next mode

## CONTEXT FILES TO MANAGE

### On First Run - Create All Four:

1. **projectBrief.md** - Project overview and goals
2. **productContext.md** - Business and user perspective
3. **systemPatterns.md** - Architecture and conventions
4. **techContext.md** - Technical implementation details

### On Subsequent Runs - Update as Needed:

- Refresh context based on new requirements
- Add discovered patterns or technical changes
- Update product context with new features
- Maintain context accuracy and relevance

## STEP-BY-STEP PROCESS

### 1. Project Structure Detection
```bash
# Determine if single or multi-project repository
if .memory-bank/shared/ exists:
    STRUCTURE = "Multi-Project"
    # List all project directories
    List all subdirectories in .memory-bank/ (excluding shared/)
else:
    STRUCTURE = "Single-Project"
```

### 2. Initial Context Check

**Template Detection**: Files are considered templates (needing initialization) if they:
- Contain multiple placeholder markers like `[Description]`, `[Date]`, etc.
- Have sections with only placeholder content
- Lack project-specific information
- Match the default template structure exactly

When templates are detected, treat as "Initialize" mode even if files exist.

#### For Single-Project:
```bash
# Check if context files exist and are not just templates
if .memory-bank/context/projectBrief.md exists:
    Read file content
    if file contains only placeholders like "[" and "]":
        MODE = "Initialize"
        Prepare for full analysis (templates need filling)
    else:
        MODE = "Update"
        Read all context files from .memory-bank/
        Read technical/ documentation
else:
    MODE = "Initialize"
    Prepare for full analysis
```

#### For Multi-Project:
```bash
# First read shared conventions
Read .memory-bank/shared/ for global patterns

# Then scan ALL projects for active tasks
for each project in .memory-bank/:
    # Check if project has real content or just templates
    if project/context/projectBrief.md exists:
        Read file content
        if file contains only placeholders:
            Mark project as "needs initialization"
    
    if project/active/tasks.md exists:
        Read tasks to check status
        Note any in_progress or pending tasks

# Present active tasks to user
if active tasks found:
    Display: "Active tasks found in:
    - project-a: '[task description]' (Level X, in [mode])
    - project-b: '[task description]' (Level Y, in [mode])
    
    Would you like to continue one of these tasks or start something new?"
    
    Wait for user selection
```

**Important directories to review**:
- In single-project: `technical/` for deep implementation docs
- In multi-project: `shared/` for cross-project conventions
- Historical decisions in `decisions/`
- Architecture diagrams in `images/`

### 3. Project Analysis

#### For Single-Project:
- Examine complete project structure
- Identify technology stack and frameworks
- Understand build and deployment setup
- Locate key directories and entry points
- Review existing documentation
- Check technical/ for deep implementation details

#### For Multi-Project:
- If continuing existing task: Focus on selected project
- If new task: Analyze relevant project structure
- Consider shared conventions and patterns
- Understand cross-project dependencies
- Review project-specific technical documentation

### 4. Context File Creation/Update

**Location varies by structure:**
- Single-Project: `memory-bank/context/`
- Multi-Project: `memory-bank/[project-name]/context/`

#### projectBrief.md Template:
```markdown
# Project Brief: [Project Name]

## Overview
[Comprehensive description of what this project is and does]

## Goals
- **Primary**: [Main objective and purpose]
- **Secondary**: [Supporting objectives]
- **Long-term**: [Future vision]

## Scope
### Included
- [What this project handles]
- [Core responsibilities]

### Excluded  
- [What this project doesn't handle]
- [Boundaries and limitations]

## Success Criteria
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Key performance indicators]

## Constraints
- **Technical**: [Platform, performance, compatibility]
- **Business**: [Budget, timeline, resources]
- **Regulatory**: [Compliance, security requirements]

## Key Stakeholders
- **Users**: [Who uses this system]
- **Maintainers**: [Who develops and maintains]
- **Beneficiaries**: [Who benefits from the system]
```

#### productContext.md Template:
```markdown
# Product Context

## User Needs
### Primary Users
- [User type 1]: [Their needs and goals]
- [User type 2]: [Their needs and goals]

### Problems Solved
- [Key problem 1]: [How it's addressed]
- [Key problem 2]: [How it's addressed]

### Value Proposition
[Why this product matters and what makes it unique]

## Features
### Core Features
1. [Feature 1]: [Description and purpose]
2. [Feature 2]: [Description and purpose]

### Supporting Features
- [Feature]: [Brief description]
- [Feature]: [Brief description]

## User Flows
### [Flow Name]
1. User action
2. System response
3. Outcome

## Business Context
- **Market Position**: [Where this fits in the ecosystem]
- **Competition**: [Alternative solutions]
- **Integration Points**: [What it connects with]
- **Growth Opportunities**: [Future expansion areas]
```

#### systemPatterns.md Template:
```markdown
# System Patterns

## Architecture
- **Pattern**: [e.g., MVC, Microservices, Serverless]
- **Rationale**: [Why this architecture was chosen]
- **Key Components**: [Major architectural pieces]

## Code Organization
```
project/
├── src/           # [Purpose]
│   ├── backend/   # [Purpose]
│   └── frontend/  # [Purpose]
├── tests/         # [Purpose]
└── docs/          # [Purpose]
```

## Coding Conventions
### Naming
- **Files**: [Convention with example]
- **Functions**: [Convention with example]
- **Variables**: [Convention with example]
- **Classes**: [Convention with example]

### Style
- **Indentation**: [Spaces/tabs]
- **Line Length**: [Max characters]
- **Comments**: [When and how]

## Common Patterns
### Error Handling
```[language]
// Pattern example
```

### Data Validation
```[language]
// Pattern example
```

### API Communication
```[language]
// Pattern example
```

## Anti-patterns to Avoid
- **[Anti-pattern]**: [Why to avoid and alternative]
- **[Anti-pattern]**: [Why to avoid and alternative]
```

#### techContext.md Template:
```markdown
# Technical Context

## Technology Stack
### Core
- **Language**: [Language and version]
- **Framework**: [Framework and version]
- **Runtime**: [Runtime environment]

### Frontend (if applicable)
- **Framework**: [e.g., React, Vue]
- **Styling**: [CSS approach]
- **Build Tool**: [Bundler/compiler]

### Backend (if applicable)
- **Framework**: [e.g., Express, Django]
- **Database**: [Type and version]
- **Caching**: [Strategy if any]

## Dependencies
### Production
- [package]: [Purpose]
- [package]: [Purpose]

### Development
- [tool]: [Purpose]
- [tool]: [Purpose]

## Build & Deploy
### Local Development
```bash
# Setup commands
# Run commands
# Test commands
```

### Build Process
```bash
# Build commands
# Output description
```

### Deployment
- **Environment**: [Where it runs]
- **Process**: [How it's deployed]
- **Configuration**: [Key settings]

## Technical Considerations
### Performance
- [Consideration and approach]

### Security
- [Consideration and approach]

### Scalability
- [Consideration and approach]

## Technical Debt
### Known Issues
- [Issue]: [Impact and priority]

### Future Improvements
- [Improvement]: [Benefit]
```

### 5. Complexity Assessment

#### Level 1: Quick Fix
- Single file or configuration change
- No architectural impact
- Clear problem and solution
- Minimal testing required
- < 1 hour effort

#### Level 2: Feature/Enhancement
- Multiple files affected
- Within existing architecture
- Some design decisions needed
- Standard testing required
- 1 hour - 1 day effort

#### Level 3: Complex Feature
- Multiple components/systems
- Architectural considerations
- Significant design decisions
- Comprehensive testing needed
- 1+ days effort

### 6. Create/Update Active Files

**Location varies by structure:**
- Single-Project: `memory-bank/active/`
- Multi-Project: `memory-bank/[project-name]/active/`

#### activeContext.md:
```markdown
# Active Context

> Synthesized from context foundation files
> Generated: [timestamp]

## Current Understanding
[Key insights from all context files relevant to current work]

## Relevant Patterns
[Patterns that apply to current task]

## Technical Considerations
[Technical details important for current work]

## Constraints & Guidelines
[What to keep in mind during implementation]
```

#### tasks.md:
```markdown
# Memory Bank Tasks

## Current Assessment
- **Status**: Initialized
- **Complexity Level**: [1-3]
- **Estimated Duration**: [timeframe]
- **Workflow Path**: [VAN → ... → REFLECT]

## Task Description
[What needs to be accomplished]

## Affected Areas
- Components: [List of components]
- Files: [Estimated file count]
- Systems: [Affected systems]

## Task Breakdown
1. [ ] [Specific task]
2. [ ] [Specific task]
[Continue as needed]

## Context Updates Needed
- [ ] projectBrief.md: [If any]
- [ ] productContext.md: [If any]
- [ ] systemPatterns.md: [If any]
- [ ] techContext.md: [If any]

## Next Mode: [IMPLEMENT or PLAN]
```

### 7. Progress Tracking

**Location varies by structure:**
- Single-Project: `.memory-bank/active/progress.md`
- Multi-Project: `.memory-bank/[project-name]/active/progress.md`

Update progress.md:
```markdown
# Progress Log

## [timestamp] - VAN Mode Completed
- Context files: [Created/Updated]
- Complexity assessed: Level [1-3]
- Tasks defined: [count]
- Next mode: [mode]
```

## COMPLETION CHECKLIST

Before exiting VAN mode, verify:

```
✅ CONTEXT FOUNDATION
□ projectBrief.md exists and is current
□ productContext.md captures user/business needs
□ systemPatterns.md documents conventions
□ techContext.md has technical details

✅ ACTIVE WORK
□ activeContext.md synthesizes relevant context
□ tasks.md has clear task breakdown
□ progress.md updated with VAN completion

✅ ASSESSMENT
□ Complexity level determined (1-3)
□ Workflow path identified
□ Duration estimated
□ Next mode recommended
```

## MULTI-PROJECT WORKFLOW

### Active Task Detection
When entering VAN mode in a multi-project repository:

1. **Scan all projects**: Check every project's `active/tasks.md`
2. **Identify active work**: Look for tasks with status `in_progress` or `pending`
3. **Present options**: Show user all active tasks across projects
4. **Wait for selection**: Let user choose to continue existing or start new

### Project Selection Flow
```
User: @VAN

Claude: I've detected this is a multi-project repository with:
- api-service (has active Level 2 task in IMPLEMENT mode)
- web-app (no active tasks)
- mobile-app (has active Level 3 task in PLAN mode)

Active tasks found:
1. api-service: "Add rate limiting middleware" (Level 2, in IMPLEMENT)
2. mobile-app: "Implement offline synchronization" (Level 3, in PLAN)

Would you like to:
1. Continue the API service task
2. Continue the mobile app task
3. Start a new task
```

### Context Isolation
In multi-project repositories:
- Each project maintains its own context files
- Shared patterns are read from `shared/` directory
- Project selection determines which context to load
- Context synthesis focuses on selected project

## MODE TRANSITION

Based on complexity assessment:

- **Level 1** → Proceed to **@IMPLEMENT**
   - Context is sufficient for direct implementation
   - No significant design decisions needed

- **Level 2-3** → Proceed to **@PLAN**
   - Need detailed implementation strategy
   - Design decisions required (Level 3)

## EXAMPLE OUTPUT

### Single-Project Example:
```
VAN MODE COMPLETE ✅

**Project**: Pipeline Viewer
**Complexity**: Level 2 (Feature Enhancement)
**Duration**: 4-6 hours

**Context Files**:
- ✅ Created all four foundation files
- ✅ Identified Forge serverless architecture
- ✅ Documented React/TypeScript patterns
- ✅ Captured pipeline monitoring purpose

**Assessment**: 
Adding new feature to existing architecture. Requires planning for integration points but no major design decisions.

**Next Mode**: @PLAN
- Create detailed implementation strategy
- Identify integration points
- Plan testing approach
```

### Multi-Project Example:
```
VAN MODE COMPLETE ✅

**Repository Type**: Multi-Project
**Selected Project**: api-service
**Task**: Continue "Add rate limiting middleware"
**Complexity**: Level 2 (already assessed)
**Status**: Resuming from IMPLEMENT mode

**Context Loaded**:
- ✅ Read shared/patterns.md for common conventions
- ✅ Loaded api-service context files
- ✅ Reviewed active task progress
- ✅ Synthesized activeContext.md for current work

**Progress Summary**:
- Rate limiting interface defined
- Basic middleware structure created
- TODO: Implement token bucket algorithm
- TODO: Add configuration options
- TODO: Write tests

**Next Action**: Continue in @IMPLEMENT mode
```

---

**Hybrid System Focus**: Context-driven development with streamlined workflow