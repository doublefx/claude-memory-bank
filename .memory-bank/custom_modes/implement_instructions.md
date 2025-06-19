# PLAN MODE - STRATEGY & DESIGN (HYBRID)

> **Role**: Create context-informed implementation strategy with integrated design exploration
>
> **Entry Command**: `@PLAN`
>
> **Prerequisites**: VAN completed, Level 2+ complexity

## CORE RESPONSIBILITIES

You are operating in PLAN MODE - where context meets strategy. Your responsibilities are:

1. **Context Integration**: Leverage all context files for informed planning
2. **Strategy Development**: Create detailed implementation approach
3. **Design Exploration**: For Level 3 tasks, explore design options
4. **Risk Assessment**: Identify challenges and mitigation strategies
5. **Task Detailing**: Expand tasks.md with implementation plan
6. **Decision Documentation**: Record all design decisions

## INPUTS TO READ

Before planning, read these files based on repository structure:

### Single-Project Repository:
1. **.memory-bank/context/projectBrief.md** - Understand goals and constraints
2. **.memory-bank/context/productContext.md** - Know user needs and features
3. **.memory-bank/context/systemPatterns.md** - Follow established patterns
4. **.memory-bank/context/techContext.md** - Use appropriate technology
5. **.memory-bank/active/activeContext.md** - Current synthesized context
6. **.memory-bank/active/tasks.md** - Task breakdown from VAN

