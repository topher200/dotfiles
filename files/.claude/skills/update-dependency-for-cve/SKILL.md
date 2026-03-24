---
name: update-dependency-for-cve
description: Upgrade a dependency to resolve a CVE—prefer upgrading direct dependents, check release notes, verify codebase, then commit
argument-hint: "<vulnerable-package> <min-safe-version> (e.g. @remix-run/router 1.23.2)"
allowed-tools: Bash(yarn *), Bash(git *), Bash(gt *), Read, Grep, WebSearch, mcp_web_fetch
---

# Update a Dependency to Resolve a CVE

Follow this workflow when Dependabot (or similar) reports a CVE in a transitive or direct dependency. The goal is to upgrade to a safe version, confirm the codebase is unaffected, and commit the fix.

## Usage

```
/update-dependency-for-cve <vulnerable-package> <min-safe-version>
```

Example: resolving a CVE in `@remix-run/router` by upgrading to 1.23.2+:

- Identify that the vulnerability is in **@remix-run/router** and the fix is **1.23.2+**.
- The **users** of that package might be direct deps (e.g. **react-router**, **react-router-dom**). Prefer upgrading those instead of adding a Yarn resolution.

## Workflow

### Step 1 — Prefer upgrading direct dependents over a resolution

- **Do not** add a `resolutions` entry in the root `package.json` as the first resort.
- Find which packages in the repo **directly** depend on the vulnerable package (e.g. grep `package.json` and `yarn.lock` for the vulnerable package name).
- Determine the **minimum version** of those direct dependents that pulls in the fixed version of the vulnerable package (e.g. check npm/unpkg or the dependent’s `package.json` for the version that depends on the safe range).
- **Upgrade the direct dependents** in the appropriate `package.json`(s) to that version (or a compatible newer one). Only use a root **resolution** if there is no newer version of the direct dependent that fixes the CVE.

### Step 2 — Update the dependency and install

- Edit the right `package.json`(s) to bump the direct dependent(s) to the chosen version(s).
- Run install **allowing lockfile updates** (this repo uses immutable installs in CI), then dedupe:

  ```bash
  YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install
  yarn dedupe
  ```

- Confirm in **yarn.lock** that the vulnerable package now resolves to the **safe version** (e.g. no remaining entry for the old vulnerable version, or the only entry is the new one).

### Step 3 — Check release notes and summarize

- For **each** upgraded package (and if useful, the vulnerable package), fetch release notes for the range you crossed (e.g. from the project’s CHANGELOG or GitHub Releases).
- Build a short summary that includes:
  - **Security**: Note that the upgrade includes the CVE fix.
  - **Stabilized / new APIs**: Additive changes (e.g. previously `unstable_*` now stable). We only care if we use them.
  - **Breaking or behavioral changes**: Any removals, renames, or behavior changes. For each, note whether it affects **our** code (e.g. “We use X; still present” or “We don’t use Y; N/A”).
  - **Bug fixes**: Any that touch APIs we use (e.g. param decoding, navigation). Call out if our usage is affected or benefits from the fix.

Use this summary later in the PR body (see Step 6).

### Step 4 — Check the codebase for obvious issues

- **Grep** the repo for:
  - Imports and usages of the upgraded package(s) and any `unstable_*` or `future.*` APIs mentioned in the release notes.
- For each API we use, confirm:
  - It still exists and is exported (e.g. check type definitions or built dist of the new version).
  - Any behavioral change in the release notes does not break our usage (e.g. we want decoded params, not encoded).
- Run **type-check** and **tests** that touch the upgraded code:

  ```bash
  cd packages/memfault-app-frontend && yarn tsc --noEmit
  yarn vitest run <relevant-test-patterns>
  ```

- If something breaks, either fix the code or choose a different upgrade path (e.g. a different minor version).

### Step 5 — Commit

- Stage the changed files (`package.json`(s) and `yarn.lock`) and commit using the template in Step 6.

### Step 6 — PR/commit template for CVE dependency upgrades

Use the following as the **source of truth** for the commit message and PR description when the change is “upgrade dependency X to fix CVE in Y”:

```
chore: upgrade <direct-dependent> to fix <vulnerable-package> CVE

### Issues Addressed

Dependabot reported a CVE in the transitive dependency <vulnerable-package> <old-version>
(pulled in by <direct-dependent> <old-version>). We need <min-safe-version>+ to resolve it.

<optional: link to Dependabot alert or ticket>

### Summary

Upgrade <direct-dependent>(s) from <old-range> to <new-range>. That version
ships with <vulnerable-package> <safe-version> which resolves the CVE.

<optional: 1–2 sentences on why we upgraded direct deps instead of using a resolution.>

<optional: paste or summarize the release-notes summary from Step 3, e.g.>

I had Cursor check the release notes and it said we're fine:

```

<your summary of notable changes, breaking changes, and our usage>

```

### Test Plan

- [ ] CI

Resolves: PLAT
```

- Replace placeholders with the actual package names and versions.
- Keep the structure (Issues Addressed, Summary, Test Plan, Resolves). Add “Alternatives Considered” or “Release plan” only if relevant.

## Example (react-router / @remix-run/router)

- **CVE**: @remix-run/router 1.20.0 → need 1.23.2+.
- **Users**: react-router and react-router-dom 6.27.0 (in `packages/memfault-app-frontend/package.json`). Upgraded them to ^6.30.3 instead of adding a resolution.
- **Install**: `YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install` then `yarn dedupe`; confirmed in yarn.lock that @remix-run/router is 1.23.2.
- **Release notes**: Checked 6.27 → 6.30; summarized security fix, stabilized APIs we don’t use, patchRoutesOnNavigation/dataStrategy breaking scope (we use BrowserRouter + Routes), useMatch decoding (we use it; change is desired).
- **Codebase**: Confirmed UNSAFE*RouteContext still exported; no use of createBrowserRouter, loaders/actions, or unstable*\*; tsc and relevant vitest tests passed.
- **Commit**: Used the template above with that summary.

## Notes

- Always prefer **upgrading the packages that depend on the vulnerable package** over a root `resolutions` override, so the dependency tree stays accurate and future upgrades are straightforward.
- If the lockfile is large, grepping for the vulnerable package name and version in **yarn.lock** is enough to confirm the fix.
- For release notes, the project’s CHANGELOG (e.g. on GitHub) or npm/unpkg package metadata is usually sufficient; link or paste the summary into the PR so reviewers don’t have to redo the research.
