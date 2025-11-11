#!/bin/bash

# Claude.md Setup - Installation Script
# Installs persistent memory system for Claude Code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"

    # Check if macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warning "This installer is optimized for macOS. Some features may not work on other platforms."
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Check if Claude Code is installed
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code CLI not found. Please install it first:"
        echo "  Visit: https://claude.com/claude-code"
        exit 1
    fi
    print_success "Claude Code CLI found"

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git not found. Please install it first."
        exit 1
    fi
    print_success "Git found"

    # Check for iTerm2 (optional but recommended)
    if [[ -d "/Applications/iTerm.app" ]]; then
        print_success "iTerm2 found"
    else
        print_warning "iTerm2 not found (optional but recommended)"
    fi

    # Check for AWS CLI (optional)
    if command -v aws &> /dev/null; then
        print_success "AWS CLI found (for S3 backups)"
    else
        print_info "AWS CLI not found (optional - needed for S3 backups)"
    fi
}

# Collect user configuration
collect_config() {
    print_header "Configuration"

    # Name
    read -p "Your name: " USER_NAME
    while [[ -z "$USER_NAME" ]]; do
        print_error "Name cannot be empty"
        read -p "Your name: " USER_NAME
    done

    # Email
    read -p "Your email: " USER_EMAIL
    while [[ -z "$USER_EMAIL" ]]; do
        print_error "Email cannot be empty"
        read -p "Your email: " USER_EMAIL
    done

    # Primary use case
    read -p "Primary use case (e.g., 'Full-stack development', 'AI research'): " USER_USE_CASE
    USER_USE_CASE=${USER_USE_CASE:-"Software development"}

    # Primary workspace
    read -p "Primary workspace directory (default: ~/Documents/Projects): " WORKSPACE_DIR
    WORKSPACE_DIR=${WORKSPACE_DIR:-"$HOME/Documents/Projects"}

    # Expand tilde
    WORKSPACE_DIR="${WORKSPACE_DIR/#\~/$HOME}"

    # Create workspace if it doesn't exist
    if [[ ! -d "$WORKSPACE_DIR" ]]; then
        mkdir -p "$WORKSPACE_DIR"
        print_success "Created workspace directory: $WORKSPACE_DIR"
    fi

    # S3 Backup
    read -p "Enable S3 backups? (y/n): " ENABLE_S3
    if [[ $ENABLE_S3 =~ ^[Yy]$ ]]; then
        read -p "S3 bucket name: " S3_BUCKET
        while [[ -z "$S3_BUCKET" ]]; do
            print_error "Bucket name cannot be empty"
            read -p "S3 bucket name: " S3_BUCKET
        done
    fi

    echo -e "\n${GREEN}Configuration complete!${NC}\n"
}

# Create directory structure
create_directories() {
    print_header "Creating Directory Structure"

    mkdir -p ~/.claude/{scripts,logs,commands,templates,backups}
    print_success "Created ~/.claude directory structure"

    mkdir -p "$WORKSPACE_DIR"/{Projects,Archive}
    print_success "Created workspace directories"

    # Create config directory for iTerm2 (if iTerm2 exists)
    if [[ -d "/Applications/iTerm.app" ]]; then
        mkdir -p ~/.config/iterm2
        print_success "Created iTerm2 config directory"
    fi
}

# Install CLAUDE.md
install_claude_md() {
    print_header "Installing CLAUDE.md"

    # Backup existing CLAUDE.md if it exists
    if [[ -f ~/.claude/CLAUDE.md ]]; then
        BACKUP_FILE=~/.claude/CLAUDE.md.backup-$(date +%Y%m%d-%H%M%S)
        cp ~/.claude/CLAUDE.md "$BACKUP_FILE"
        print_warning "Backed up existing CLAUDE.md to $BACKUP_FILE"
    fi

    # Copy and customize template
    cp templates/CLAUDE.md.template ~/.claude/CLAUDE.md

    # Replace placeholders
    sed -i '' "s/\[YOUR_NAME\]/$USER_NAME/g" ~/.claude/CLAUDE.md
    sed -i '' "s/\[YOUR_EMAIL\]/$USER_EMAIL/g" ~/.claude/CLAUDE.md
    sed -i '' "s/\[YOUR_PRIMARY_USE_CASE\]/$USER_USE_CASE/g" ~/.claude/CLAUDE.md
    sed -i '' "s|\[YOUR_HUB\]|$WORKSPACE_DIR|g" ~/.claude/CLAUDE.md
    sed -i '' "s/\[YYYY-MM-DD\]/$(date +%Y-%m-%d)/g" ~/.claude/CLAUDE.md

    # Add S3 bucket if configured
    if [[ $ENABLE_S3 =~ ^[Yy]$ ]]; then
        sed -i '' "s/\[YOUR_BUCKET\]/$S3_BUCKET/g" ~/.claude/CLAUDE.md
    fi

    print_success "Installed CLAUDE.md"
}

