# Claude Code Memory Bank Configuration - Hybrid System

> **Memory Bank System v2.2.0** - Context-Driven Workflow  
> Original methodology by @vanzan01, hybrid design for optimal context + workflow balance  
> Combines context preservation with structured development workflow

## System Overview

The Memory Bank hybrid system combines context-driven development with structured workflow modes. It prioritizes understanding through persistent context files while maintaining quality through simplified workflow progression.

### Core Philosophy

1. **Context First**: All work begins with understanding the system through context files
2. **Adaptive Workflow**: Workflow complexity scales with task complexity (3 levels)
3. **Living Documentation**: Context files are continuously updated as the system evolves
4. **Minimal Ceremony**: Only use workflow modes that add value to the current task

## CRITICAL: Project Structure Validation

### BEFORE ANY WORKFLOW MODE
When any workflow mode is invoked (@VAN, @PLAN, etc.), you MUST:

1. **ALWAYS** check for .memory-bank structure first:
   ```bash
   find . -name ".memory-bank" -type d -maxdepth 3 | head -10
   ```

2. **IF NO .memory-bank FOUND**:
   - Display the evidence (show the find command output)
   - Inform user: "No .memory-bank structure detected"
   - Instruct user to:
     ```
     Please exit and run: cmb-setup
     This will create the proper memory bank structure and templates.
     Then re-run: claude
     ```
   - **STOP** - Do not proceed with any workflow mode

3. **IF .memory-bank EXISTS**:
   - Continue with the appropriate workflow mode

## File Structure Details

### MANDATORY: Read Structure First
When .memory-bank exists, you MUST read and understand the file structure:

```bash
# Always run this to understand the structure
find .memory-bank -type f -name "*.md" | head -20
```

### Expected Directories and Files

#### context/
- **projectBrief.md** - Project overview and goals
- **productContext.md** - Business and user perspective  
- **systemPatterns.md** - Architecture and code patterns
- **techContext.md** - Technical implementation details

### Multi-Project Structure

#### shared/
- **patterns.md** - Cross-project code patterns
- **conventions.md** - Global coding standards
- **architecture.md** - Overall system design

## Workflow Modes

### @ASK - Explore & Discuss
1. Check for .memory-bank structure (see Project Structure Validation)
2. Read instructions in .memory-bank/custom_modes/ask_instructions.md

### @VAN - Initialize & Assess
1. Check for .memory-bank structure (see Project Structure Validation)
2. Read instructions in .memory-bank/custom_modes/van_instructions.md

### @PLAN - Strategy & Design
1. Check for .memory-bank structure (see Project Structure Validation)
2. Read instructions in .memory-bank/custom_modes/plan_instructions.md

### @IMPLEMENT - Build & Test
1. Check for .memory-bank structure (see Project Structure Validation)
2. Read instructions in .memory-bank/custom_modes/implement_instructions.md

### @REFLECT - Validate & Learn
1. Check for .memory-bank structure (see Project Structure Validation)
2. Read instructions in .memory-bank/custom_modes/reflect_instructions.md