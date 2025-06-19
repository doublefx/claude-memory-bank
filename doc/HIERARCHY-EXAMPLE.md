# Hierarchical Pattern Inheritance Example

## Example Structure
```
platform/ (.git)
├── memory-bank/
│   └── shared/
│       ├── patterns.md      # Platform-wide patterns
│       └── conventions.md   # Global conventions
├── services/
│   └── auth-service/ (.git)
│       └── memory-bank/
│           └── context/
│               └── systemPatterns.md  # Auth-specific patterns
└── libs/
    └── crypto-lib/ (.git)
        └── memory-bank/    # No patterns defined yet
```

## Pattern Resolution

### For `platform/` (Parent)
- Uses its own `shared/patterns.md`
- Uses its own `shared/conventions.md`

### For `auth-service/` (Child with patterns)
- **Conventions**: Inherits from `platform/memory-bank/shared/conventions.md`
- **Patterns**: Uses its own `context/systemPatterns.md` (child-first)
- Parent patterns available at: `../../memory-bank/shared/patterns.md`

### For `crypto-lib/` (Child without patterns)
- **Conventions**: Inherits from `platform/memory-bank/shared/conventions.md`
- **Patterns**: Inherits from `platform/memory-bank/shared/patterns.md`
- When it creates its own patterns, they will override parent patterns

## hierarchy.json Example

In `auth-service/memory-bank/hierarchy.json`:
```json
{
  "version": "2.1",
  "current_project": {
    "path": ".",
    "name": "auth-service",
    "type": "single-project"
  },
  "parent": {
    "path": "../..",
    "memory_bank_path": "../../memory-bank",
    "relationship": "subdirectory",
    "inherit_conventions": true,
    "inherit_patterns": "if_not_exists"
  },
  "pattern_resolution": {
    "strategy": "child_first",
    "inherit_from_parent": ["conventions", "shared_patterns"],
    "override_in_child": ["project_patterns"]
  },
  "references": {
    "parent_patterns": "../../memory-bank/shared/patterns.md",
    "parent_conventions": "../../memory-bank/shared/conventions.md"
  }
}
```

## VAN Mode Behavior

When running `@VAN` in `auth-service/`:
```
Hierarchical project structure detected:
- Current: auth-service
- Parent: ../.. (has memory-bank: yes)
- Inheriting conventions from: ../../memory-bank/shared/conventions.md
- Using local patterns from: ./context/systemPatterns.md

Note: Parent patterns available at ../../memory-bank/shared/patterns.md
Consider referencing them in your systemPatterns.md if relevant.
```

## memory-bank-ignore Example

In `platform/memory-bank-ignore`:
```
# Exclude experimental projects
experimental/
sandbox/

# Exclude third-party code
vendor/
external/

# Exclude build outputs
*/dist/
*/build/
```

This ensures hierarchy detection skips these directories.