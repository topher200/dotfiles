# Migration Gotchas

Known pitfalls discovered during real migrations. Read this if any step fails unexpectedly.

## `bd init --from-jsonl` is broken (v0.56.1)

Reports success but imports 0 issues. Filed as [#2096](https://github.com/steveyegge/beads/issues/2096). Use the bundled `scripts/jsonl-to-dolt.py` instead.

## `bd init` refuses if `beads.db` exists

The old SQLite file triggers "This workspace is already initialized" even after removing `.beads/dolt`. You must `rm -rf .beads` entirely, not just the dolt subdirectory.

## `rm -rf .beads` destroys the JSONL

The JSONL lives at `.beads/issues.jsonl`. If you remove `.beads` without backing up first, your issue data is gone. Always back up to `/tmp/` before deleting.

## `bd migrate --to-dolt` doesn't work (v0.56.1)

The `--to-dolt` flag references embedded Dolt mode, which was **removed in v0.56.1**. The command errors with "Dolt backend requires CGO" but this is a dead end — embedded mode no longer exists regardless of how the binary was built. v0.56.1 is server-only by design. Do not attempt to rebuild with CGO; use the server-based migration in SKILL.md instead.

## Dolt issues table has NOT NULL fields without defaults

The `design`, `acceptance_criteria`, and `notes` columns are `NOT NULL` with no default value. JSONL data doesn't include these fields, so naive SQL INSERTs fail with:

```
Error 1105 (HY000): Field 'design' doesn't have a default value
```

The import script handles this by inserting empty strings for these columns.

## `dolt sql` requires specific flags for non-interactive use

Three flags are needed to connect to the server non-interactively:

```bash
DOLT_CLI_PASSWORD="" dolt --host 127.0.0.1 --port 3308 --user root --no-tls sql -b < file.sql
```

- `DOLT_CLI_PASSWORD=""` — Without this, dolt prompts for password and hangs
- `--no-tls` — Without this, fails with "TLS requested but server does not support TLS"
- `-b` — Batch mode for multi-statement SQL files
- `--host`, `--port`, `--user` are **global flags** (before `sql` subcommand), not sql flags

## `bd sql` only accepts single statements

Cannot pipe multi-statement SQL files through `bd sql`. For bulk imports, use `dolt sql` directly with the server connection flags above.

## Socket warning during backup

`cp -R .beads` warns about `bd.sock` being a socket. This is harmless — the socket is for the daemon and gets recreated.

## Database name format

The Dolt database name follows the pattern `beads_<issue-prefix>`. Find it with:

```bash
bd sql "SHOW DATABASES" 2>&1 | grep beads
```

Or check `.beads/metadata.json` for the `dolt_database` key.

## Federation warnings are normal

After migration, `bd doctor` may show federation errors like:

```
Error 1045 (28000): Access denied for user 'root'@'192.168.65.1'
```

These point to Docker's internal IP, not the local server. They're non-critical and relate to remote sync configuration.
