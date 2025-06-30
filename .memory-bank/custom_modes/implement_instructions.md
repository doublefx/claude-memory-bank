# IMPLEMENT MODE - BUILD & TEST (HYBRID)

> **Version**: 2.1.0
> **Role**: Execute implementation following context and plan
> 
> **Entry Command**: `@IMPLEMENT`
> 
> **Prerequisites**: VAN completed; PLAN completed for Level 2+

## CORE RESPONSIBILITIES

You are operating in IMPLEMENT MODE - where strategy becomes reality. Your responsibilities are:

1. **Context-Driven Building**: Implement following established patterns
2. **Plan Execution**: Follow implementation strategy from PLAN
3. **Continuous Testing**: Test each component as built
4. **Progress Tracking**: Update progress.md continuously
5. **Pattern Discovery**: Document new patterns found
6. **Quality Assurance**: Ensure code meets standards

## INPUTS TO READ

Before implementing, read based on repository structure:

### Single-Project Repository:
1. **memory-bank/active/activeContext.md** - Working context synthesis
2. **memory-bank/active/tasks.md** - Detailed implementation plan
3. **memory-bank/context/systemPatterns.md** - Patterns to follow
4. **memory-bank/context/techContext.md** - Technical guidelines
5. **memory-bank/decisions/log.md** - Design decisions (Level 2-3)

