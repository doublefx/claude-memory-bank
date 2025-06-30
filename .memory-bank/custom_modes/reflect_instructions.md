# REFLECT MODE - VALIDATE & LEARN (HYBRID)

> **Version**: 2.1.0
> **Role**: Ensure quality and capture learnings for context evolution
>
> **Entry Command**: `@REFLECT`
>
> **Prerequisites**: IMPLEMENT mode completed

## CORE RESPONSIBILITIES

You are operating in REFLECT MODE - where implementation meets validation. Your responsibilities are:

1. **Quality Validation**: Verify implementation meets requirements
2. **Test Comprehensive**: Run full test suite
3. **Context Updates**: Update context files with learnings
4. **Pattern Capture**: Document new patterns discovered
5. **Success Documentation**: Record what worked well
6. **Improvement Areas**: Identify future enhancements

## PRE-FLIGHT VALIDATION (STEP 0 - MANDATORY)

### 0. Pre-flight Implementation Validation (MANDATORY - CANNOT SKIP)

```
⚠️ STOP! Before proceeding with ANY reflection, you MUST complete this validation:

1. Check .memory-bank/active/progress.md exists
2. Verify progress.md shows:
   - IMPLEMENT mode was entered
   - Implementation tasks were logged
   - No critical errors blocking reflection
3. Check .memory-bank/active/tasks.md for task status
4. Verify temp-files.md exists (if temporary files were created)
5. Confirm code changes were actually made:
   - Review git status or file modifications
   - Ensure implementation matches task requirements
6. If implementation NOT complete:
   - STOP immediately
   - Return to @IMPLEMENT mode to complete work
   - DO NOT proceed with reflection

⛔ BREAKING: Reflecting without implementation corrupts quality assurance
```

### 1. Reflection Mode Declaration (MANDATORY)

After pre-flight validation, you MUST output this EXACT format:

```yaml
REFLECT_MODE_VERIFICATION:
  timestamp: [ISO-8601 timestamp]
  implement_mode_completed: [true/false]
  progress_md_status:
    shows_implementation: [true/false]
    last_mode: [IMPLEMENT/other]
    tasks_completed: [count]
  temp_files_status:
    temp_files_md_exists: [true/false]
    entries_count: [number]
    cleanup_required: [true/false]
  code_changes_detected: [true/false]
  test_environment:
    test_command_available: [true/false]
    previous_test_results: [found/not_found]
  validation_result: [PROCEED/ABORT]
  reason: "[specific evidence for decision]"

PROCEEDING WITH REFLECTION / ABORTING - RETURNING TO IMPLEMENT MODE
```

**DO NOT CONTINUE** without this verification output.

## INPUTS TO READ

After successful pre-flight validation, review based on repository structure:

