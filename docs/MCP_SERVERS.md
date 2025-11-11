# MCP Server Integration Guide

Model Context Protocol (MCP) servers extend Claude Code's capabilities with additional tools and integrations.

## What are MCP Servers?

MCP servers are specialized plugins that give Claude access to external tools and services:
- **Perplexity**: Real-time web research
- **Airtable**: Project management and databases
- **Gmail**: Email automation
- **Puppeteer**: Web scraping and automation
- **Memory**: Persistent knowledge graphs
- **Obsidian**: Note-taking integration
- And many more...

## Managing MCP Servers

### List Available Servers
```bash
claude mcp list
```

### Add a Server
```bash
claude mcp add [server-name]
```

### Remove a Server
```bash
claude mcp remove [server-name]
```

### Check Server Status
```bash
# View all configured servers
cat ~/.claude/mcp.json

# Test if server is working
claude
> Use [tool-name] to test connection
```

## Recommended MCP Servers

### 1. Perplexity (Research)

**What it does**: Real-time web research with AI-powered search

**When to use**:
- Current events and news
- Technical documentation lookups
- Market research
- Fact-checking
- Competitive analysis

**Setup**:
```bash
# Install
npm install -g @perplexity/mcp-server

# Add to Claude
claude mcp add perplexity-research

# Configure API key
export PERPLEXITY_API_KEY=your-key-here
```

**Usage in Claude**:
```
> Research the latest Next.js 14 features
> What are the current best practices for React Server Components?
> Find recent benchmarks comparing PostgreSQL vs MongoDB
```

**Cost**: $20/month for Perplexity Pro API

---

### 2. Airtable (Project Management)

**What it does**: Manage databases, track projects, organize information

**When to use**:
- Project tracking
- Backlog management
- Client databases
- Structured data storage
- Task management

**Setup**:
```bash
# Install
npm install -g @airtable/mcp-server

# Add to Claude
claude mcp add airtable

# Configure API key
export AIRTABLE_TOKEN=your-token-here
```

**Usage in Claude**:
```
> Add this task to my backlog in Airtable
> Show me all active projects from Airtable
> Create a new client record in Airtable
```

**Cost**: Free tier available, paid plans start at $10/user/month

---

### 3. Puppeteer (Web Automation)

**What it does**: Browser automation, web scraping, testing

**When to use**:
- Web scraping
- Automated testing
- Screenshot capture
- Dynamic content extraction
- LinkedIn automation

**Setup**:
```bash
# Install
npm install -g @puppeteer/mcp-server

# Add to Claude
claude mcp add puppeteer
```

**Usage in Claude**:
```
> Scrape the pricing information from example.com
> Take a screenshot of the homepage
> Extract all article titles from this blog
```

**Cost**: Free (open source)

---

### 4. Gmail (Email Automation)

**What it does**: Read, send, search, and organize emails

**When to use**:
- Send automated emails
- Search email history
- Organize inbox with labels
- Track conversation threads
- Email-based workflows

**Setup**:
```bash
# Install
npm install -g @gmail/mcp-server

# Add to Claude
claude mcp add gmail

# Authenticate (opens browser)
claude mcp gmail auth
```

**Usage in Claude**:
```
> Send an email to client@example.com with proposal
> Search my emails for messages from John about the project
> Create a label for all project-related emails
```

**Cost**: Free (uses your Gmail account)

---

### 5. Memory (Knowledge Graphs)

**What it does**: Persistent knowledge graphs for long-term memory

**When to use**:
- Track client preferences
- Remember project decisions
- Store technical patterns
- Build knowledge bases
- Connect related information

**Setup**:
```bash
# Usually pre-installed with Claude Code
# Verify it's active
claude mcp list | grep memory
```

**Usage in Claude**:
```
> Remember: Client prefers TypeScript over JavaScript
> What do I know about the authentication system?
> Store this technical decision for future reference
```

**Cost**: Free (built-in)

---

### 6. Obsidian (Note-Taking)

**What it does**: Integration with Obsidian vault for knowledge management

**When to use**:
- Daily notes
- Knowledge base
- Research organization
- Personal wiki
- Zettelkasten method

**Setup**:
```bash
# Install
npm install -g @obsidian/mcp-server

# Add to Claude
claude mcp add obsidian

# Configure vault path
export OBSIDIAN_VAULT_PATH=~/Documents/ObsidianVault
```

