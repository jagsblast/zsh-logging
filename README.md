# zsh-session-logger

A clean and practical Zsh configuration for per-session logging of all shell commands and their output, useful for:

- Security audits
- Research journaling
- Capture-the-flag (CTF) sessions
- Forensics
- Teaching/demos

This setup logs both:
- Every command typed (with timestamp)
- All stdout + stderr output, including from SSH, reverse shells, and system binaries

-------------------------------------------------------------------------------

Features

- Full-session tee logging with stdout and stderr
- Per-day log rotation (~/.cmd_logs/zsh_session_YYYY-MM-DD.log)
- Helper commands:
  - zlog – view full log with ANSI & control chars stripped
  - zlogtail – clean tail of recent log lines
  - logwrap – wrap any command (like ssh) for a fully recorded TTY session
- Automatic command history timestamps
- Toggle logging off/on with disable_logging / enable_logging

-------------------------------------------------------------------------------

Known Character Issue and Fix

Problem:
You may notice weird characters like this in comments:

<E2><80><94><E2><80><94><E2><80><94>

This happens when copying/pasting from editors like VSCode or websites that replace regular hyphens (-) with em dashes (—, Unicode U+2014, UTF-8: E2 80 94).

-------------------------------------------------------------------------------

Installation

1. Backup your current .zshrc:
   cp ~/.zshrc ~/.zshrc.backup

2. Copy the contents of zshrc from this repo to your ~/.zshrc.

3. Reload Zsh:
   source ~/.zshrc

-------------------------------------------------------------------------------

Log Directory

Logs are stored by default in:
~/.cmd_logs/zsh_session_YYYY-MM-DD.log

-------------------------------------------------------------------------------

Log Viewing Commands

Command     | Description
------------|----------------------------------------------------
zlog        | View full cleaned log in less
zlogtail    | Tail the last 20 lines of the cleaned log
logwrap     | Fully wrap a command and save output to a log file

-------------------------------------------------------------------------------

Security Note

This will log everything including:
- Commands
- Password prompts
- Session content

Use with care in multi-user environments or when handling sensitive data.

-------------------------------------------------------------------------------

Example Usage

ssh root@target.host      # Will be logged
logwrap ssh root@host     # Will be logged + all output recorded
cat secret.txt            # Will be logged
zlogtail                  # View recent commands/output

-------------------------------------------------------------------------------
