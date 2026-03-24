---
name: find-PRs-with-CI-failures
description: Find and summarize your open PRs with failing CI in the memfault repo
argument-hint: (optional)
allowed-tools: ToolSearch, mcp__graphite__*, mcp__github__*, Bash(gh *)
---

# Failing CI PR Finder

Find all your open PRs in the memfault/memfault repo that have failing CI checks and present them in a concise summary.

## Usage

```
/find-PRs-with-CI-failures
```

This will show all your PRs with failing CI in a compact table format.

## Task

1. Use Graphite MCP to get local branch information: `mcp__graphite__run_gt_cmd` with args `["state"]` and cwd `/home/topher/memfault`
2. Load GitHub MCP tools if not already loaded
3. Search for open PRs authored by topher200 in memfault/memfault
4. Get full details for each PR to obtain the branch name (head.ref)
5. Filter to only PRs whose branches exist locally (match against graphite state output)
6. For each local PR, check CI status using `gh pr checks <pr-number> --repo memfault/memfault`
7. Filter to only PRs with at least one failing check
8. Present results in this format:

**PRs with Failing CI**

| PR #   | Branch                     | Title       | Draft | Failures               |
| ------ | -------------------------- | ----------- | ----- | ---------------------- |
| #22533 | `topher/01-26-refactor...` | Short title | Yes   | basedpyright, CircleCI |
| #22534 | `topher/01-26-chore...`    | Short title | Yes   | CircleCI               |

**Details:**

- **PR #22533** - refactor: remove deprecated /event-log endpoint

  - Branch: `topher/01-26-refactor_remove_deprecated__event-log_endpoint`
  - URL: https://github.com/memfault/memfault/pull/22533
  - Failures:
    - basedpyright: failed (2m54s)
    - run-on-pr (CircleCI): failed (25m29s)

- **PR #22534** - chore: remove unused EventListQuery schema
  - Branch: `topher/01-26-chore_remove_unused_eventlistquery_schema`
  - URL: https://github.com/memfault/memfault/pull/22534
  - Failures:
    - run-on-pr (CircleCI): failed (24m46s)

Keep the summary concise - aim for about half a page total. Show:

- PR number
- Branch name (truncate in table, show full in details)
- Title (truncated if needed)
- Draft status
- Full PR URL in details section
- Which specific checks failed (not all checks)

**Efficiency notes:**

- Using Graphite state to filter to local branches reduces unnecessary CI checks for remote-only PRs
- Only checking CI status for PRs that have local branches saves time

Sort PRs by number (newest first) and limit details to failing checks only.