### Single-Project Repository:
1. **memory-bank/active/tasks.md** - Original requirements and plan
2. **memory-bank/active/progress.md** - Implementation journey
3. **memory-bank/context/** - All context files for updates
4. **memory-bank/decisions/log.md** - Validate design choices
5. **Code changes** - Review implementation quality

### Multi-Project Repository:
1. **memory-bank/[project-name]/active/tasks.md** - Project requirements
2. **memory-bank/[project-name]/active/progress.md** - Implementation journey
3. **memory-bank/[project-name]/context/** - Project context files
4. **memory-bank/shared/** - Check if updates benefit all projects
5. **memory-bank/[project-name]/decisions/log.md** - Design validation
6. **Code changes** - Review implementation in project directory

## REFLECTION PROCESS

### 0. Complete Pre-flight Validation (MANDATORY FIRST STEP)
- Execute all pre-flight checks as specified above
- Output REFLECT_MODE_VERIFICATION yaml
- Abort if validation fails

### 1. Requirements Validation

Verify against original requirements:

```markdown
## Requirements Validation

### Functional Requirements
- ✅ [Requirement]: [How validated]
- ✅ [Requirement]: [Test result]
- ⚠️ [Requirement]: [Partial - explanation]

### Non-Functional Requirements
- Performance: [Metric vs target]
- Security: [Validation method]
- Usability: [Assessment]

### Success Criteria
- [Criteria 1]: ✅ Met
- [Criteria 2]: ✅ Exceeded
```

### 2. Test Execution

Run comprehensive tests:

```bash
# Run all tests
npm test

# Run specific test suites
npm run test:unit
npm run test:integration

# Check coverage
npm run test:coverage
```

Document results:
```markdown
## Test Results
- Unit Tests: X/Y passing
- Integration Tests: X/Y passing
- Coverage: X%
- Performance: [metrics]
```

### 3. Context File Updates

Review context files based on repository structure:

#### Single-Project Updates:
Update files in `memory-bank/context/`:
- **systemPatterns.md**: New patterns, validations, anti-patterns
- **techContext.md**: Dependencies, technical debt, performance
- **productContext.md**: User needs, feature impact, use cases
- **projectBrief.md**: Scope, constraints, goal alignment

#### Multi-Project Updates:
Consider both project and shared updates:

**Project-Specific** (`memory-bank/[project-name]/context/`):
- Patterns unique to this project
- Project-specific technical details
- Project user needs and features
- Project scope and constraints

**Shared Updates** (`memory-bank/shared/`):
- Patterns beneficial across projects
- Common conventions discovered
- Cross-project architecture insights
- Reusable components or utilities

**Decision Criteria for Shared**:
- Used by 2+ projects? → shared/
- Solves common problem? → shared/
- Improves consistency? → shared/
- Project-specific only? → project/context/

### 4. Learning Documentation

**File Location:**
- Single-Project: `memory-bank/qa/validation-results.md`
- Multi-Project: `memory-bank/[project-name]/qa/validation-results.md`

Create/update validation results:

```markdown
# Validation Results

## Summary
- **Feature**: [Name]
- **Date**: [Date]
- **Result**: ✅ Success / ⚠️ Success with notes

## What Worked Well
### Process
- [Success]: [Why it worked]

### Technical
- [Pattern]: [Effectiveness]

### Design
- [Decision]: [Outcome]

## Areas for Improvement
### Challenges Faced
- [Challenge]: [Resolution]

### Lessons Learned
- [Insight]: [Application]

### Future Recommendations
- [Recommendation]: [Benefit]

## Context Updates Made
- systemPatterns.md: [What was added]
- techContext.md: [What was updated]
```

### 5. Quality Assessment

Evaluate code quality:

```
✅ CODE QUALITY CHECK
- Follows established patterns
- Maintains consistency
- Proper error handling
- Adequate documentation
- No code smells

✅ ARCHITECTURE CHECK
- Aligns with system design
- Scalable approach
- Maintainable structure
- Clear separation of concerns
- Reusable components
```

### 6. Archive Decision

Determine if archiving needed:

- **Level 1**: Usually no archive needed
- **Level 2**: Archive if significant learnings
- **Level 3**: Always archive for knowledge preservation

## OUTPUTS TO CREATE/UPDATE

### Single-Project:
1. **memory-bank/qa/validation-results.md** - Test results and learnings
2. **memory-bank/context/** - Updates based on discoveries
3. **memory-bank/active/progress.md** - Mark REFLECT complete
4. **memory-bank/decisions/log.md** - New architectural insights

### Multi-Project:
1. **memory-bank/[project-name]/qa/validation-results.md** - Project results
2. **memory-bank/[project-name]/context/** - Project-specific updates
3. **memory-bank/shared/** - Cross-project patterns and conventions
4. **memory-bank/[project-name]/active/progress.md** - Mark complete
5. **memory-bank/[project-name]/decisions/log.md** - Project decisions

**Important**: Always evaluate if learnings should be promoted to shared/

## 🚨 MANDATORY ACTIONS - DO NOT SKIP

Before exiting REFLECT mode, you MUST complete ALL of these:

```
⛔ CRITICAL: Skipping ANY of these steps will lose valuable learnings and leave artifacts
```

### Required Actions:

1. **Create/update validation-results.md** ✅ MANDATORY:
   - Complete test results summary with metrics
   - Document what worked well (be specific)
   - Detail challenges encountered and resolutions
   - Capture lessons learned for future work
   - Include performance metrics if relevant
  
2. **Update ALL relevant context files** ✅ MANDATORY:
   - systemPatterns.md: Add new patterns discovered
   - techContext.md: Document technical insights
   - productContext.md: Note user impact insights
   - projectBrief.md: Update if scope changed
   
3. **Clean ALL temporary files** ✅ MANDATORY:
   - Open temp-files.md and review EVERY entry
   - Delete all temporary test directories
   - Remove any backup files no longer needed
   - Clean up test data files
   - Remove debug logs
  
4. **Update temp-files.md** ✅ MANDATORY:
   - Remove entries for ALL cleaned files
   - Verify table is empty or only permanent items remain
   - Add cleanup timestamp
   - If files remain, document why they're kept
  
5. **Update task status in tasks.md** ✅ MANDATORY:
   - Change status to "completed"
   - Add completion date and time
   - Note final complexity level
   - List any follow-up tasks identified
   - Record total time spent

6. **Final progress.md update** ✅ MANDATORY:
   - Log REFLECT mode completion
   - Summarize key achievements
   - Note any technical debt created
   - Record performance improvements

```
⚠️ FAILURE TO COMPLETE ALL STEPS = CRITICAL WORKFLOW VIOLATION
⛔ Knowledge will be PERMANENTLY LOST without proper documentation
🚫 Temporary files left behind will accumulate and cause issues
❌ DO NOT exit REFLECT mode until ALL mandatory actions are verified complete
```

## COMPLETION CHECKLIST

Before declaring REFLECT mode complete, verify EVERY item:

```
✅ PRE-FLIGHT VALIDATION
- REFLECT_MODE_VERIFICATION yaml output complete
- Implementation confirmed via progress.md
- Code changes verified

✅ VALIDATION COMPLETE
- All requirements verified against tasks.md
- Tests executed and passing
- Quality standards met
- Performance metrics recorded
- Security validated if applicable

✅ LEARNINGS CAPTURED
- validation-results.md created/updated
- Successes documented with specifics
- Challenges recorded with resolutions
- New patterns identified and documented
- Improvements noted for future work
- Recommendations made and recorded

✅ CONTEXT UPDATED
- systemPatterns.md: New patterns added
- techContext.md: Technical insights captured
- productContext.md: User impact refined
- projectBrief.md: Constraints updated if needed
- decisions/log.md: Validation outcomes recorded

✅ CLEANUP COMPLETE
- temp-files.md reviewed line by line
- ALL temporary files deleted
- temp-files.md cleared of removed entries
- No artifacts left behind

✅ TASK FINALIZATION
- tasks.md: Status = "completed"
- tasks.md: Completion date added
- progress.md: Final update logged
- Follow-up tasks documented if any
```

⛔ DO NOT exit until ALL checkboxes can be marked complete!

## MODE TRANSITION

After REFLECT completion:

**For Level 1-2**:
→ Workflow Complete
- All validated
- Context updated
- Ready for next task

**For Level 3**:
→ Consider Archive
- Significant learnings
- Reusable patterns
- Knowledge preservation value

## EXAMPLE OUTPUTS

### Single-Project Example:
```
REFLECT MODE COMPLETE ✅

**Feature**: Pipeline Filtering
**Quality**: ⭐⭐⭐⭐⭐ All requirements met

**Validation Results**:
- Functional: ✅ All features working
- Performance: ✅ <100ms response time
- Tests: ✅ 95% coverage, all passing
- Security: ✅ No vulnerabilities

**Key Learnings**:
1. Atlaskit Select pattern works well for filters
2. Forge storage optimistic updates improve UX
3. Virtual scrolling necessary for large datasets

**Context Updates**:
- systemPatterns.md: Added filter component pattern
- techContext.md: Documented Forge storage limits

**Recommendation**: 
Level 2 task complete. Context enriched for future work.
```

### Multi-Project Example:
```
REFLECT MODE COMPLETE ✅

**Repository**: Multi-Project (E-commerce Platform)
**Project**: api-service
**Feature**: Rate Limiting Middleware
**Quality**: ⭐⭐⭐⭐⭐ Exceeds requirements

**Validation Results**:
- Functional: ✅ All endpoints properly limited
- Performance: ✅ <5ms overhead per request
- Tests: ✅ 98% coverage, all passing
- Load Testing: ✅ Handles 10k req/sec
- Cross-Project: ✅ Headers work with web/mobile

**Key Learnings**:
1. Token bucket superior for API rate limiting
2. Redis Lua scripts ensure atomicity
3. Rate limit headers critical for client UX
4. Pattern reusable across all API services

**Context Updates**:
- api-service/systemPatterns.md: Added middleware pattern
- api-service/techContext.md: Redis performance metrics
- shared/patterns.md: ✅ Added rate limiting pattern
- shared/types.d.ts: ✅ Added RateLimitInfo interface

**Cross-Project Benefits**:
- Pattern now available for auth-service
- Web-app updated to handle rate limit headers
- Mobile-app implements exponential backoff

**Recommendation**: 
Level 2 complete. Rate limiting pattern promoted to shared for repository-wide benefit.
```

---

**Purpose**: Validate quality, capture learnings, evolve context for continuous improvement