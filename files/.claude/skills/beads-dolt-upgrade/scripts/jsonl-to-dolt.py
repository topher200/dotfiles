#!/usr/bin/env python3
"""
Import beads issues from a JSONL file into a Dolt database via SQL.

Usage:
    python3 scripts/jsonl-to-dolt.py <jsonl_path> <database_name> [--host HOST] [--port PORT] [--user USER]

Requirements:
    - dolt CLI installed (brew install dolt)
    - Dolt server running on specified host:port

The script:
    1. Reads issues from the JSONL file
    2. Generates SQL INSERT statements with all required NOT NULL fields
    3. Imports dependencies from the same JSONL
    4. Pipes everything through `dolt sql` connected to the server
    5. Reports counts for verification
"""

import json
import subprocess
import sys
import tempfile
import os


def esc(v):
    """Escape a value for SQL insertion."""
    if v is None:
        return "NULL"
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


def truncate_datetime(v):
    """Extract YYYY-MM-DDTHH:MM:SS from an ISO datetime string."""
    if not v:
        return None
    return v[:19]


def generate_sql(jsonl_path, database_name):
    """Generate SQL statements from a JSONL file. Returns (sql_string, issue_count, dep_count)."""
    with open(jsonl_path) as f:
        lines = f.readlines()

    statements = [f"USE `{database_name}`;"]
    issue_count = 0
    dep_count = 0

    for line in lines:
        line = line.strip()
        if not line:
            continue
        d = json.loads(line)

        # Insert issue with all NOT NULL fields defaulted
        sql = (
            f"INSERT IGNORE INTO issues "
            f"(id, title, description, design, acceptance_criteria, notes, "
            f"status, priority, issue_type, owner, created_at, created_by, "
            f"updated_at, closed_at, close_reason) VALUES ("
            f"{esc(d.get('id'))}, "
            f"{esc(d.get('title'))}, "
            f"{esc(d.get('description', ''))}, "
            f"'', '', '', "
            f"{esc(d.get('status'))}, "
            f"{d.get('priority', 2)}, "
            f"{esc(d.get('issue_type', 'task'))}, "
            f"{esc(d.get('owner', ''))}, "
            f"{esc(truncate_datetime(d.get('created_at', '')))}, "
            f"{esc(d.get('created_by', ''))}, "
            f"{esc(truncate_datetime(d.get('updated_at', '')))}, "
            f"{esc(truncate_datetime(d.get('closed_at')))}, "
            f"{esc(d.get('close_reason', ''))}"
            f");"
        )
        statements.append(sql)
        issue_count += 1

        # Insert dependencies
        for dep in d.get("dependencies", []):
            dep_sql = (
                f"INSERT IGNORE INTO dependencies "
                f"(issue_id, depends_on_id, type, created_at, created_by) VALUES ("
                f"{esc(dep.get('issue_id'))}, "
                f"{esc(dep.get('depends_on_id'))}, "
                f"{esc(dep.get('type', 'blocks'))}, "
                f"{esc(truncate_datetime(dep.get('created_at', '')))}, "
                f"{esc(dep.get('created_by', ''))}"
                f");"
            )
            statements.append(dep_sql)
            dep_count += 1

    return "\n".join(statements), issue_count, dep_count


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <jsonl_path> <database_name> [--host HOST] [--port PORT] [--user USER]")
        print(f"Example: {sys.argv[0]} /tmp/backup/issues.jsonl beads_my-project --port 3308")
        sys.exit(1)

    jsonl_path = sys.argv[1]
    database_name = sys.argv[2]

    # Parse optional flags
    host = "127.0.0.1"
    port = "3308"
    user = "root"
    i = 3
    while i < len(sys.argv):
        if sys.argv[i] == "--host" and i + 1 < len(sys.argv):
            host = sys.argv[i + 1]
            i += 2
        elif sys.argv[i] == "--port" and i + 1 < len(sys.argv):
            port = sys.argv[i + 1]
            i += 2
        elif sys.argv[i] == "--user" and i + 1 < len(sys.argv):
            user = sys.argv[i + 1]
            i += 2
        else:
            print(f"Unknown argument: {sys.argv[i]}")
            sys.exit(1)

    if not os.path.exists(jsonl_path):
        print(f"Error: JSONL file not found: {jsonl_path}")
        sys.exit(1)

    print(f"Generating SQL from {jsonl_path}...")
    sql, issue_count, dep_count = generate_sql(jsonl_path, database_name)

    print(f"Generated {issue_count} issue INSERTs and {dep_count} dependency INSERTs")

    # Write SQL to temp file
    with tempfile.NamedTemporaryFile(mode="w", suffix=".sql", delete=False) as f:
        f.write(sql)
        sql_path = f.name

    try:
        print(f"Importing via dolt sql (server {host}:{port})...")
        env = os.environ.copy()
        env["DOLT_CLI_PASSWORD"] = ""
        result = subprocess.run(
            ["dolt", "--host", host, "--port", port, "--user", user, "--no-tls", "sql", "-b"],
            stdin=open(sql_path),
            capture_output=True,
            text=True,
            env=env,
        )

        if result.returncode != 0:
            print(f"Error during import:\n{result.stderr}")
            # Show the first error line for debugging
            for line in result.stderr.split("\n"):
                if "Error" in line:
                    print(f"  -> {line.strip()}")
                    break
            sys.exit(1)

        print(f"Import complete: {issue_count} issues, {dep_count} dependencies")
    finally:
        os.unlink(sql_path)


if __name__ == "__main__":
    main()
