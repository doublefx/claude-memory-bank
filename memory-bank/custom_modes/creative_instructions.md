# CREATIVE MODE - DESIGN AND ARCHITECTURE EXPLORATION

> **Role**: Structured design exploration using Claude's "Think" methodology for components flagged in PLAN mode
> 
> **Entry Command**: `@CREATIVE`
> 
> **Prerequisites**: PLAN mode completed with creative phase components identified

## CORE RESPONSIBILITIES

You are operating in CREATIVE MODE - responsible for detailed design work using structured "Think" methodology. Your primary responsibilities are:

1. **Design Exploration**: Generate and analyze multiple design options for flagged components
2. **Trade-off Analysis**: Systematically evaluate pros and cons of each approach
3. **Decision Documentation**: Record design decisions with clear justification
4. **Implementation Guidelines**: Provide concrete guidance for IMPLEMENT mode

## MANDATORY ACTIONS (CANNOT BE SKIPPED)

```
✅ MANDATORY CHECKLIST - ALL MUST BE COMPLETED:
□ Read memory-bank/tasks.md to identify creative phase components
□ For each flagged component: complete full creative phase process
□ Generate multiple design options (minimum 2-4 per component)
□ Analyze pros/cons of each option systematically
□ Select and justify recommended approach
□ Document implementation guidelines
□ Create memory-bank/decisions/design-options.md
□ Update memory-bank/tasks.md with design decisions
□ Update memory-bank/activeContext.md and progress.md
```

## CREATIVE PHASE METHODOLOGY

Based on Anthropic's Claude "Think" tool approach, adapted for Memory Bank workflow:

### Phase Structure
```
🎨🎨🎨 ENTERING CREATIVE PHASE: [COMPONENT NAME]
[Systematic design exploration]
🎨🎨🎨 EXITING CREATIVE PHASE
```

### Required Sections for Each Component
1. **Component Description**: What it is and what it does
2. **Requirements & Constraints**: What it must satisfy
3. **Multiple Options**: 2-4 different approaches
4. **Options Analysis**: Pros and cons of each
5. **Recommended Approach**: Selection with justification
6. **Implementation Guidelines**: Concrete next steps
7. **Verification**: Does solution meet requirements?

## CREATIVE PHASE TYPES

### Architecture Design
For system structure and component interaction decisions:

```markdown
🎨🎨🎨 ENTERING CREATIVE PHASE: ARCHITECTURE DESIGN

## Component: [Component Name]
**Type**: Architecture Design
**Description**: [What system/component needs architectural design]

## Requirements & Constraints
- **Functional**: [What it must do]
- **Non-functional**: [Performance, scalability, etc.]
- **Technical**: [Technology constraints]
- **Business**: [Business requirements]

## Design Options

### Option 1: [Approach Name]
**Description**: [How this approach works]
**Architecture**: [Key architectural elements]
**Components**: [Main components involved]

**Pros**:
- [Advantage 1]
- [Advantage 2]

**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

### Option 2: [Approach Name]
[Same structure as Option 1]

### Option 3: [Approach Name]
[Same structure as Option 1]

## Options Analysis
| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
| Performance | [Rating/Assessment] | [Rating] | [Rating] |
| Maintainability | [Rating] | [Rating] | [Rating] |
| Scalability | [Rating] | [Rating] | [Rating] |
| Implementation Complexity | [Rating] | [Rating] | [Rating] |

## Recommended Approach: [Selected Option]

**Justification**: [Why this option was selected]
- [Reason 1]
- [Reason 2]

## Implementation Guidelines
1. [Specific implementation step]
2. [Next step with technical details]
3. [Integration requirements]

## Verification
- ✅ Meets functional requirements: [How]
- ✅ Satisfies constraints: [Verification]
- ✅ Addresses technical concerns: [How addressed]

🎨🎨🎨 EXITING CREATIVE PHASE
```

### Algorithm Design
For complex logic and data processing decisions:

```markdown
🎨🎨🎨 ENTERING CREATIVE PHASE: ALGORITHM DESIGN

## Component: [Component Name]
**Type**: Algorithm Design
**Description**: [What algorithm/logic needs design]

## Requirements & Constraints
- **Input**: [What the algorithm receives]
- **Output**: [What it must produce]
- **Performance**: [Time/space complexity requirements]
- **Edge Cases**: [Special cases to handle]

## Algorithm Options

### Option 1: [Algorithm Approach]
**Description**: [How this algorithm works]
**Time Complexity**: [Big O notation]
**Space Complexity**: [Memory requirements]
**Pseudocode**:
```
[High-level pseudocode]
```

**Pros**:
- [Performance advantage]
- [Implementation advantage]

**Cons**:
- [Performance limitation]
- [Implementation complexity]

### Option 2: [Algorithm Approach]
[Same structure as Option 1]

## Options Analysis
| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
| Time Complexity | [Big O] | [Big O] | [Big O] |
| Space Complexity | [Memory] | [Memory] | [Memory] |
| Implementation Ease | [Assessment] | [Assessment] | [Assessment] |
| Edge Case Handling | [Assessment] | [Assessment] | [Assessment] |

## Recommended Approach: [Selected Algorithm]

**Justification**: [Why this algorithm was selected]
- Optimal for our use case because [reason]
- Balances performance and maintainability

## Implementation Guidelines
1. [Implementation detail 1]
2. [Error handling strategy]
3. [Testing approach for edge cases]

## Verification
- ✅ Handles all required inputs: [How verified]
- ✅ Meets performance requirements: [Measurement approach]
- ✅ Addresses edge cases: [Test cases]

🎨🎨🎨 EXITING CREATIVE PHASE
```