**Usage in Claude**:
```
> Create a new note about today's standup
> Search my Obsidian vault for notes about React
> Add this to my daily note
```

**Cost**: Free (Obsidian is free for personal use)

---

## Advanced Configuration

### Custom MCP Server Configuration

Edit `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "your-key"
      }
    },
    "airtable": {
      "command": "npx",
      "args": ["-y", "@airtable/mcp-server"],
      "env": {
        "AIRTABLE_TOKEN": "your-token"
      }
    }
  }
}
```

### Security Best Practices

**Never hardcode API keys in config files.** Use environment variables:

```bash
# Add to ~/.zshrc
export PERPLEXITY_API_KEY="your-key"
export AIRTABLE_TOKEN="your-token"

# Reload shell
source ~/.zshrc
```

Or use a password manager like 1Password:
```bash
# Fetch from 1Password
export PERPLEXITY_API_KEY=$(op item get "Perplexity API" --fields credential)
```

## MCP Server Workflows

### Research Workflow (Perplexity)

```bash
> /research Cloud cost optimization strategies
# Claude uses Perplexity to gather current information
# Creates comprehensive markdown document
# Saves to ~/Documents/Projects/Research/
```

### Project Management Workflow (Airtable)

```bash
> Backlog: Add user authentication feature
# Claude creates record in Airtable
# Tags it appropriately
# Links to relevant projects
```

### Web Scraping Workflow (Puppeteer + Perplexity)

```bash
> Scrape competitor pricing from example.com and analyze trends
# Claude uses Puppeteer to extract data
# Uses Perplexity to research market context
# Creates comparative analysis document
```

### Email + Project Management (Gmail + Airtable)

```bash
> Find emails from client@example.com about Project X and create Airtable tasks
# Searches Gmail for relevant emails
# Extracts action items
# Creates tasks in Airtable with links to emails
```

## Troubleshooting

### Server Not Found
```bash
# Reinstall the server
npm install -g @[server-name]/mcp-server

# Re-add to Claude
claude mcp remove [server-name]
claude mcp add [server-name]
```

### Authentication Issues
```bash
# Check environment variables
echo $PERPLEXITY_API_KEY
echo $AIRTABLE_TOKEN

# Re-authenticate
claude mcp [server-name] auth
```

### Server Timeout
```bash
# Increase timeout in mcp.json
{
  "timeout": 60000  // 60 seconds
}
```

### Connection Errors
```bash
# Check if server is running
ps aux | grep mcp

# View server logs
tail ~/.claude/logs/mcp-*.log

# Restart Claude Code
# (Most MCP issues resolve with a restart)
```

## Building Custom MCP Servers

Want to build your own MCP server? See:
- [MCP Server SDK](https://github.com/anthropics/mcp-sdk)
- [MCP Server Examples](https://github.com/anthropics/mcp-examples)
- [MCP Documentation](https://spec.modelcontextprotocol.io/)

## Recommended Combinations

### Full-Stack Developer
- Perplexity (research)
- Puppeteer (testing)
- Gmail (client communication)
- Airtable (project tracking)

### AI Researcher
- Perplexity (research)
- Obsidian (knowledge management)
- Memory (knowledge graphs)
- Arxiv (academic papers)

### Freelancer/Consultant
- Gmail (client communication)
- Airtable (project management)
- Perplexity (research)
- Calendar (scheduling)

### Data Analyst
- Puppeteer (web scraping)
- Airtable (data organization)
- Memory (pattern tracking)
- Perplexity (research)

## Cost Summary

| MCP Server | Cost | Notes |
|------------|------|-------|
| Perplexity | $20/mo | Professional research |
| Airtable | $0-10/mo | Free tier generous |
| Puppeteer | Free | Open source |
| Gmail | Free | Uses your account |
| Memory | Free | Built-in |
| Obsidian | Free | Personal use |

**Recommended Budget**: $20-30/month for professional setup

## Next Steps

1. **Identify Your Needs**: Which tools would help your workflow?
2. **Start Small**: Add 1-2 servers first, learn them well
3. **Experiment**: Try different combinations
4. **Automate**: Create workflows combining multiple servers
5. **Share**: Document your workflows for future reference

---

**Remember**: MCP servers make Claude smarter, but you need to tell it when to use them. Include tool usage in your prompts or create slash commands that specify which tools to use.
