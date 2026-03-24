---
name: beads-dolt-upgrade
description: "MANDATORY: Invoke this skill IMMEDIATELY when ANY `bd` command fails with Dolt errors. Triggers: 'Dolt backend configured but database not found', 'Error 1045 (28000): Access denied', 'Unable to open database', 'Failed to open database', 'failed to create database', 'failed to connect to dolt server'. Do NOT attempt manual fixes."
---

# Beads Dolt Upgrade

Beads v0.56+ uses Dolt (git-for-databases MySQL server) instead of SQLite. **Server mode is mandatory** — v0.56.1 intentionally removed embedded Dolt mode (see changelog: "remove embedded Dolt mode from init and main command paths", "drop dolthub/driver dependency — binary size 168MB → 41MB"). A running `dolt sql-server` is required; there is no embedded/CGO alternative.

Do NOT downgrade to v0.55.4 (Homebrew's current version) to get embedded mode back — beads is moving server-only.

## Procedure

### Phase 1: Dolt Server (One-Time)

Check if already running:

```bash
which dolt && lsof -i :3308
```

If both succeed, skip to Phase 2.

#### 1.1 Install and Configure

```bash
brew install dolt
mkdir -p ~/dolt-data
lsof -i :3308  # Verify port is free; try 3309, 3310 if occupied
```

#### 1.2 Create LaunchAgent

Write to `~/Library/LaunchAgents/com.dolt.sql-server.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dolt.sql-server</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/dolt</string>
        <string>sql-server</string>
        <string>--host</string>
        <string>127.0.0.1</string>
        <string>--port</string>
        <string>3308</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/JT/dolt-data</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/JT/dolt-data/dolt-server.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/JT/dolt-data/dolt-server.log</string>
</dict>
</plist>
```

Adjust `/opt/homebrew/bin/dolt` to `/usr/local/bin/dolt` on Intel Macs.

#### 1.3 Start and Verify

```bash
launchctl load ~/Library/LaunchAgents/com.dolt.sql-server.plist
sleep 2
lsof -i :3308  # Should show dolt process
```

### Phase 2: Per-Repo Migration

#### 2.1 Back Up

```bash
BACKUP_DIR="/tmp/beads-backup-$(basename $(pwd))-$(date +%Y%m%d-%H%M%S)"
cp -R .beads "$BACKUP_DIR"
echo "Backup: $BACKUP_DIR"
```

Verify JSONL exists (source of truth for issues):

```bash
ls -la "$BACKUP_DIR"/issues.jsonl 2>/dev/null
```

Also back up worktree beads:

```bash
for wt in .git/beads-worktrees/*/; do
  [ -d "${wt}.beads" ] && cp -R "${wt}.beads" "${BACKUP_DIR}-wt-$(basename $wt)"
done
```

#### 2.2 Fresh Init

Remove `.beads` entirely and reinitialize:

```bash
rm -rf .beads
bd init --server-host 127.0.0.1 --server-port 3308
```

This creates an empty Dolt database. `bd doctor` should show 0 errors in CORE SYSTEM.

#### 2.3 Import Issues from JSONL

**CRITICAL**: `bd init --from-jsonl` is broken in v0.56.1 — it silently produces 0 issues ([#2096](https://github.com/steveyegge/beads/issues/2096)). Use the bundled import script instead.

Run the import script with the backup JSONL:

```bash
python3 <SKILL_DIR>/scripts/jsonl-to-dolt.py "$BACKUP_DIR/issues.jsonl" "beads_$(basename $(pwd))" --port 3308
```

Where `<SKILL_DIR>` is the path to this skill's directory. The database name follows the pattern `beads_<prefix>` — check with:

```bash
bd sql "SHOW DATABASES" 2>&1 | grep beads
```

Commit the import to Dolt history:

```bash
bd dolt commit -m "Import issues from JSONL backup"
```

#### 2.4 Verify

```bash
bd doctor    # Expect 0 errors in CORE SYSTEM
bd stats     # Issue counts should match backup
```

Compare counts:

```bash
BACKUP_COUNT=$(grep -c '"id"' "$BACKUP_DIR/issues.jsonl" 2>/dev/null || echo "unknown")
echo "Backup: $BACKUP_COUNT issues | Migrated: $(bd count 2>/dev/null || echo 'check bd stats')"
```

If counts don't match:

```bash
# Restore and retry: rm -rf .beads && cp -R "$BACKUP_DIR" .beads
```

#### 2.5 Cleanup

Do NOT auto-delete backups. Report location to user:

```bash
echo "Backup at: $BACKUP_DIR — remove when confident: rm -rf $BACKUP_DIR"
```

## Troubleshooting

### Port Conflict

```bash
lsof -i :3308
```

Pick a different port and update the LaunchAgent plist.

### "Access denied" After Migration

```bash
bd doctor --verbose 2>&1 | grep -i "server"
```

Ensure connection shows `127.0.0.1:3308`, not Docker host IP.

### LaunchAgent Not Starting After Reboot

```bash
launchctl list | grep dolt
launchctl load ~/Library/LaunchAgents/com.dolt.sql-server.plist
```

### Federation Warnings

Federation errors pointing to `192.168.65.x` are non-critical — they relate to remote sync, not local database.

### Connecting to Dolt Directly

Use global flags (before subcommand) with empty password:

```bash
DOLT_CLI_PASSWORD="" dolt --host 127.0.0.1 --port 3308 --user root --no-tls sql -q "SHOW DATABASES;"
```

### Something else failing?

See [GOTCHAS.md](GOTCHAS.md) for a comprehensive list of pitfalls: broken `--from-jsonl` flag, NOT NULL column defaults, `bd migrate --to-dolt` requiring CGO, dolt CLI password prompts, and more.