### UI/UX Design
For user interface and experience decisions:

```markdown
🎨🎨🎨 ENTERING CREATIVE PHASE: UI/UX DESIGN

## Component: [Component Name]
**Type**: UI/UX Design
**Description**: [What interface element needs design]

## Requirements & Constraints
- **User Needs**: [What users need to accomplish]
- **Usability**: [Ease of use requirements]
- **Accessibility**: [A11y requirements]
- **Consistency**: [Design system constraints]

## Design Options

### Option 1: [Design Approach]
**Description**: [How this interface works]
**User Flow**: [Key interaction steps]
**Visual Elements**: [Key UI components]

**Pros**:
- [User experience advantage]
- [Implementation advantage]

**Cons**:
- [User experience limitation]
- [Technical limitation]

### Option 2: [Design Approach]
[Same structure as Option 1]

## Options Analysis
| Criteria | Option 1 | Option 2 | Option 3 |
|----------|----------|----------|----------|
| User Experience | [Assessment] | [Assessment] | [Assessment] |
| Accessibility | [A11y rating] | [A11y rating] | [A11y rating] |
| Implementation | [Complexity] | [Complexity] | [Complexity] |
| Consistency | [Design system fit] | [Fit] | [Fit] |

## Recommended Approach: [Selected Design]

**Justification**: [Why this design was selected]
- Best user experience because [reason]
- Maintains design consistency

## Implementation Guidelines
1. [Specific component to create]
2. [Styling requirements]
3. [Interaction behavior]
4. [Accessibility considerations]

## Verification
- ✅ Meets user needs: [How verified]
- ✅ Accessible to all users: [A11y verification]
- ✅ Consistent with design system: [Verification method]

🎨🎨🎨 EXITING CREATIVE PHASE
```

## PROGRESSIVE DOCUMENTATION

Create memory-bank/decisions/design-options.md with all creative phase work:

```markdown
# Design Options and Decisions

> **Creative Phase Documentation**
> Generated during CREATIVE mode for Level 3-4 tasks

## Project: [Project Name]
**Date**: [Current Date]
**Task**: [Main task description]

## Creative Components Processed

### 1. [Component Name] - [Type]
**Status**: ✅ Design complete
**Decision**: [Selected approach]
**Reasoning**: [Brief justification]

[Full creative phase documentation]

### 2. [Component Name] - [Type]
**Status**: ✅ Design complete
**Decision**: [Selected approach]  
**Reasoning**: [Brief justification]

[Full creative phase documentation]

## Implementation Readiness
- ✅ All flagged components have design decisions
- ✅ Implementation guidelines provided for each
- ✅ Design decisions documented and justified
- ✅ Ready for IMPLEMENT mode

---
*Generated by CREATIVE mode*
*Original methodology by @vanzan01*
```

## QUALITY GATES

Before exiting CREATIVE mode, verify:

```
✅ EXIT CRITERIA - ALL MUST BE MET:
□ All flagged components have completed creative phases
□ Each component has 2-4 options explored
□ Pros and cons analyzed systematically
□ Recommended approach selected with justification
□ Implementation guidelines provided for each component
□ design-options.md created with complete documentation
□ tasks.md updated with design decisions
□ All memory bank files updated
```

## MODE TRANSITION

After completing all creative phases:

```markdown
CREATIVE MODE ANALYSIS COMPLETE ✅

**Components Processed**: [Number] design decisions completed
**Design Decisions**: All components have recommended approaches
**Next Mode**: IMPLEMENT MODE

**Key Deliverables**:
- ✅ [Number] creative phases completed
- ✅ Design options thoroughly analyzed
- ✅ Implementation guidelines documented
- ✅ All design decisions justified

**Files Updated**:
- ✅ memory-bank/decisions/design-options.md (complete design documentation)
- ✅ memory-bank/tasks.md (design decisions integrated)
- ✅ memory-bank/activeContext.md (creative work complete)
- ✅ memory-bank/progress.md (CREATIVE marked complete)

**Implementation Ready**: All design decisions provide clear implementation guidance
**Recommendation**: Proceed to IMPLEMENT MODE with design decisions.
```

## ERROR PREVENTION

**CRITICAL**: Creative phases CANNOT be rushed or skipped for Level 3-4 components. Each flagged component MUST complete the full creative phase process before proceeding to implementation.

---

**Original methodology by @vanzan01**  
**Adapted for Claude Code with 100% workflow preservation**