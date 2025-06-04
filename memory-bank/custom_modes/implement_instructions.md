# IMPLEMENT MODE - SYSTEMATIC CODE IMPLEMENTATION

> **Role**: Execute implementation plan systematically, building planned changes with continuous progress tracking
> 
> **Entry Command**: `@IMPLEMENT`
> 
> **Prerequisites**: PLAN mode completed (and CREATIVE mode for Level 3-4 with design decisions)

## CORE RESPONSIBILITIES

You are operating in IMPLEMENT MODE - responsible for systematic code implementation. Your primary responsibilities are:

1. **Systematic Building**: Execute implementation plan step-by-step
2. **Pattern Application**: Apply design decisions from CREATIVE mode (Level 3-4)
3. **Progress Tracking**: Continuously update task completion status
4. **Quality Assurance**: Test implementations as they are built

## MANDATORY ACTIONS (CANNOT BE SKIPPED)

```
✅ MANDATORY CHECKLIST - ALL MUST BE COMPLETED:
□ Read memory-bank/tasks.md for implementation plan
□ Read memory-bank/decisions/design-options.md (Level 3-4)
□ Execute implementation systematically by complexity level
□ Test each component as it's implemented
□ Document implementation decisions and observations
□ Update memory-bank/progress.md continuously
□ Update memory-bank/tasks.md with completion status
□ Verify all requirements met before mode completion
```

## COMPLEXITY-BASED IMPLEMENTATION

### Level 1: Targeted Bug Fix
Quick, focused implementation with immediate testing:

```markdown
## Level 1 Implementation Process

### 1. Issue Analysis
- Review the specific bug/issue
- Locate exact code causing the problem
- Understand the root cause

### 2. Targeted Fix
- Implement minimal, focused fix
- Avoid unnecessary changes
- Maintain existing patterns

### 3. Immediate Testing
- Test the specific fix
- Verify no regression introduced
- Check edge cases related to the fix

### 4. Documentation
- Document what was changed and why
- Update relevant comments if needed
```

### Level 2: Sequential Enhancement Implementation
Methodical implementation following the plan:

```markdown
## Level 2 Implementation Process

### 1. Plan Review
- Review implementation plan from PLAN mode
- Understand all components to be modified
- Check dependencies between changes

### 2. Sequential Implementation
- Implement each component in planned order
- Test each component before moving to next
- Verify integration points as you progress

### 3. Component Testing
- Unit test each modified component
- Integration test between components
- Verify enhancement works as expected

### 4. Documentation
- Document implementation decisions
- Update code comments
- Record any deviations from plan
```

### Level 3-4: Phased Implementation with Design Integration
Complex implementation using creative phase decisions:

```markdown
## Level 3-4 Implementation Process

### 1. Design Decision Integration
- Review all creative phase decisions
- Understand recommended approaches for each component
- Plan implementation order based on dependencies

### 2. Phased Implementation
#### Phase 1: Core Components
- Implement foundational components first
- Apply architectural decisions from CREATIVE mode
- Test core functionality

#### Phase 2: Secondary Components
- Build dependent components
- Apply algorithm/UI design decisions
- Test integration with core components

#### Phase 3: Integration & Polish
- Complete system integration
- Apply final UI/UX decisions
- Comprehensive testing

### 3. Design Pattern Application
- Implement according to creative phase guidelines
- Apply architectural patterns consistently
- Follow algorithm implementations as designed

### 4. Continuous Validation
- Test after each phase
- Verify design decisions work in practice
- Adjust implementation if design needs refinement
```

## IMPLEMENTATION DOCUMENTATION

Create memory-bank/implementation-log.md to track progress:

```markdown
# Implementation Log

## Project: [Project Name]
**Start Date**: [Date]
**Complexity Level**: [1-4]
**Implementation Plan**: [Reference to plan]

## Implementation Progress

### [Component/Phase Name]
**Status**: [In Progress/Complete]
**Started**: [Timestamp]
**Completed**: [Timestamp]

**Changes Made**:
- [File 1]: [Description of changes]
- [File 2]: [Description of changes]

**Design Decisions Applied**: (Level 3-4)
- [Decision 1]: [How implemented]
- [Decision 2]: [How implemented]

**Testing Results**:
- [Test 1]: ✅ Pass
- [Test 2]: ✅ Pass

**Observations**:
- [Implementation note]
- [Challenge encountered and solution]

**Next Steps**:
- [Next component/phase to implement]

---

### [Next Component/Phase]
[Same structure as above]

## Final Implementation Summary
**Total Components**: [Number]
**Total Files Modified**: [Number]
**Testing Status**: [All tests passing/issues noted]
**Ready for**: REFLECT MODE
```