# Install support files
install_support_files() {
    print_header "Installing Support Files"

    # Create WORKING-CONTEXT.md
    cat > ~/.claude/WORKING-CONTEXT.md << 'EOF'
# Working Context

## Current Session
**Started**: [DATE]
**Project**: [PROJECT_NAME]
**Goal**: [SESSION_GOAL]

## Recent Progress
- [PROGRESS_ITEM_1]
- [PROGRESS_ITEM_2]

## Next Actions
- [ ] [ACTION_1]
- [ ] [ACTION_2]

## Blockers/Questions
- [BLOCKER_1]

## Notes
[SESSION_NOTES]
EOF
    print_success "Created WORKING-CONTEXT.md"

    # Create PROJECT-REGISTRY.md
    cat > ~/.claude/PROJECT-REGISTRY.md << 'EOF'
# Project Registry

## Active Projects

### [Project Name]
- **Status**: Active
- **Location**: [path]
- **Description**: [description]
- **Last Updated**: [date]
- **Key Files**: [files]

## Archived Projects

### [Old Project]
- **Archived**: [date]
- **Location**: [archive path]
EOF
    print_success "Created PROJECT-REGISTRY.md"

    # Create AUTOMATION_LOCATIONS.md
    cat > ~/.claude/AUTOMATION_LOCATIONS.md << 'EOF'
# Automation Locations

## LaunchAgents
Location: ~/Library/LaunchAgents/

### Active Automations
- **S3 Backups**: com.user.claude-s3-backup.plist
  - Schedule: Daily 2:00 AM
  - Script: ~/.claude/scripts/backup-to-s3.sh
  - Logs: ~/.claude/logs/s3-backup.log

## Cron Jobs
Run `crontab -l` to view

## Manual Scripts
Location: ~/.claude/scripts/

### Available Scripts
- backup-to-s3.sh - Manual S3 backup
- restore-from-s3.sh - Restore from S3
EOF
    print_success "Created AUTOMATION_LOCATIONS.md"
}

