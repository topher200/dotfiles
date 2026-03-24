---
name: basedpyright-clean
description: Remove all entries of a specific rule type from .basedpyright/baseline.json. Use when you want to clean up baseline violations after fixing type issues.
argument-hint: [rule-type]
disable-model-invocation: true
allowed-tools: Bash(python3 *), Read
---

# Basedpyright Baseline Cleaner

Remove all entries of a specific rule type from `.basedpyright/baseline.json`.

## Usage

```
/basedpyright-clean reportMissingParameterType
```

This will:

1. Read the baseline file
2. Remove all entries matching the specified rule type
3. Save the cleaned baseline
4. Report statistics (entries removed, entries remaining)

## Common rule types to clean

- `reportMissingParameterType` - Missing parameter type annotations
- `reportUnknownParameterType` - Unknown parameter types
- `reportMissingTypeArgument` - Missing type arguments
- `reportUnknownMemberType` - Unknown member types
- `reportAny` - Usage of `Any` type
- `reportExplicitAny` - Explicit `Any` annotations

## Task

Clean the basedpyright baseline file by removing all `$ARGUMENTS` entries:

1. Check that the `.basedpyright/baseline.json` file exists
2. Run the Python script below to remove all entries with the specified rule type
3. Report the statistics (original count, removed count, remaining count)

```python
import json
import sys
from pathlib import Path

# Get the rule type from arguments
rule_type = "$ARGUMENTS"
if not rule_type:
    print("Error: Please specify a rule type")
    sys.exit(1)

baseline_path = Path('.basedpyright/baseline.json')

# Check if file exists
if not baseline_path.exists():
    print(f"Error: {baseline_path} not found")
    sys.exit(1)

# Read the baseline file
with open(baseline_path, 'r') as f:
    data = json.load(f)

# Count original entries
original_count = sum(len(entries) for entries in data['files'].values())
print(f"Original total entries: {original_count}")

# Count entries to remove
remove_count = sum(
    len([item for item in entries if item.get('code') == rule_type])
    for entries in data['files'].values()
)
print(f"{rule_type} entries to remove: {remove_count}")

if remove_count == 0:
    print(f"No {rule_type} entries found in baseline")
    sys.exit(0)

# Filter out specified rule type entries
filtered_files = {}
for filepath, entries in data['files'].items():
    filtered_entries = [
        entry for entry in entries
        if entry.get('code') != rule_type
    ]
    if filtered_entries:  # Only include files that still have entries
        filtered_files[filepath] = filtered_entries

# Update data with filtered files
data['files'] = filtered_files

# Count remaining entries
remaining_count = sum(len(entries) for entries in data['files'].values())
print(f"Remaining entries: {remaining_count}")
print(f"Files removed (no remaining entries): {len(data['files']) - len(filtered_files)}")

# Write back to file
with open(baseline_path, 'w') as f:
    json.dump(data, f, indent=2)

print(f"\nSuccessfully removed all {rule_type} entries")
```

Save this script to a temporary file and run it with Python 3.
