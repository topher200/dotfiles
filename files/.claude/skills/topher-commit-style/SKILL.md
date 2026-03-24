---
name: topher-commit-style
description: Write git commit messages in Topher's personal style. Use when creating commits, writing PR descriptions, or when the user asks for a commit message.
disable-model-invocation: false
---

# Topher's Commit Message Style Guide

Write commit messages that match Topher's established patterns from his commit history. This style is conversational, first-person, and technically precise.

## How to Create Commits

Use the GitHub MCP's graphite tool to create commits:

1. **Stage files**: Use `git add <files>` to stage the changes
2. **Create commit**: Use `mcp__graphite__run_gt_cmd` with `gt create --message "..."` to create the commit and branch

**IMPORTANT**: Do NOT push or submit. Only create the branch locally.

Example workflow:

```bash
# Stage files
git add file1.py file2.py

# Create commit with message (use the template below)
gt create --message "type(scope): description

### Issues Addressed

[Explanation of the problem/motivation]

### Summary

[What the PR does]

### Test Plan

[How it was tested]

Resolves: PLAT-X"
```

**Note**: Use `Resolves: PLAT-X` unless a specific ticket ID is provided (e.g., `PLAT-1234`).

## Subject Line Format

Use **conventional commits** format: `type(scope): description`

### Types (in order of frequency)

- `feat` - New features or capabilities
- `fix` - Bug fixes
- `chore` - Maintenance, dependencies, config updates
- `refactor` - Code restructuring without behavior change
- `infra` - Infrastructure/deployment changes (Terraform, CI, etc.)

### Scope

- **Optional** - only include when it adds clarity
- Use lowercase, typically a subsystem or tool name
- Examples: `(inv)`, `(conda)`, `(renovate)`, `(pyright)`, `(terraform)`, `(lefthook)`, `(chromatic)`, `(playwright)`

### Description

- Start with **lowercase** letter
- Use **imperative mood**: "update", "remove", "add", "fix", "skip"
- **No period** at end
- Be specific about what changed
- Keep under 72 characters

### Examples of Good Subject Lines

```
feat: upload MAR files from the Upload modal
fix(inv): skip import guard when running under pytest
chore(conda): remove chamber from environment.yml
refactor: remove deprecated /event-log endpoint
infra: put demo generation on bigger EC2 instances
fix(chromatic): use stable comparison ID in storybook
chore: move ruff lint job from CircleCI to Github Actions
feat(cloudflare-tunnel): dynamically update Tunnel EC2 instance IP
fix(lefthook): update biome and eslint hooks to handle no files
chore: add unit test for failing cbor2 version upgrade
```

## Commit Message Template

Use this exact template for commit messages (following the subject line):

```
type(scope): description

### Issues Addressed

[Explain the problem or motivation - first person, conversational]

### Summary

[Brief explanation of what the PR/commit does]

### Test Plan

[How the change was tested - can be "CI", "n/a", or detailed steps]

Resolves: PLAT-X
```

**Important**:

- Use `Resolves: PLAT-X` unless the user provides a specific Jira ticket ID (e.g., `PLAT-1234`)
- **DO NOT include** the "### Internal Documentation" section in commit messages

The first line becomes the PR title when using `gt create`. The subsequent sections form the commit body and PR description.

## PR Body Structure

Use these sections in order. Not all sections are required for every PR.

### Required Sections

#### `### Issues Addressed`

Explain the **problem** or **motivation**. This is the "why".

Style notes:

- First person ("I", "We")
- Conversational tone
- Link to relevant Slack threads, Jira tickets, or previous PRs
- Include context others need to understand the change
- Can use light humor when appropriate

Example:

```markdown
### Issues Addressed

We have an import guard to keep our `inv` tasks loading fast. This is
great!

However it also catches when we're running tests under `pytest`, which
isn't as great.
```

Another example:

```markdown
### Issues Addressed

This endpoint provides Redis data to the frontend for diagnostic logs.
We don't use this API any more; we instead use the ClickHouse-backed
version.

We've tried to delete this in the past but were stymied by one customer
still using it. Now that we're owned by that customer we can remove this
API.
```

#### `### Summary` or `### Summary of changes`

Explain **what** the PR does. Keep it brief.

Example:

```markdown
### Summary

Skip the import guard when running under `pytest`.
```

Example for removal:

```markdown
### Summary

Remove it.
```

#### `### Test Plan`

How the change was tested. Be honest about what was and wasn't tested.

Style notes:

- Use checkbox lists for multi-step verification
- Include actual commands that were run
- "CI" alone is acceptable for simple changes
- Be honest: "I'm not going to test it, seems pretty straightforward"
- Can include "n/a" for trivial changes

Examples:

```markdown
### Test Plan

CI
```

```markdown
### Test Plan

- [x] I've tested locally for Linux
- [ ] Find someone to test for MacOS
- Check out this branch
- run ./bin/setup.py
- verify `aws-vault --version` is 7.9.3
```

```markdown
### Test Plan

- Tested that we can now run pytest without error:

\`\`\`
$ pytest tasks/tests/test_slack_helpers.py
\`\`\`

- Tested that the import guard still works:

\`\`\`
$ uv run python -c "import sentry_sdk; import tasks"
...
\`\`\`
```

