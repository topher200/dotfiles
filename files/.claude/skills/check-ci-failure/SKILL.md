---
name: check-ci-failure
description: Find the most serious failing CI check on the current branch's PR and explain what failed
argument-hint: (no arguments needed)
allowed-tools: Task
---

# Check CI Failure for Current Branch

Investigate the most serious failing CI check on the current branch's PR and
present a clear summary of what failed and why.

## Task

Spawn a **single subagent** (subagent_type: `general-purpose`) to do all
investigation. The subagent saves tokens by doing all queries itself and
returning only the final report. Pass it the prompt below verbatim.

---

**Subagent prompt:**

You are investigating CI failures for the current git branch in the
`memfault/memfault` repo. Work through the steps below sequentially and return
a concise report. Do NOT summarize until Step 5.

**Repo**: `memfault/memfault`
**Working directory**: `/home/topher/memfault`

---

### CRITICAL: Load deferred tools before calling them

All MCP tools are deferred — calling them without loading first causes an
immediate error. Before calling any MCP tool, load it with `ToolSearch`.
You can load multiple tools in one `ToolSearch` call by using keyword search.

Load these groups as you need them:

```
ToolSearch("graphite run gt cmd")          # loads mcp__graphite__run_gt_cmd
ToolSearch("github search pull requests")  # loads mcp__github__search_pull_requests
ToolSearch("circleci get build failure")   # loads mcp__circleci__get_build_failure_logs
ToolSearch("circleci latest pipeline")     # loads mcp__circleci__get_latest_pipeline_status
```

---

### Step 1 — Identify the current branch

Call `mcp__graphite__run_gt_cmd` (after loading it):

```json
{
  "args": ["log", "short"],
  "cwd": "/home/topher/memfault",
  "why": "find current branch"
}
```

The output is a visual stack. The branch marked with `◉` is the current branch.
Record its exact name.

---

### Step 2 — Find the open PR

Call `mcp__github__search_pull_requests` (after loading it):

```json
{ "query": "head:<BRANCH_NAME> repo:memfault/memfault is:open" }
```

Record the PR number and title from the first result.

---

### Step 3 — Get all CI checks

Run via Bash:

```bash
gh pr checks <PR_NUMBER> --repo memfault/memfault 2>&1
```

Each output line has four tab-separated fields:
`check-name  status  duration  url`

Collect every line where `status` is `fail`. Record both the check name and URL
— you will need the check name to look up annotations in Step 5.

---

### Step 4 — Pick the most serious failure

From the failing checks, select ONE using this priority order (highest first):

1. **`run-on-pr`** (CircleCI) — main backend/integration suite, highest signal
2. Any other CircleCI workflow (URL contains `circleci.com`)
3. Functional GitHub Actions checks: `basedpyright`, `ruff`, `uv`, `js`
4. Everything else (cosmetic: `chromatic`, `codecov`, `biome`, `unused-snapshots`)

Ignore any check with status `pending` or `skipped`.

Record the chosen check's name, URL, and duration.

---

### Step 5 — Fetch failure details

#### If the failing check is CircleCI (URL contains `circleci.com`)

**Step 5a.** Call `mcp__circleci__get_build_failure_logs` (after loading it).

The `params` argument MUST be a JSON **object** (not a string). Use Option 3
(project detection) with all three fields:

```json
{
  "params": {
    "workspaceRoot": "/home/topher/memfault",
    "gitRemoteURL": "https://github.com/memfault/memfault.git",
    "branch": "<BRANCH_NAME>"
  }
}
```

**Step 5b.** The output will likely be truncated (50 KB limit). When truncated,
the tool result includes a file path like:

```
Output too large. Full output saved to: /home/topher/.claude/projects/.../tool-results/<id>.json
```

If truncated, read the saved file and extract the relevant section:

```python
import json
with open('<saved_file_path>') as f:
    data = json.load(f)
text = data[0]['text']
# The error is always near the END (Docker build spam fills the beginning)
print(text[-3000:])
```

Run this via Bash (using a heredoc or python3 -c).

**Step 5c.** Parse the output structure:

The output uses `<<<SEPARATOR>>>` between sections. Each section starts with:

```
Job: <job-name>
```

Jobs with actual logs ran; jobs that say `No steps found.` were never reached.
The **failing job** is the last one with actual log content before the
`No steps found.` jobs begin.

Look for the error in the failing job's logs:

- `error:` / `Error:` / `ERROR`
- `FAILED` / `Failed`
- `exit code: <N>` (non-zero)
- `AssertionError`, `ImportError`, `ModuleNotFoundError`
- Docker build failures: `ERROR: failed to solve:`

Capture: the job name, the error message (verbatim, up to ~20 lines), and
enough surrounding context to understand what was running.

#### If the failing check is GitHub Actions (URL contains `github.com/.../actions`)

**Preferred: use the check-run annotations API** — much faster than downloading
full logs.

**Step 5a.** Get the PR's head SHA:

```bash
gh pr view <PR_NUMBER> --repo memfault/memfault --json headRefOid -q .headRefOid
```

**Step 5b.** List all check runs for that commit and find the failing one's ID:

```bash
gh api repos/memfault/memfault/commits/<HEAD_SHA>/check-runs \
  --jq '.check_runs[] | {name: .name, status: .status, conclusion: .conclusion, id: .id}'
```

Find the entry whose `name` matches the failing check and record its `id`.

**Step 5c.** Fetch annotations for that check run:

```bash
gh api repos/memfault/memfault/check-runs/<CHECK_RUN_ID>/annotations \
  --jq '.[] | {path: .path, start_line: .start_line, message: .message, annotation_level: .annotation_level}'
```

Annotations contain the exact file path, line number, and error message. Focus
on entries with `annotation_level: "failure"`.

**Fallback: if no annotations exist** (`annotations_count` is 0 on the check run
detail), extract the run ID from the URL (the number after `/runs/`) and run:

```bash
gh run view <RUN_ID> --repo memfault/memfault --log-failed 2>&1 | tail -150
```

Look for the step name that failed and the error message.

---

### Step 6 — Return the report

Return ONLY this block, filled in:

```
## CI Failure Report

**PR**: #<number> — <title>
**Branch**: <branch-name>
**Most serious failing check**: <check-name> (<duration>)
**Check URL**: <url>

### Failing Job
<job name from CircleCI, or step name from GitHub Actions>

### Error (verbatim)
<error message, trimmed to ~20 lines>

### Root Cause Summary
<2-4 sentences: what failed, in what context, and why>
```

Do not speculate about fixes. Do not include passing checks. If logs were
fully truncated and no error could be found, say so explicitly and include the
check URL so the user can investigate manually.

---

## After the subagent returns

Present the subagent's report to the user with no additional commentary.
