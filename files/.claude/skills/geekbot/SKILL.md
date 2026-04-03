---
name: geekbot
description: |
  Generate Topher's daily Geekbot standup update. Produces copy/pastable "yesterday" and "today" summaries, and records the commitment in today's daily log. Trigger on "geekbot", "standup", "standup update", or "/geekbot".
---

# Geekbot Standup Generator

Generate Topher's daily Geekbot standup responses by reading his daily work logs and TODO list.

## How It Works

1. Read yesterday's log from `~/topher-notes/` (or the most recent workday's log if yesterday has none)
2. Read today's log from `~/topher-notes/`
3. Produce two copy/pastable blocks: "yesterday" and "today"
4. Update today's log with a `## Geekbot` section recording what was promised

## Data Sources

- **Yesterday summary**: Pull from the previous day's log — look at `##` project headers, `### Things Accomplished` sections, and PRs. Summarize the 2-5 most important things at a very high level.
- **Today summary**: Pull from today's log TODO list (uncompleted items) and any `### Next Steps` sections. Pick the 2-5 most important things Topher plans to work on.
- **PR context**: If available in the logs, use PR descriptions to inform summaries but do NOT include PR numbers in the Geekbot output — keep it high-level.
- **gh CLI**: If the logs are thin, use `gh pr list --author=@me --search="created:>=YYYY-MM-DD" --repo=memfault/memfault` to supplement. Keep the date range tight (yesterday + today only, unless Topher specifies otherwise).

## Output Format

Output must be left-justified with no leading spaces, ready to paste directly into Geekbot/Slack. Use this exact format:

```
**What I did:**
item one
item two
item three

**What I'll do today:**
item one
item two
item three
```

### Style Guide (from real examples)

- **2-5 items per section.** Pick the most significant work. Don't list every PR or minor fix.
- **Very high-level.** "Spot instance stability fixes" not "moved ABIS from launch template to ASG overrides, diversified instance families, shortened stop timeout"
- **Terse, casual tone.** Sentence fragments are fine. No periods at end of lines.
- **Use active voice.** "Fixed X", "Investigated Y", "Working on Z"
- **Group related work.** 3 spot-instance PRs = one line item about spot instances
- **"Working on X" is fine** for in-progress items that span days
- **No PR numbers, no links, no markdown formatting** in the Geekbot output itself

Real examples of Topher's voice:

- "Resolved Francois's minor #bug-reports FE issue"
- "MAR file upload modal"
- "Investigated issue with Redis keys. Limited the chunks diagnostics queue for Elemind"
- "been working on Vanta deps"
- "I've been working on a bunch of little papercuts I found while debugging customer issues"
- "coordinating with Andreas on AWS account ownership"

## After Generating Output

Update today's `~/topher-notes/YYYY-MM-DD-dayname.md` file:

- Add a `## Geekbot` section (place it just before the `---` separator and TODO list)
- Record the "today" items so that when work gets done later, the same language can be reused

```markdown
## Geekbot

Promised today:

- item one
- item two
- item three
```

## Edge Cases

- **Monday standup**: "Yesterday" covers Friday (or the most recent workday log found)
- **No log for yesterday**: Use `gh pr list` to reconstruct, or note that no log was found and ask Topher
- **Thin logs**: Supplement with PR data from `gh`