### Multi-Project Repository:
1. **.memory-bank/shared/** - Read all shared patterns and conventions first
2. **.memory-bank/[project-name]/context/projectBrief.md** - Project-specific goals
3. **.memory-bank/[project-name]/context/productContext.md** - Project user needs
4. **.memory-bank/[project-name]/context/systemPatterns.md** - Project patterns
5. **.memory-bank/[project-name]/context/techContext.md** - Project technology
6. **.memory-bank/[project-name]/active/activeContext.md** - Current context
7. **.memory-bank/[project-name]/active/tasks.md** - Task breakdown

## PLANNING PROCESS

### 1. Context Analysis

#### For Single-Project:
Review all context files and identify:
- Relevant patterns to follow
- Technical constraints to respect
- User needs to fulfill
- Business goals to achieve

#### For Multi-Project:
Review context with additional considerations:
- **Shared patterns** from `shared/` take precedence
- **Cross-project dependencies** and interactions
- **Project-specific patterns** that don't conflict with shared
- **Integration points** between projects
- **Consistent approaches** across the repository

### 2. Strategy Development

#### For Level 2 (Feature/Enhancement):
```markdown
## Implementation Strategy

### Approach
[High-level approach based on context]

### Components Affected
1. [Component]: [What changes and why]
2. [Component]: [What changes and why]

### Implementation Order
1. [First step]: [Rationale]
2. [Second step]: [Rationale]
[Continue...]

### Integration Points
- [System/Component]: [How to integrate]
- [System/Component]: [How to integrate]

### Testing Strategy
- Unit tests: [What to test]
- Integration tests: [What to test]
- Manual testing: [What to verify]
```

#### For Level 3 (Complex Feature):
Include design exploration for each component needing decisions:

```markdown
## Design Exploration: [Component Name]

### Option 1: [Approach Name]
**Description**: [What this approach entails]

**Pros**:
- [Advantage based on context]
- [Advantage based on patterns]

**Cons**:
- [Disadvantage considering constraints]
- [Disadvantage considering tech debt]

**Context Alignment**:
- systemPatterns.md: [How it aligns]
- techContext.md: [Technical fit]
- productContext.md: [User impact]

### Option 2: [Approach Name]
[Same structure as Option 1]

### Option 3: [Approach Name]
[Same structure as Option 1]

### Recommendation: Option [X]
**Rationale**: [Why this option best serves the context]

**Implementation Guidelines**:
- [Specific guideline from context]
- [Pattern to follow]
- [Technical consideration]
```

### 3. Risk Assessment

Identify risks based on context:

```markdown
## Risk Assessment

### Technical Risks
- **Risk**: [From techContext.md]
  - **Impact**: [Severity]
  - **Mitigation**: [Strategy]

### Pattern Risks
- **Risk**: [From systemPatterns.md]
  - **Impact**: [Severity]
  - **Mitigation**: [Strategy]

### Business Risks
- **Risk**: [From productContext.md]
  - **Impact**: [Severity]
  - **Mitigation**: [Strategy]
```

### 4. Update tasks.md

Expand the task list with implementation details:

```markdown
## Detailed Task Breakdown

### Phase 1: [Phase Name]
1. [ ] [Specific task with context reference]
   - Pattern: [From systemPatterns.md]
   - Location: [File/component]
   - Validation: [How to verify]

2. [ ] [Specific task]
   [Continue...]

### Phase 2: [Phase Name]
[Continue with phases]

## Definition of Done
- [ ] All tasks completed
- [ ] Tests passing
- [ ] Patterns followed
- [ ] Context files updated if needed
```

### 5. Decision Documentation

**File Location:**
- Single-Project: `memory-bank/decisions/log.md`
- Multi-Project: `memory-bank/[project-name]/decisions/log.md`

Create/update the decision log:

```markdown
# Design Decisions Log

## [Date] - [Feature/Component]

### Context
- Requirement: [From productContext.md]
- Constraint: [From projectBrief.md]
- Pattern: [From systemPatterns.md]

### Decision
[What was decided]

### Rationale
[Why this decision, referencing context]

### Alternatives Considered
1. [Alternative]: [Why not chosen]
2. [Alternative]: [Why not chosen]

### Consequences
- Positive: [Benefits]
- Negative: [Trade-offs]
- Future: [Long-term impact]
```

### 6. Update activeContext.md

Add planning insights:

```markdown
## Planning Insights

### Chosen Approach
[Summary of strategy]

### Key Decisions
1. [Decision]: [Impact]
2. [Decision]: [Impact]

### Watch Points
- [Area to monitor during implementation]
- [Potential issue to track]

### Success Criteria
- [Specific measurable outcome]
- [Quality metric]
```

## OUTPUTS TO CREATE/UPDATE

### Single-Project:
1. **memory-bank/active/tasks.md** - Detailed implementation plan
2. **memory-bank/decisions/log.md** - All design decisions
3. **memory-bank/active/activeContext.md** - Planning insights
4. **memory-bank/active/progress.md** - PLAN completion

### Multi-Project:
1. **memory-bank/[project-name]/active/tasks.md** - Detailed implementation plan
2. **memory-bank/[project-name]/decisions/log.md** - All design decisions
3. **memory-bank/[project-name]/active/activeContext.md** - Planning insights
4. **memory-bank/[project-name]/active/progress.md** - PLAN completion

**Note**: In multi-project repos, if a pattern or convention could benefit other projects, consider proposing it for inclusion in `memory-bank/shared/`

## COMPLETION CHECKLIST

```
✅ STRATEGY COMPLETE
□ All context files reviewed and integrated
□ Implementation strategy documented
□ Design decisions made (Level 3)
□ Risks identified and mitigations planned

✅ DOCUMENTATION UPDATED
□ tasks.md has detailed implementation plan
□ design-log.md captures all decisions
□ activeContext.md includes planning insights
□ progress.md shows PLAN completion

✅ READY FOR IMPLEMENTATION
□ Clear task sequence defined
□ Patterns and conventions identified
□ Testing approach specified
□ Success criteria established
```

## MODE TRANSITION

After PLAN completion:

→ Proceed to **@IMPLEMENT**
- Strategy is clear
- Decisions are documented
- Context is integrated
- Ready to build

## EXAMPLE OUTPUTS

### Single-Project Example:
```
PLAN MODE COMPLETE ✅

**Feature**: Add Pipeline Filtering
**Complexity**: Level 2
**Strategy**: Extend existing UI with context-aware filtering

**Key Decisions**:
1. Use existing Atlaskit Select component (follows systemPatterns.md)
2. Implement filtering in frontend only (respects techContext.md constraints)
3. Store preferences in Forge storage (aligns with platform patterns)

**Risks Identified**:
- Performance with large datasets (Mitigation: Virtual scrolling)
- State management complexity (Mitigation: Use established patterns)

**Implementation Phases**:
1. UI Component (2 hours)
2. State Management (1 hour)
3. Persistence Layer (1 hour)
4. Testing (1 hour)

**Next Mode**: @IMPLEMENT
Ready to build with clear context-driven plan
```

### Multi-Project Example:
```
PLAN MODE COMPLETE ✅

**Repository**: Multi-Project (E-commerce Platform)
**Project**: api-service
**Feature**: Add Rate Limiting Middleware
**Complexity**: Level 2
**Strategy**: Implement token bucket algorithm following shared patterns

**Context Integration**:
- Following shared/patterns.md rate limiting interface
- Using api-service specific Redis configuration
- Aligning with shared/conventions.md for middleware structure

**Key Decisions**:
1. Token bucket over sliding window (better for burst traffic)
2. Redis for distributed state (follows shared infrastructure)
3. Configurable per-endpoint limits (api-service requirement)

**Cross-Project Considerations**:
- Web-app will need rate limit headers for UI feedback
- Mobile-app should implement exponential backoff
- Shared pattern documented for other services

**Implementation Phases**:
1. Core algorithm implementation (2 hours)
2. Redis integration (1 hour)
3. Configuration system (1 hour)
4. Cross-project integration docs (30 min)

**Next Mode**: @IMPLEMENT
Ready to build with repository-wide consistency
```

---

**Integration Note**: PLAN mode now incorporates CREATIVE mode functionality for Level 3 complexity, maintaining design exploration within the planning phase for a streamlined workflow.