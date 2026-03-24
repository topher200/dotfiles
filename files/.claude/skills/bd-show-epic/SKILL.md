---
name: bd-show-epic
description: Show a beads epic and all its children in full detail, ready to copy/paste
argument-hint: <epic-id>
allowed-tools: Bash
---

# Show Epic and All Children

Given the epic ID in `$ARGUMENTS`, print the epic and every child issue in full.

## Task

1. Run `bd show $ARGUMENTS` to get the epic details and list of children.
2. Parse the child IDs from the CHILDREN section (lines like `↳ ○ <id>:`).
3. Run `bd show <id>` for each child.
4. Print everything to the user in one block, separated by `==========` headers.

Use this shell one-liner to do it all at once:

```bash
EPIC="$ARGUMENTS"
bd show "$EPIC"
echo ""
for id in $(bd children "$EPIC" --json | python3 -c "import sys,json; [print(x['id']) for x in json.load(sys.stdin)]"); do
  echo "========== $id =========="
  bd show "$id"
  echo ""
done
```

Run it via Bash and print the output directly to the user with no additional commentary.
