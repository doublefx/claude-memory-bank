# Temporary Files Tracking

> Track all temporary files, test directories, and other transient resources created during development.
> Remove entries after cleaning up the files.

| Date | Purpose | Path |
|------|---------|------|
| | | |

## Usage Instructions

1. **Add Entry**: When creating any temporary file or directory
2. **Include**: Test directories, backup files, migration artifacts, temporary outputs
3. **Remove Entry**: After deleting the actual file/directory
4. **Review**: Check this file during REFLECT mode for cleanup

## Examples

| Date | Purpose | Path |
|------|---------|------|
| 2025-06-20 | Test directory for v1 migration | ./test/test-projects |
| 2025-06-20 | Backup from migration | ./memory-bank-backup-20250620 |
| 2025-06-20 | Temporary test output | ./test-results.tmp |