### Optional Sections

**Note**: The "### Internal Documentation" section should NOT be included in commit messages.

#### `### Alternatives Considered` or `### Other solutions`

Explain approaches that were rejected and why.

Example:

```markdown
### Alternatives Considered

I tried inlining this file
(https://github.com/memfault/memfault/pull/22531) but that's not advised
for license reasons
(https://memfault.slack.com/archives/C019Z4X8SBH/p1740753877681639).
```

#### `### Release plan`

For changes requiring staged rollout or post-merge steps.

Example:

```markdown
### Release plan

- [ ] merge
- [ ] deploy to demo branch via prod release pipeline
- [ ] then apply codepipeline
```

## Tone and Voice

### Do

- Use first person: "I updated", "We have", "I'm doing this"
- Be conversational: "This is great!", "Let's try this solution"
- Be direct and honest: "I don't think anyone will care", "I'm not going to debug"
- Show your work: include command outputs, screenshots, links
- Acknowledge limitations: "This won't actually have the effect I want"
- Use occasional light humor when natural

### Don't

- Be overly formal or corporate
- Use passive voice excessively
- Pad with unnecessary words
- Hide uncertainty - be upfront about what you don't know

## Complete Examples

### Example 1: Simple fix

```
fix(inv): skip import guard when running under pytest (#22572)

### Issues Addressed

We have an import guard to keep our `inv` tasks loading fast. This is
great!

However it also catches when we're running tests under `pytest`, which
isn't as great.

### Summary

Skip the import guard when running under `pytest`.

### Test Plan

- Tested that we can now run pytest without error:

\`\`\`
$ pytest tasks/tests/test_slack_helpers.py
\`\`\`
```

### Example 2: Removal with context

```
chore(conda): remove chamber from environment.yml (#22566)

### Issues Addressed

We've had `chamber` installed in our conda environment since 2021:
https://github.com/memfault/memfault/pull/3920

https://github.com/segmentio/chamber

We thought about using it but never did.

### Summary

Remove it.

### Release plan

- [ ] Remove from conda recipes:
      https://github.com/memfault/conda-recipes/pull/104

### Test Plan

none
```

### Example 3: Feature with alternatives

```
feat(cloudflare-tunnel): dynamically update Tunnel EC2 instance IP (#22344)

### Issues Addressed

I observed that I was unable to connect to atlantis.memfault.com. After
debugging, I realized the Cloudflare Tunnel EC2 instance's private IP
had changed and the security group had not been updated to reflect this
change.

### Summary

Instead of updating manually, I added a dynamic lookup for the current
instance IP address.

Other possible solutions:

- continue to update manually
- give the EC2 instance a range of IP addresses and allowlist all of
  them
- give it a static IP (difficult because it's an autoscaling group with
  a single instance, not an instance we manage in Terraform)

Let's try this solution for a bit. I think it's the best of the bunch.

### Test Plan

- [x] Preapplied
- [x] Confirmed i could now access atlantis.memfault.com
```

### Example 4: Infra change

```
infra: put demo generation on bigger EC2 instances (#22380)

### Issues addressed

We've been seeing demo generation failures. I think the issue is the
demo workers running out of memory.

### Summary of changes

Double their memory.

I'm not doing any changes to concurrency or RAM allocations per task.
Let's see if this simple change gets us to stop failing demo generation,
then we can dial in the exact amounts later.

### Test Plan

- [x] Preapplied
- [ ] Monitor tomorrows demo generation
```

## PR Number

When committing merged PRs, include the PR number in parentheses after the description:

```
feat: upload MAR files from the Upload modal (#22590)
```

For commits not yet associated with a PR, omit the number.

## Footer

Always include the Resolves trailer. Use `PLAT-X` by default unless a specific Jira ticket ID is provided:

```
Resolves: PLAT-X
```

If a specific ticket is provided:

```
Resolves: PLAT-3220
```

Remember: The goal is to write commit messages that are helpful to future readers (including yourself). Be specific, be honest, and show your reasoning.

## Practical Workflow Example

When creating a commit, follow this workflow:

1. **Stage your changes**:

```bash
git add www/api/routes/devices.py www/api/routes/cohorts.py
```

2. **Create the commit** using `mcp__graphite__run_gt_cmd`:

```json
{
  "args": [
    "create",
    "--message",
    "fix(api): prevent duplicate device registrations\n\n### Issues Addressed\n\nWe've been seeing duplicate device registrations when clients retry\nfailed requests. This causes issues downstream in cohort assignment.\n\n### Summary\n\nAdd idempotency check using device serial number before creating new\nregistrations.\n\n### Test Plan\n\n- [x] Added unit test for duplicate registration attempts\n- [x] Tested locally with retry scenarios\n- [ ] CI\n\nResolves: PLAT-X"
  ],
  "cwd": "/home/topher/memfault",
  "why": "Create commit with Topher's standard message format"
}
```

This workflow replaces the local command: `git add <files> && gt create`

**Note**: Do NOT use `gt submit` or push changes. Only create branches locally.
