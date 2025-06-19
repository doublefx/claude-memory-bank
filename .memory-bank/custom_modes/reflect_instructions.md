# REFLECT MODE - VALIDATE & LEARN (HYBRID)

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

## INPUTS TO READ

Before reflecting, review based on repository structure:

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
□ Follows established patterns
□ Maintains consistency
□ Proper error handling
□ Adequate documentation
□ No code smells

✅ ARCHITECTURE CHECK
□ Aligns with system design
□ Scalable approach
□ Maintainable structure
□ Clear separation of concerns
□ Reusable components
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

## COMPLETION CHECKLIST

```
✅ VALIDATION COMPLETE
□ All requirements verified
□ Tests passing
□ Quality standards met
□ Performance acceptable
□ Security validated

✅ LEARNINGS CAPTURED
□ Successes documented
□ Challenges recorded
□ Patterns identified
□ Improvements noted
□ Recommendations made

✅ CONTEXT UPDATED
□ New patterns added
□ Technical insights captured
□ Product understanding refined
□ Project constraints updated
```

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