# Install scripts
install_scripts() {
    print_header "Installing Scripts"

    # Copy all scripts from scripts/ directory
    if [[ -d scripts ]]; then
        cp -r scripts/* ~/.claude/scripts/
        chmod +x ~/.claude/scripts/*.sh
        print_success "Installed scripts to ~/.claude/scripts/"
    fi

    # Create basic backup script if S3 is enabled
    if [[ $ENABLE_S3 =~ ^[Yy]$ ]]; then
        cat > ~/.claude/scripts/backup-to-s3.sh << EOF
#!/bin/bash
# S3 Backup Script for Claude.md system

BACKUP_BUCKET="$S3_BUCKET"
BACKUP_PREFIX="claude-backups"
TIMESTAMP=\$(date +%Y-%m-%d_%H-%M-%S)

echo "[\$(date)] Starting backup to s3://\$BACKUP_BUCKET/\$BACKUP_PREFIX/"

# Backup .claude directory
tar -czf /tmp/claude-backup-\$TIMESTAMP.tar.gz -C ~ .claude

# Upload to S3
aws s3 cp /tmp/claude-backup-\$TIMESTAMP.tar.gz s3://\$BACKUP_BUCKET/\$BACKUP_PREFIX/

# Cleanup
rm /tmp/claude-backup-\$TIMESTAMP.tar.gz

echo "[\$(date)] Backup complete"
EOF
        chmod +x ~/.claude/scripts/backup-to-s3.sh
        print_success "Created S3 backup script"
    fi
}

# Install slash commands
install_slash_commands() {
    print_header "Installing Slash Commands"

    # Copy slash commands
    if [[ -d commands ]]; then
        cp -r commands/* ~/.claude/commands/
        print_success "Installed slash commands"
    fi
}

# Setup shell aliases
setup_shell_aliases() {
    print_header "Setting Up Shell Aliases"

    SHELL_RC="$HOME/.zshrc"
    if [[ -f "$HOME/.bashrc" ]]; then
        SHELL_RC="$HOME/.bashrc"
    fi

    # Check if aliases already exist
    if grep -q "# Claude.md aliases" "$SHELL_RC" 2>/dev/null; then
        print_info "Aliases already configured in $SHELL_RC"
        return
    fi

    cat >> "$SHELL_RC" << 'EOF'

# Claude.md aliases
alias backup-s3='~/.claude/scripts/backup-to-s3.sh'
alias restore-s3='~/.claude/scripts/restore-from-s3.sh'
alias claude-status='cat ~/.claude/WORKING-CONTEXT.md'
alias claude-config='$EDITOR ~/.claude/CLAUDE.md'
alias projects='cd ~/Documents/Projects'

# Quick Claude Code starter
alias c='claude'
alias cc='claude -c'
EOF

    print_success "Added aliases to $SHELL_RC"
    print_info "Run 'source $SHELL_RC' to load aliases"
}

# Setup LaunchAgent for S3 backup
setup_launchagent() {
    if [[ ! $ENABLE_S3 =~ ^[Yy]$ ]]; then
        return
    fi

    print_header "Setting Up Automated Backups"

    PLIST_FILE="$HOME/Library/LaunchAgents/com.claude.s3-backup.plist"

    cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.s3-backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.claude/scripts/backup-to-s3.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$HOME/.claude/logs/s3-backup.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.claude/logs/s3-backup-error.log</string>
</dict>
</plist>
EOF

    # Load LaunchAgent
    launchctl load "$PLIST_FILE"

    print_success "Configured daily S3 backups at 2:00 AM"
}

# Final setup
final_setup() {
    print_header "Final Setup"

    # Initialize git in workspace if not already initialized
    if [[ ! -d "$WORKSPACE_DIR/.git" ]]; then
        cd "$WORKSPACE_DIR"
        git init
        git add .
        git commit -m "Initial commit - Claude.md setup" 2>/dev/null || true
        print_success "Initialized git in workspace"
    fi

    print_success "Installation complete!"
}

# Print summary
print_summary() {
    print_header "Installation Summary"

    echo -e "${GREEN}Claude.md persistent memory system is now installed!${NC}\n"

    echo "📁 Configuration:"
    echo "   CLAUDE.md: ~/.claude/CLAUDE.md"
    echo "   Workspace: $WORKSPACE_DIR"
    echo "   Scripts: ~/.claude/scripts/"
    echo ""

    echo "🚀 Quick Start:"
    echo "   1. Start a new Claude session: ${BLUE}claude${NC}"
    echo "   2. Load your context: ${BLUE}Load context: What am I working on?${NC}"
    echo "   3. Start coding!"
    echo ""

    echo "📚 Documentation:"
    echo "   README: $(pwd)/README.md"
    echo "   Examples: $(pwd)/examples/"
    echo ""

    if [[ $ENABLE_S3 =~ ^[Yy]$ ]]; then
        echo "☁️  S3 Backups:"
        echo "   Bucket: s3://$S3_BUCKET/claude-backups/"
        echo "   Schedule: Daily at 2:00 AM"
        echo "   Manual: ${BLUE}backup-s3${NC}"
        echo ""
    fi

    echo "⚙️  Next Steps:"
    echo "   1. Review and customize ~/.claude/CLAUDE.md"
    echo "   2. Add your projects to PROJECT-REGISTRY.md"
    echo "   3. Configure MCP servers: ${BLUE}claude mcp list${NC}"
    if [[ -d "/Applications/iTerm.app" ]]; then
        echo "   4. Set up iTerm2 integration: ${BLUE}docs/ITERM2_SETUP.md${NC}"
    fi
    echo ""

    echo -e "${YELLOW}Don't forget to reload your shell:${NC}"
    if [[ -f "$HOME/.zshrc" ]]; then
        echo "   ${BLUE}source ~/.zshrc${NC}"
    else
        echo "   ${BLUE}source ~/.bashrc${NC}"
    fi
    echo ""
}

# Main installation flow
main() {
    print_header "Claude.md Installation"
    echo "This will install the persistent memory system for Claude Code"
    echo ""

    check_prerequisites
    collect_config
    create_directories
    install_claude_md
    install_support_files
    install_scripts
    install_slash_commands
    setup_shell_aliases
    setup_launchagent
    final_setup
    print_summary
}

# Run installation
main