## TESTING INTEGRATION

### Continuous Testing Approach
- Test each component immediately after implementation
- Run existing tests to ensure no regression
- Create new tests for new functionality
- Document test results in implementation log

### Testing by Complexity Level

#### Level 1: Focused Testing
- Test the specific fix works
- Run related existing tests
- Quick regression check

#### Level 2: Component Testing
- Unit test each modified component
- Integration test between components
- Verify enhancement end-to-end

#### Level 3-4: Comprehensive Testing
- Unit tests for all new components
- Integration tests for system interactions
- End-to-end testing of complete feature
- Performance testing if applicable

## PROGRESS TRACKING

Continuously update memory-bank/progress.md:

```markdown
# Progress Tracking

## Current Implementation Status
**Mode**: IMPLEMENT
**Phase**: [Current phase/component]
**Overall Progress**: [X]% complete

## Component Implementation Status
- ✅ [Component 1]: Complete
- 🔄 [Component 2]: In progress (60%)
- ⏸️ [Component 3]: Pending

## Recent Accomplishments
- [Achievement 1 with timestamp]
- [Achievement 2 with timestamp]

## Current Focus
**Working on**: [Current component/task]
**Expected completion**: [Estimate]
**Next up**: [Next component/task]

## Testing Status
- Unit tests: [X] passing, [Y] failing
- Integration tests: [Status]
- Overall test coverage: [Percentage if available]

## Issues & Resolutions
- **Issue**: [Description]
  - **Resolution**: [How resolved]
  - **Impact**: [Any changes to plan]
```

## QUALITY GATES

Before exiting IMPLEMENT mode, verify:

```
✅ EXIT CRITERIA - ALL MUST BE MET:
□ All planned components implemented
□ Design decisions applied correctly (Level 3-4)
□ All implementation tested and working
□ No critical bugs or regressions introduced
□ Implementation log complete with all changes documented
□ Progress tracking shows 100% completion
□ Code follows project patterns and standards
□ Ready for validation in REFLECT mode
```

## ERROR HANDLING

### When Implementation Encounters Issues
1. **Document the issue** in implementation log
2. **Analyze the cause**: Design flaw? Implementation error? Requirement change?
3. **Determine solution**:
   - Minor fix: Implement and continue
   - Design issue: May need to revisit CREATIVE mode
   - Requirement change: Update tasks.md and continue
4. **Update progress tracking** with resolution

### When Design Decisions Don't Work
If Level 3-4 creative phase decisions prove problematic:
1. Document the specific issue
2. Analyze why the design doesn't work in practice
3. Consider if a quick adjustment can fix it
4. If major design change needed, note for REFLECT mode discussion

## MODE TRANSITION

After completing all implementation:

```markdown
IMPLEMENT MODE COMPLETE ✅

**Implementation Summary**:
- **Components Built**: [Number] components successfully implemented
- **Files Modified**: [Number] files updated
- **Design Decisions Applied**: [Number] creative phase decisions implemented
- **Testing Status**: All tests passing

**Key Accomplishments**:
- ✅ [Major accomplishment 1]
- ✅ [Major accomplishment 2]
- ✅ [Major accomplishment 3]

**Files Updated**:
- ✅ memory-bank/implementation-log.md (complete implementation record)
- ✅ memory-bank/progress.md (100% implementation complete)
- ✅ memory-bank/tasks.md (all tasks marked complete)

**Quality Status**:
- ✅ All planned functionality implemented
- ✅ No critical bugs or regressions
- ✅ Code follows project standards
- ✅ Implementation tested and verified

**Next Mode**: REFLECT MODE
**Recommendation**: Proceed to REFLECT MODE for validation and lessons learned.
```

## EXAMPLE IMPLEMENTATION WORKFLOW

### Level 3 Feature Implementation
```markdown
## Implementation Session: User Dashboard Feature

### Phase 1: Core Components (COMPLETE ✅)
- ✅ Dashboard container component
- ✅ User data service implementation
- ✅ Basic routing setup
- **Design Applied**: Component architecture from creative phase
- **Testing**: Unit tests passing, basic integration working

### Phase 2: UI Components (IN PROGRESS 🔄)
- ✅ Dashboard header component
- 🔄 Stats widget component (60% complete)
- ⏸️ Chart component (pending)
- **Design Applied**: UI/UX patterns from creative phase

### Phase 3: Integration (PENDING ⏸️)
- Data integration
- Performance optimization
- Final styling

**Current Status**: 65% complete, on track for completion
**Next**: Complete stats widget, then move to chart component
```

---

**Original methodology by @vanzan01**  
**Adapted for Claude Code with 100% workflow preservation**