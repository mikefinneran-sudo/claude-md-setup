# Quick Start Guide

Get up and running with Claude.md in 5 minutes.

## Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/claude-md-setup.git
cd claude-md-setup

# 2. Run the installer
./install.sh

# 3. Follow the prompts
```

The installer will ask you for:
- Your name and email
- Primary workspace directory (default: `~/Documents/Projects`)
- Whether to enable S3 backups (optional)
- S3 bucket name (if enabling backups)

## First Session

```bash
# Start Claude Code
claude

# Load your context
> Load context: What am I working on?
```

Claude will now remember:
- Your preferences and workflow
- Project structure
- Custom commands
- Development patterns

## Essential Commands

### Natural Language
```bash
# Add something to your backlog
> Backlog: Implement user authentication

# Research a topic
> Research the latest React Server Components patterns

# Get project status
> Show me the status of all my projects
```

### Slash Commands
```bash
# Plan a feature with TDD
> /plan-feature User profile with avatar upload

# Review code
> /code-review src/components/UserProfile.tsx

# Optimize performance
> /optimize src/utils/dataProcessor.ts

# Capture to backlog
> /backlog
```

### Shell Aliases
```bash
# Quick Claude Code access
c              # Start new session
cc             # Continue last session

# Backups
backup-s3      # Manual backup to S3
restore-s3     # Restore from S3

# Configuration
claude-config  # Edit CLAUDE.md
claude-status  # View current context

# Navigation
projects       # cd to your projects directory
```

## Key Files

```
~/.claude/
├── CLAUDE.md                   # Your AI's memory (auto-loads)
├── WORKING-CONTEXT.md          # Current session state
├── PROJECT-REGISTRY.md         # All your projects
└── AUTOMATION_LOCATIONS.md     # Scheduled tasks
```

## Customization

### Edit Your Memory
```bash
# Open CLAUDE.md
claude-config

# Or directly
open ~/.claude/CLAUDE.md
```

Edit these sections:
- **User Profile**: Your name, email, use case
- **Current Week Focus**: What you're working on this week
- **Active Projects**: Your current projects
- **Custom Commands**: Your frequently used commands

### Add a Project

Edit `~/.claude/PROJECT-REGISTRY.md`:

```markdown
### My New Project
- **Status**: Active
- **Location**: ~/Documents/Projects/my-project
- **Description**: Full-stack web application
- **Last Updated**: 2025-11-XX
- **Key Files**:
  - src/index.ts - Entry point
  - tests/ - Test suite
```

### Create a Slash Command

Create `~/.claude/commands/my-command.md`:

```markdown
# My Custom Command

Brief description of what this command does.

## Task
{{ARG_1}}

## Instructions
1. Step one
2. Step two
3. Step three

## Deliverable
What should be produced
```

Use it:
```bash
> /my-command some argument
```

## iTerm2 Integration (Optional)

If you use iTerm2, Claude can automatically optimize your workflow:

```bash
# Set up complete iTerm2 integration
~/.claude/scripts/iterm-complete-setup.sh
```

This adds:
- Split pane layouts for development
- Triggers for build notifications
- Dynamic profiles per project
- Status bar with git/npm info

Claude will now automatically suggest:
- "Want me to set up a split pane layout?"
- "I'll trigger a notification when the build completes"
- "Let's create a dynamic profile for this project"

## S3 Backups (Optional)

If you enabled S3 backups during installation:

```bash
# Manual backup
backup-s3

# Restore from backup
restore-s3
# (Select from interactive menu)

# Check backup logs
tail ~/.claude/logs/s3-backup.log

# Verify automation
launchctl list | grep claude-s3-backup
```

Backups run automatically every day at 2 AM.

## MCP Servers (Optional)

Add additional capabilities:

```bash
# List available MCP servers
claude mcp list

# Add Perplexity for research
claude mcp add perplexity-research

# Add Puppeteer for web scraping
claude mcp add puppeteer

# Add Airtable for project management
claude mcp add airtable
```

## Best Practices

### 1. Start Every Session with Context
```bash
> Load context: What am I working on?
```

### 2. Update Your Focus Weekly
Edit `CLAUDE.md` every Monday:
```markdown
## Current Week Focus
**Week of**: 2025-11-XX
**Primary Project**: [Your main focus]
**Next Actions**:
- [ ] Action item 1
- [ ] Action item 2
```

### 3. Save Progress Regularly
```bash
> Update working context with today's progress
```

### 4. Use Slash Commands for Repetitive Tasks
Instead of explaining the same thing every time:
```bash
# ❌ Don't do this
> Can you review this code for security issues, performance, readability...

# ✅ Do this
> /code-review src/auth/login.ts
```

### 5. Reference Files with @
```bash
> Improve the error handling in @src/api/users.ts
```

## Troubleshooting

### Context Not Loading
```bash
# Verify CLAUDE.md exists
cat ~/.claude/CLAUDE.md | head -10

# Check file size (should be 500-700 lines)
wc -l ~/.claude/CLAUDE.md

# Restore from backup if needed
restore-s3
```

### Slash Commands Not Working
```bash
# Check commands directory
ls ~/.claude/commands/

# Reinstall commands
cp commands/* ~/.claude/commands/
```

### Aliases Not Working
```bash
# Reload shell config
source ~/.zshrc  # or ~/.bashrc

# Check if aliases exist
grep "claude" ~/.zshrc
```

### S3 Backups Failing
```bash
# Check AWS credentials
aws s3 ls

# View error logs
tail ~/.claude/logs/s3-backup-error.log

# Test manual backup
backup-s3
```

## Next Steps

1. **Customize CLAUDE.md**: Add your projects, preferences, and workflows
2. **Create Project Registry**: Document all your active projects
3. **Set Up MCP Servers**: Add tools you use regularly
4. **Configure iTerm2**: If you use iTerm2, set up the integration
5. **Create Custom Commands**: Build slash commands for your workflows

## Getting Help

- **Documentation**: `docs/` directory
- **Examples**: `examples/` directory
- **Issues**: [GitHub Issues](https://github.com/yourusername/claude-md-setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claude-md-setup/discussions)

## What's Next?

Read the full documentation:
- [Complete Setup Guide](SETUP.md)
- [iTerm2 Integration](ITERM2_SETUP.md)
- [MCP Server Guide](MCP_SERVERS.md)
- [Advanced Customization](CUSTOMIZATION.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)

---

**You're all set!** Claude now has persistent memory and will remember your preferences across all sessions.
