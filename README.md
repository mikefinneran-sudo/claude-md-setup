# Claude.md: The Complete Persistent Memory System

> Transform Claude Code into a personalized AI assistant that remembers your preferences, automates your workflows, and integrates seamlessly with your development environment.

## What is This?

This is a production-ready persistent memory system for [Claude Code](https://claude.com/claude-code) that provides:

- **Persistent Context**: Claude remembers your preferences, project structure, and workflow patterns across all sessions
- **Automated Workflows**: Pre-configured automation for backups, syncs, and scheduled tasks
- **iTerm2 Deep Integration**: Expert-level terminal optimization built into every response
- **Tool Orchestration**: Seamless integration with 15+ MCP servers and development tools
- **Smart Session Management**: Context loading, project switching, and progress tracking
- **Professional Prompt Engineering**: Battle-tested prompt templates for research, code, content, and strategy

## Why This Matters

Without this system, every Claude session starts from scratch. You spend time:
- Re-explaining your preferences and project structure
- Manually tracking tasks and context
- Repeating the same automation patterns
- Looking up commands and file locations

**With this system**, Claude becomes a true AI partner that:
- ✅ Loads your entire context in < 3 seconds
- ✅ Suggests optimal iTerm2 layouts automatically
- ✅ Remembers your coding style and project patterns
- ✅ Tracks tasks and progress across sessions
- ✅ Executes complex workflows with natural language
- ✅ Backs up your work automatically to S3

## Features

### 🧠 Persistent Memory System
- **CLAUDE.md**: Your AI's long-term memory (preferences, projects, workflows)
- **PROJECT-REGISTRY.md**: Central index of all active projects
- **WORKING-CONTEXT.md**: Current session state and progress
- **Automated S3 Backups**: Daily backups at 2 AM to AWS S3

### 🔧 Tool Integration
Pre-configured MCP servers for:
- **Perplexity**: Web research and current information
- **Airtable**: Project management and backlog tracking
- **Gmail**: Email management and automation
- **Puppeteer**: Web scraping and browser automation
- **Memory**: Knowledge graphs and entity tracking
- **Obsidian**: Note-taking and knowledge management
- And 10+ more...

### ⚡ Automation & Scheduling
Built-in LaunchAgents for:
- Daily S3 backups (2 AM)
- GitHub ↔ Airtable sync (9 AM)
- Airtable sync (every 15 minutes)
- Daily note creation
- Weekly reviews and cost tracking

### 🖥️ iTerm2 Expert Integration
Claude automatically suggests:
- Split pane layouts for development
- Triggers for build notifications
- Dynamic profiles for each project
- tmux integration for remote work
- Custom keyboard shortcuts

### 📝 Smart Templates
Pre-built slash commands for:
- `/research [topic]` - Comprehensive research documents
- `/plan-feature [description]` - TDD implementation planning
- `/code-review [file]` - Thorough code reviews
- `/optimize [file]` - Performance analysis
- `/explain-code [path]` - Architecture explanations
- `/backlog` - Quick backlog capture

### 🎯 Prompt Engineering Framework
Battle-tested 3-phase protocol:
1. **Core Protocol**: 8-component foundation (Objective, Context, Persona, Examples, Deliverables, Constraints, Reasoning, Validation)
2. **Modular Augments**: Task-specific modules (RAG, Decomposition, Style Guide, Framework)
3. **Execution Protocols**: Static (simple) vs Dynamic (complex with rejection loops)

## Quick Start

### Prerequisites
- macOS (tested on Sonoma/Sequoia)
- [Claude Code](https://claude.com/claude-code) installed
- iTerm2 (recommended, but Terminal.app works)
- AWS CLI (for S3 backups, optional)
- Homebrew (for dependencies)

### Installation

```bash
# 1. Clone this repository
git clone https://github.com/yourusername/claude-md-setup.git
cd claude-md-setup

# 2. Run the installer
./install.sh

# 3. Follow the interactive prompts to configure:
#    - Your name and email
#    - Project directories
#    - S3 backup settings (optional)
#    - MCP servers to enable
#    - Automation preferences

# 4. Start a new Claude session
claude

# 5. Verify setup
claude> Load context: What am I working on?
```

That's it! Claude now has persistent memory.

## Usage Examples

### Session Management

**Start a new session with full context:**
```bash
claude
> Load context: What am I working on?
```

**Switch between projects:**
```bash
> Continue WalterSignal - show status and next actions
```

**Save progress:**
```bash
> Update working context with today's progress
```

### Natural Language Commands

**Backlog capture:**
```bash
> Backlog: Add feature for user authentication with OAuth
```

**Research:**
```bash
> Research the latest Next.js 14 server components best practices
```

**iTerm2 optimization (automatic):**
```bash
> I need to run tests
# Claude automatically suggests: "Let me set up a split pane - code on left, test watcher on right..."
```

### Slash Commands

```bash
> /plan-feature User profile with avatar upload
> /code-review src/components/UserProfile.tsx
> /optimize src/utils/dataProcessor.ts
> /research GraphQL vs REST for mobile apps
> /backlog
```

### Alfred Snippets (Optional)

Type these anywhere:
- `;ctx` → Loads session context
- `;save` → Saves progress
- `;weekly` → Weekly review
- `;backlog` → Add to backlog

## Architecture

```
~/.claude/
├── CLAUDE.md                    # Main memory file (auto-loads every session)
├── WORKING-CONTEXT.md           # Current session state
├── PROJECT-REGISTRY.md          # Project index
├── AUTOMATION_LOCATIONS.md      # All scheduled tasks
├── commands/                    # Slash commands
│   ├── research.md
│   ├── plan-feature.md
│   ├── code-review.md
│   └── ...
├── scripts/                     # Automation scripts
│   ├── backup-to-s3.sh
│   ├── github-airtable-sync.py
│   ├── start-session.sh
│   └── ...
├── logs/                        # Automation logs
└── templates/                   # Document templates

~/Documents/ObsidianVault/      # Primary work hub
├── Projects/                    # All active projects
├── Daily Notes/                 # Daily work logs
├── Research/                    # Research documents
└── Archive/                     # Completed projects

~/Library/LaunchAgents/          # Scheduled automations
├── com.claude.s3-backup.plist
├── com.claude.github-sync.plist
└── com.claude.airtable-sync.plist
```

## Configuration

### Core Files

**CLAUDE.md** - Main memory (auto-loads)
- User profile and preferences
- Current week focus
- Project locations
- Tool integrations
- Custom commands
- Coding style preferences

**PROJECT-REGISTRY.md** - Project index
- All active projects
- Status and progress
- Key files and commands
- Team members (if applicable)

**WORKING-CONTEXT.md** - Session state
- Current task
- Recent progress
- Open questions/blockers
- Next actions

### Customization

Edit `~/.claude/CLAUDE.md` to customize:

```markdown
## User Profile
- Name: [Your Name]
- Primary Use Case: [Your primary use case]
- Primary Email: [your.email@example.com]

## Current Week Focus
**Week of**: 2025-11-XX
**Primary Project**: [Current project]
**Status**: [Current status]

## Default File Locations
- Primary Storage: [Your main directory]
- Projects: [Projects directory]
- Backups: [Backup location]
```

## Advanced Features

### S3 Backup Automation

Automatically backs up:
- All `.claude/` files
- `ObsidianVault/` (configurable)
- Automation logs
- Project files (selective)

**Setup:**
```bash
# Configure AWS credentials
aws configure

# Set S3 bucket
export S3_BACKUP_BUCKET=your-bucket-name

# Test backup
~/.claude/scripts/backup-to-s3.sh

# Enable daily automation (2 AM)
launchctl load ~/Library/LaunchAgents/com.claude.s3-backup.plist
```

**Restore:**
```bash
restore-s3
# Select backup date from interactive menu
```

### MCP Server Integration

Enable additional MCP servers:

```bash
# Add Perplexity for research
claude mcp add perplexity-research

# Add Puppeteer for web scraping
claude mcp add puppeteer

# Add Airtable for project management
claude mcp add airtable

# List all available servers
claude mcp list
```

### iTerm2 Enhanced Integration

**Setup complete iTerm2 integration:**
```bash
~/.claude/scripts/iterm-complete-setup.sh
```

This configures:
- Dynamic profiles for each project
- Custom triggers for notifications
- Status bar with git/npm/python info
- Smart keyboard shortcuts
- Shell integration

**Documentation:** `~/.config/iterm2/EXPERT_GUIDE.md`

### GitHub ↔ Airtable Sync

Automatically sync your GitHub repos to Airtable for unified project management:

```bash
# Manual sync
github-sync

# Check status
github-sync-status

# View logs
github-sync-logs

# Runs automatically daily at 9 AM
```

## Troubleshooting

### Context Not Loading

```bash
# Verify CLAUDE.md exists
cat ~/.claude/CLAUDE.md | wc -l

# Check file size (should be 500-700 lines)
du -h ~/.claude/CLAUDE.md

# Restore from backup if needed
restore-s3
```

### Automations Not Running

```bash
# List all LaunchAgents
launchctl list | grep -E "claude|com\."

# Check specific automation
launchctl list | grep s3-backup

# View logs
tail ~/.claude/logs/s3-backup.log
```

### Slow Load Times

```bash
# Check CLAUDE.md size
wc -l ~/.claude/CLAUDE.md

# Archive old content if > 700 lines
mkdir -p ~/Documents/ObsidianVault/Archive/$(date +%Y-%m)
# Move old sections to archive

# Verify performance
time cat ~/.claude/CLAUDE.md > /dev/null
```

### MCP Server Issues

```bash
# List all MCP servers
claude mcp list

# Remove and re-add problematic server
claude mcp remove [server-name]
claude mcp add [server-name]

# Check logs
tail ~/.claude/logs/mcp-*.log
```

## Performance

- **Load time**: < 3 seconds for full context
- **Memory usage**: ~5000 tokens (2.5% of 200K window)
- **Session startup**: < 1 second
- **Backup size**: ~5-50 MB (configurable)

## Best Practices

### Session Management
1. **Start every session with context load**: "Load context: What am I working on?"
2. **Update working context regularly**: Save progress after major milestones
3. **Weekly reviews**: Update current week focus every Monday
4. **Clean up**: Archive completed projects monthly

### File Organization
1. **One source of truth**: ObsidianVault for all work
2. **Clear naming**: Use date prefixes (YYYY-MM-DD - Description - vN)
3. **Version control**: Git commit regularly
4. **Backups**: Verify S3 backups weekly

### Tool Usage
1. **MCP first**: Use MCP tools before bash commands when available
2. **Parallel operations**: Run independent tasks in parallel
3. **Context-aware**: Reference files with `@filename` for clarity
4. **Screenshots**: Use visual feedback for UI work (Cmd+Ctrl+Shift+4)

### Security
1. **Never commit secrets**: Use 1Password, not CLAUDE.md
2. **Sanitize sharing**: Remove emails, API keys, personal data
3. **Rotate credentials**: Quarterly rotation for all API keys
4. **Backup encryption**: Use AWS KMS for S3 backups (optional)

## Maintenance

### Weekly
- [ ] Review current week focus
- [ ] Update PROJECT-REGISTRY.md
- [ ] Archive completed projects
- [ ] Check automation logs

### Monthly
- [ ] Clean up old backups (S3)
- [ ] Review and archive old projects
- [ ] Update CLAUDE.md (remove stale info)
- [ ] Check for MCP server updates

### Quarterly
- [ ] Rotate API credentials
- [ ] Review automation effectiveness
- [ ] Update documentation
- [ ] Backup to external drive (redundancy)

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes thoroughly
4. Update documentation
5. Submit a pull request

**Areas for contribution:**
- Additional MCP server integrations
- Windows/Linux support
- VSCode integration
- Automation improvements
- Documentation enhancements

## FAQ

**Q: Does this work with Windows/Linux?**
A: Core functionality yes, but automation scripts are macOS-specific (LaunchAgents). PRs welcome for cross-platform support!

**Q: How much does this cost?**
A: The system is free. Optional costs: AWS S3 (~$1-5/month), MCP servers (Perplexity Pro: $20/month), Claude Pro (if using web version).

**Q: Is my data private?**
A: Yes. Everything runs locally. MCP servers only access what you explicitly allow. S3 backups are in your private bucket.

**Q: Can I use this with other AI assistants?**
A: The CLAUDE.md structure works with any AI that supports persistent context files. Automation is Claude Code-specific.

**Q: How do I update?**
A: `git pull origin main && ./install.sh` (preserves your customizations)

**Q: Can I share my setup publicly?**
A: Yes! Use `./scripts/sanitize-for-sharing.sh` to remove sensitive data first.

## Changelog

**v1.0.0** (2025-11-XX)
- Initial public release
- Complete persistent memory system
- S3 backup automation
- MCP server integrations
- iTerm2 expert integration
- Prompt engineering framework
- Comprehensive documentation

## License

MIT License - See LICENSE file for details

## Acknowledgments

- Anthropic for Claude Code
- iTerm2 team for the amazing terminal
- MCP community for server integrations
- Everyone who contributed ideas and feedback

## Support

- **Documentation**: [/docs](/docs)
- **Issues**: [GitHub Issues](https://github.com/yourusername/claude-md-setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claude-md-setup/discussions)

---

**Made with ❤️ for the Claude Code community**

*Stop starting from scratch. Let Claude remember.*
