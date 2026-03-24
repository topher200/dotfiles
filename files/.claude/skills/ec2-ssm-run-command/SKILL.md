---
name: ec2-ssm-run-command
description: Log into a memfault-prod EC2 instance by name and run shell commands via AWS SSM
argument-hint: <INSTANCE_NAME> <command to run>
allowed-tools: Bash(aws-vault *), Bash(aws *)
---

# EC2 SSM Command Runner

Run shell commands on a memfault-prod EC2 instance identified by its `Name` tag, using AWS SSM (no SSH required).

## Usage

```
/ec2-ssm-run-command <INSTANCE_NAME> <command>
```

Examples:

```
/ec2-ssm-run-command coolify-production-public sudo docker ps
/ec2-ssm-run-command coolify-production-public "sudo docker logs my-container --tail 50"
```

## How It Works

AWS SSM `send-command` sends a shell command to the instance and returns a command ID. Then `get-command-invocation` retrieves the output. This avoids needing SSH keys or open inbound ports.

The AWS profile used is `memfault-prod` via `aws-vault`.

## Task

Given `$INSTANCE_NAME` and `$COMMAND` from the user's arguments:

### Step 1 — Resolve the instance ID

```bash
INSTANCE_ID=$(aws-vault exec memfault-prod -- aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=running" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text)
```

If the result is `None` or empty, report that no running instance was found with that name and stop.

### Step 2 — Send the command

Use single-quoted JSON to avoid quoting issues with special characters in `$COMMAND`:

```bash
COMMAND_ID=$(aws-vault exec memfault-prod -- aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters '{"commands":["'"$COMMAND"'"]}' \
  --query 'Command.CommandId' \
  --output text)
```

### Step 3 — Wait briefly, then fetch output

Wait ~2 seconds for the command to complete, then:

```bash
aws-vault exec memfault-prod -- aws ssm get-command-invocation \
  --command-id "$COMMAND_ID" \
  --instance-id "$INSTANCE_ID" \
  --query '[Status, StandardOutputContent, StandardErrorContent]' \
  --output json
```

### Step 4 — Present results

The query returns `[Status, stdout, stderr]`. Show the user:

- `Status` (Success / Failed / TimedOut)
- `StandardOutputContent` (stdout)
- `StandardErrorContent` (stderr, if non-empty)

If status is not `Success`, highlight the error clearly.

## Notes

- Commands run as `root` on the instance (SSM agent runs as root by default on Amazon Linux/Ubuntu).
- For commands that take longer than a few seconds, you may need to poll `get-command-invocation` until `Status` is no longer `InProgress`.
- For interactive tasks (e.g. `docker exec -it`), use the interactive session method instead:
  ```bash
  aws-vault exec memfault-prod -- aws ssm start-session --target $INSTANCE_ID
  ```
  This opens a terminal session but cannot be used non-interactively from Claude Code.
- Avoid running destructive commands without user confirmation.