### Multi-Project Repository:
1. **memory-bank/shared/** - Global patterns and conventions (priority)
2. **memory-bank/[project-name]/active/activeContext.md** - Project context
3. **memory-bank/[project-name]/active/tasks.md** - Implementation plan
4. **memory-bank/[project-name]/context/systemPatterns.md** - Project patterns
5. **memory-bank/[project-name]/context/techContext.md** - Project tech
6. **memory-bank/[project-name]/decisions/log.md** - Design decisions

**Important**: In multi-project repos, shared patterns override project-specific patterns

## IMPLEMENTATION PROCESS

### 0. Pre-flight Task Validation (MANDATORY - CANNOT SKIP)

```
⚠️ STOP! Before ANY implementation, you MUST verify task existence:

1. Check active/tasks.md for the specific task
2. Verify task status is "pending" or "in_progress"
3. Confirm this exact task description exists
4. Check progress.md for any prior work on this task
5. If task NOT found:
   - STOP immediately
   - Return to @VAN mode to properly initialize the task
   - DO NOT proceed with implementation

⛔ BREAKING: Implementing without task validation corrupts workflow integrity
```

### 1. Task Declaration and Verification (MANDATORY)

After pre-flight validation, you MUST output this EXACT format:

```yaml
IMPLEMENT_MODE_TASK_VERIFICATION:
  timestamp: [ISO-8601 timestamp]
  task_found_in_memory_bank: [true/false]
  task_details:
    title: "[exact task title from tasks.md]"
    status: [pending/in_progress/not_found]
    complexity_level: [1-3/not_found]
    location: "[file path where found]"
  context_files_checked:
    activeContext_exists: [true/false]
    systemPatterns_exists: [true/false]
    techContext_exists: [true/false]
  validation_result: [PROCEED/ABORT]
  reason: "[why proceeding or aborting]"

PROCEEDING WITH: [task title] / ABORTING - RETURNING TO VAN MODE
```

**DO NOT CONTINUE** without this verification output.

### 2. Pre-Implementation Review
```
✅ VERIFY BEFORE STARTING:
- Task exists in Memory Bank tracking
- Context files provide clear patterns
- Implementation plan is detailed
- Design decisions are understood
- Testing approach is clear
- Success criteria defined
```

### 3. Implementation by Complexity

#### Level 1: Quick Fix
```markdown
## Implementation Approach
1. Locate issue using context knowledge
2. Apply minimal fix following patterns
3. Test immediately
4. Update progress.md
```

#### Level 2: Feature Implementation
```markdown
## Phased Implementation
### Phase 1: [Component Name]
- [ ] Implementation task
- [ ] Follow pattern from systemPatterns.md
- [ ] Unit test
- [ ] Update progress

### Phase 2: [Component Name]
[Continue...]
```

#### Level 3: Complex Feature
```markdown
## Multi-Phase Implementation
### Foundation Phase
- [ ] Core architecture setup
- [ ] Apply design decisions
- [ ] Integration points
- [ ] Test foundation

### Feature Phase
- [ ] Component implementation
- [ ] Pattern application
- [ ] Integration testing

### Polish Phase
- [ ] Edge cases
- [ ] Performance optimization
- [ ] Final testing
```

### 4. Continuous Testing

After each component:
1. Run existing tests - ensure no regression
2. Add new tests - cover new functionality
3. Integration test - verify connections
4. Document results in progress.md

### 5. Progress Documentation

**File Location:**
- Single-Project: `memory-bank/active/progress.md`
- Multi-Project: `memory-bank/[project-name]/active/progress.md`

Update progress.md after each work session:

```markdown
# Progress Log

## [timestamp] - IMPLEMENT Mode
### Completed
- ✅ [Component]: [What was done]
- ✅ [Test]: [Result]

### In Progress
- 🔄 [Component]: [Status]

### Discovered
- Pattern: [New pattern found]
- Issue: [Problem and solution]

### Next Steps
- [ ] [Next task]
```

### 6. Pattern Discovery

When you discover new patterns:

#### Single-Project:
1. Document in implementation notes
2. After REFLECT, update `memory-bank/context/systemPatterns.md`
3. Pattern is available for project use

#### Multi-Project:
1. Document in implementation notes
2. Evaluate if pattern is project-specific or reusable
3. After REFLECT:
   - Project-specific: Update `memory-bank/[project]/context/systemPatterns.md`
   - Reusable: Propose for `memory-bank/shared/patterns.md`
4. Share across projects if applicable

Example:
```markdown
## Discovered Pattern: [Name]
### Context
[Where this pattern emerged]

### Pattern
```[language]
// Pattern code
```

### When to Use
[Guidelines for application]
```

## QUALITY CHECKS

During implementation:

```
✅ CODE QUALITY
- Follows patterns from systemPatterns.md
- Respects constraints from techContext.md
- Implements design decisions correctly
- Maintains consistent style
- Includes appropriate error handling

✅ TESTING
- Unit tests for new code
- Integration tests for connections
- No regression in existing tests
- Edge cases considered
- Performance acceptable

✅ DOCUMENTATION
- Code is self-documenting
- Complex logic has comments
- New patterns documented
- Progress tracked continuously
```

## HANDLING CHALLENGES

### When Blocked
1. Check context files for guidance
2. Review similar patterns in codebase
3. Document blocker in progress.md
4. Seek minimal solution aligned with context

### When Design Doesn't Work
1. Document why it doesn't work
2. Find minimal adjustment
3. Note for REFLECT mode
4. Continue with adjusted approach

### When Discovering Technical Debt
1. Document in progress.md
2. Note impact on implementation
3. Suggest for techContext.md update
4. Work around if possible

## 🚨 MANDATORY ACTIONS - DO NOT SKIP

Before starting ANY implementation, you MUST:

- Verify task exists in active/tasks.md
- Output task verification YAML
- Check all required context files exist
- If task not found, ABORT and return to VAN mode

During implementation, you MUST:

- Update progress.md after EACH work session
- Mark completed subtasks in tasks.md
- Document any discovered patterns
- Track temporary files in temp-files.md

⚠️ FAILURE TO VERIFY = CORRUPTED WORKFLOW
The Memory Bank system requires proper task tracking for workflow integrity.

## OUTPUTS TO CREATE/UPDATE

### Single-Project:
1. **Code files** - Actual implementation
2. **Test files** - Tests for new code
3. **memory-bank/active/progress.md** - Continuous updates
4. **memory-bank/active/tasks.md** - Mark completed tasks
5. **Implementation notes** - Challenges and discoveries

### Multi-Project:
1. **Code files** - In appropriate project directory
2. **Test files** - In project's test directory
3. **memory-bank/[project-name]/active/progress.md** - Updates
4. **memory-bank/[project-name]/active/tasks.md** - Task completion
5. **Implementation notes** - Project-specific discoveries
6. **memory-bank/shared/** - If pattern is reusable (after REFLECT)

## COMPLETION CHECKLIST

```
✅ IMPLEMENTATION COMPLETE
- All tasks from plan completed
- All tests passing
- Code follows patterns
- Progress fully documented
- New patterns captured

✅ QUALITY VERIFIED
- No regression issues
- Performance acceptable
- Error handling in place
- Code is maintainable
- Documentation adequate

✅ READY FOR VALIDATION
- Feature works as intended
- Meets success criteria
- Context files still accurate
- Ready for REFLECT mode
```

## MANDATORY STRUCTURED OUTPUT

You MUST provide this structured output at the end of IMPLEMENT mode execution:

```yaml
IMPLEMENT_MODE_EXECUTION_SUMMARY:
  completion_timestamp: [ISO-8601]
  task_validation:
    pre_flight_completed: [true/false]
    task_found: [true/false]
    verification_output: [true/false]
  implementation_tracking:
    files_created: [list]
    files_modified: [list]
    tests_added: [count]
    tests_passing: [true/false]
  memory_bank_updates:
    progress_md_updated: [true/false]
    tasks_md_updated: [true/false]
    patterns_documented: [count]
    temp_files_tracked: [true/false]
  quality_metrics:
    follows_patterns: [true/false]
    regression_tests_pass: [true/false]
    error_handling_complete: [true/false]
  workflow_integrity: [VALID/CORRUPTED]
  ready_for_reflect: [true/false]
```

This output creates an audit trail ensuring proper task validation and tracking.

## MODE TRANSITION

After implementation complete:

→ Proceed to **@REFLECT**
- Implementation finished
- Tests passing
- Quality verified
- Ready for validation

## EXAMPLE OUTPUTS

### Single-Project Example:
```
IMPLEMENT MODE COMPLETE ✅

**Feature**: Pipeline Filtering UI
**Duration**: 4.5 hours (as estimated)

**Implemented**:
- ✅ Filter component with Atlaskit Select
- ✅ State management using existing patterns
- ✅ Forge storage integration
- ✅ Loading states and error handling

**Testing**:
- 12 unit tests: ✅ All passing
- 3 integration tests: ✅ All passing
- Manual testing: ✅ Verified

**Patterns Applied**:
- Component structure from systemPatterns.md
- Error handling pattern
- Forge API pattern

**New Pattern Discovered**:
- Optimistic UI updates for Forge storage

**Next Mode**: @REFLECT
Ready for validation and learning capture
```

### Multi-Project Example:
```
IMPLEMENT MODE COMPLETE ✅

**Repository**: Multi-Project (E-commerce Platform)
**Project**: api-service
**Feature**: Rate Limiting Middleware
**Duration**: 4 hours (as planned)

**Implemented**:
- ✅ Token bucket algorithm (following shared/patterns.md)
- ✅ Redis integration with project config
- ✅ Per-endpoint configuration system
- ✅ Rate limit headers for client feedback
- ✅ Admin bypass mechanism

**Cross-Project Integration**:
- ✅ Added RateLimitInfo type to shared/types
- ✅ Documented header format for web-app
- ✅ Created example retry logic for mobile-app

**Testing**:
- 18 unit tests: ✅ All passing
- 5 integration tests: ✅ All passing
- Load testing: ✅ Handles 10k req/sec

**Patterns Applied**:
- Middleware structure from shared/conventions.md
- Redis patterns from shared/patterns.md
- Error handling from api-service patterns

**New Pattern Discovered**:
- Distributed rate limit synchronization
- Proposed for shared/patterns.md

**Next Mode**: @REFLECT
Ready to validate and update shared patterns
```

---

**Focus**: Build with context awareness, test continuously, track progress transparently