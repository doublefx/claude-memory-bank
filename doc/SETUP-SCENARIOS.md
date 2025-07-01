# Memory Bank Setup Scenarios

## Understanding the Options

### Scenario 1: Single Project Repository
**When to use**: You have one git repository with one project

```
my-project/ (.git)
├── src/
├── tests/
└── package.json
```

**Setup**: 
```bash
setup-memory-bank.sh --single
# or just press Enter for default
```

**Result**:
```
my-project/
├── .memory-bank/
│   ├── context/
│   ├── active/
│   └── ...
└── src/
```

### Scenario 2: Multi-Project Repository (Same Git)
**When to use**: Multiple related projects in ONE repository

```
my-workspace/ (.git)
├── frontend/
├── backend/
└── shared/
```

**Setup**:
```bash
setup-memory-bank.sh --multi
# Then add projects:
setup-memory-bank.sh --add-project
```

**Result**:
```
my-workspace/
├── .memory-bank/
│   ├── shared/
│   ├── frontend/
│   │   ├── context/
│   │   └── active/
│   └── backend/
│       ├── context/
│       └── active/
└── frontend/
```

### Scenario 3: Hierarchical Repositories (Nested Git)
**When to use**: You have git repos inside git repos

```
platform/ (.git)
├── services/
│   ├── auth/ (.git)
│   └── api/ (.git)
└── libs/
    └── core/ (.git)
```

**Setup approach**: Run setup in EACH repository
```bash
cd platform
setup-memory-bank.sh --single

cd services/auth
setup-memory-bank.sh --single

cd ../api
setup-memory-bank.sh --single
```

**Result**:
```
platform/
├── .memory-bank/        # Platform's memory bank
├── services/
│   ├── auth/
│   │   └── .memory-bank/  # Auth's memory bank
│   └── api/
│       └── .memory-bank/  # API's memory bank
```

## Decision Tree

```
Do you have nested .git directories?
├── YES → Hierarchical (Setup in each)
└── NO
    └── Do you have multiple projects to track separately?
        ├── YES → Multi-project setup
        └── NO → Single-project setup
```

## Common Confusion

### "I chose multi-project for my monorepo with submodules"
**Issue**: Multi-project is for multiple projects in the SAME git repo, not for nested repos.

**Solution**: For git submodules or nested repos, use single-project setup in each repository.

### "The setup failed with 'No such file or directory'"
**Issue**: Bug in v2.0 where multi-project setup doesn't create all needed directories.

**Quick fix**:
```bash
mkdir -p .memory-bank/custom_modes .memory-bank/scripts
# Then copy mode files manually
```

## Best Practices

1. **For Monorepos with Submodules**: Use hierarchical approach
2. **For Monorepos without Submodules**: Use multi-project if you need separate contexts
3. **For Simple Projects**: Always use single-project
4. **When Unsure**: Start with single-project (you can always restructure later)

## Hierarchy Features

When you have hierarchical repos, Memory Bank can:
- Detect all nested repositories
- Suggest distributed setup
- Track relationships in `hierarchy.json`
- Enable pattern inheritance (child overrides parent)
- Respect `memory-bank-ignore` for exclusions

Run `python .memory-bank/scripts/detect-hierarchy.py` to analyze your structure!