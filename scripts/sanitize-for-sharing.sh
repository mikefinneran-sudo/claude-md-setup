#!/bin/bash
# Sanitize CLAUDE.md and related files for public sharing
# Removes personal information, API keys, and sensitive data

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SANITIZED_DIR="$HOME/.claude/sanitized-export"
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}          Sanitizing Files for Public Sharing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Create sanitized directory
mkdir -p "$SANITIZED_DIR"

echo "📁 Creating sanitized copies..."
echo ""

# Sanitize CLAUDE.md
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    echo "🧹 Sanitizing CLAUDE.md..."

    # Copy file
    cp "$HOME/.claude/CLAUDE.md" "$SANITIZED_DIR/CLAUDE.md"

    # Remove personal information
    sed -i '' 's/- \*\*Name\*\*:.*/- **Name**: [YOUR_NAME]/g' "$SANITIZED_DIR/CLAUDE.md"
    sed -i '' 's/- \*\*Primary Email\*\*:.*/- **Primary Email**: [YOUR_EMAIL]/g' "$SANITIZED_DIR/CLAUDE.md"
    sed -i '' 's/- \*\*Work Email\*\*:.*/- **Work Email**: [YOUR_WORK_EMAIL]/g' "$SANITIZED_DIR/CLAUDE.md"

    # Remove specific paths
    sed -i '' "s|$HOME|~|g" "$SANITIZED_DIR/CLAUDE.md"
    sed -i '' 's|\/Users\/[^\/]*|~|g' "$SANITIZED_DIR/CLAUDE.md"

    # Remove email addresses
    sed -i '' 's/[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}/[EMAIL_REMOVED]/g' "$SANITIZED_DIR/CLAUDE.md"

    # Remove potential API keys (various patterns)
    sed -i '' 's/[sS][kK]-[a-zA-Z0-9]\{32,\}/[API_KEY_REMOVED]/g' "$SANITIZED_DIR/CLAUDE.md"
    sed -i '' 's/xai-[a-zA-Z0-9]\{32,\}/[API_KEY_REMOVED]/g' "$SANITIZED_DIR/CLAUDE.md"
    sed -i '' 's/pat[a-zA-Z0-9]\{32,\}/[API_KEY_REMOVED]/g' "$SANITIZED_DIR/CLAUDE.md"

    # Remove S3 bucket names
    sed -i '' 's/s3:\/\/[a-zA-Z0-9-]\+/s3:\/\/[YOUR_BUCKET]/g' "$SANITIZED_DIR/CLAUDE.md"

    # Remove project-specific details
    sed -i '' 's/\*\*Primary Project\*\*:.*/\*\*Primary Project\*\*: [YOUR_PROJECT]/g' "$SANITIZED_DIR/CLAUDE.md"

    echo "   ✅ CLAUDE.md sanitized"
fi

# Sanitize PROJECT-REGISTRY.md
if [ -f "$HOME/.claude/PROJECT-REGISTRY.md" ]; then
    echo "🧹 Sanitizing PROJECT-REGISTRY.md..."

    # Create template version
    cat > "$SANITIZED_DIR/PROJECT-REGISTRY.md" <<'EOF'
# Project Registry

## Active Projects

### [Project Name]
- **Status**: Active
- **Location**: ~/Documents/Projects/[project-name]
- **Description**: [Brief description]
- **Last Updated**: [YYYY-MM-DD]
- **Key Files**:
  - [key-file-1]
  - [key-file-2]

## Archived Projects

### [Old Project]
- **Archived**: [YYYY-MM-DD]
- **Location**: ~/Documents/Archive/[project-name]
EOF

    echo "   ✅ PROJECT-REGISTRY.md sanitized"
fi

# Sanitize WORKING-CONTEXT.md
if [ -f "$HOME/.claude/WORKING-CONTEXT.md" ]; then
    echo "🧹 Sanitizing WORKING-CONTEXT.md..."

    cat > "$SANITIZED_DIR/WORKING-CONTEXT.md" <<'EOF'
# Working Context

## Current Session
**Started**: [YYYY-MM-DD]
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

    echo "   ✅ WORKING-CONTEXT.md sanitized"
fi

# Sanitize shell config
if [ -f "$HOME/.zshrc" ]; then
    echo "🧹 Sanitizing .zshrc..."

    # Extract only Claude-related aliases (remove sensitive env vars)
    grep -A 20 "# Claude.md aliases" "$HOME/.zshrc" | grep -v -E "(TOKEN|KEY|SECRET|PASSWORD)" > "$SANITIZED_DIR/zshrc-aliases.txt" 2>/dev/null || true

    echo "   ✅ .zshrc sanitized (aliases only)"
fi

# Copy scripts (these are generally safe)
if [ -d "$HOME/.claude/scripts" ]; then
    echo "📦 Copying scripts..."
    mkdir -p "$SANITIZED_DIR/scripts"

    # Copy non-sensitive scripts
    for script in backup-to-s3.sh restore-from-s3.sh setup-aliases.sh; do
        if [ -f "$HOME/.claude/scripts/$script" ]; then
            cp "$HOME/.claude/scripts/$script" "$SANITIZED_DIR/scripts/"
        fi
    done

    echo "   ✅ Scripts copied"
fi

# Copy commands
if [ -d "$HOME/.claude/commands" ]; then
    echo "📦 Copying slash commands..."
    mkdir -p "$SANITIZED_DIR/commands"
    cp -R "$HOME/.claude/commands"/* "$SANITIZED_DIR/commands/" 2>/dev/null || true
    echo "   ✅ Commands copied"
fi

# Create README for sanitized export
cat > "$SANITIZED_DIR/README.txt" <<EOF
Sanitized Export - $(date '+%Y-%m-%d %H:%M:%S')

This directory contains sanitized versions of your Claude.md setup
files with all personal information, API keys, and sensitive data removed.

Safe to share:
✅ File structure and organization
✅ Workflow patterns and preferences
✅ Scripts and automation
✅ Slash commands
✅ General configuration

Removed:
❌ Personal names and emails
❌ API keys and tokens
❌ S3 bucket names
❌ File paths with usernames
❌ Project-specific details
❌ Client information

Before sharing:
1. Review each file manually
2. Replace placeholders with generic examples
3. Verify no sensitive data remains
4. Consider what's appropriate for public sharing

These files are templates - recipients will need to:
- Fill in their own information
- Configure their own paths
- Set up their own API keys
- Customize for their workflow
EOF

# Create archive
echo ""
echo "📦 Creating archive..."
cd "$HOME/.claude"
tar -czf "sanitized-export-$TIMESTAMP.tar.gz" -C "$SANITIZED_DIR" .

ARCHIVE_PATH="$HOME/.claude/sanitized-export-$TIMESTAMP.tar.gz"
ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}          Sanitization Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "📁 Sanitized files: $SANITIZED_DIR"
echo "📦 Archive created: $ARCHIVE_PATH"
echo "💾 Size: $ARCHIVE_SIZE"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
echo "   1. Review files in $SANITIZED_DIR manually"
echo "   2. Verify no sensitive data remains"
echo "   3. Only share what you're comfortable with"
echo ""
echo "To review:"
echo "   cd $SANITIZED_DIR"
echo "   ls -la"
echo ""
