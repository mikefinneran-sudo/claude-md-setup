#!/bin/bash
# Restore from S3 - Interactive backup restoration

set -e

S3_BUCKET="${S3_BACKUP_BUCKET}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if S3 bucket is configured
if [ -z "$S3_BUCKET" ]; then
    echo -e "${RED}❌ S3_BACKUP_BUCKET environment variable not set${NC}"
    echo "   Set it in your ~/.zshrc:"
    echo "   export S3_BACKUP_BUCKET=your-bucket-name"
    exit 1
fi

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not found${NC}"
    echo "   Install: brew install awscli"
    exit 1
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}              S3 Restore - Interactive${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# List available backups
echo "📋 Fetching available backups..."
echo ""

BACKUPS=$(aws s3 ls "s3://$S3_BUCKET/claude-backups/" | grep "backup-" | sort -r)

if [ -z "$BACKUPS" ]; then
    echo -e "${RED}❌ No backups found in s3://$S3_BUCKET/claude-backups/${NC}"
    exit 1
fi

# Display backups with numbers
echo "Available backups:"
echo ""
i=1
declare -a BACKUP_FILES
while IFS= read -r line; do
    BACKUP_FILE=$(echo "$line" | awk '{print $4}')
    BACKUP_DATE=$(echo "$BACKUP_FILE" | sed 's/backup-//g' | sed 's/.tar.gz//g')
    BACKUP_SIZE=$(echo "$line" | awk '{print $3}')

    # Format date for display
    DISPLAY_DATE=$(echo "$BACKUP_DATE" | sed 's/-/ /g' | sed 's/\([0-9]\{4\}\) \([0-9]\{2\}\) \([0-9]\{2\}\) \([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5/')

    echo -e "  ${GREEN}[$i]${NC} $DISPLAY_DATE ($BACKUP_SIZE bytes)"
    BACKUP_FILES[$i]=$BACKUP_FILE
    ((i++))
done <<< "$BACKUPS"

echo ""
read -p "Select backup number to restore (or 'q' to quit): " SELECTION

if [ "$SELECTION" = "q" ]; then
    echo "Cancelled."
    exit 0
fi

# Validate selection
if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -lt 1 ] || [ "$SELECTION" -ge "$i" ]; then
    echo -e "${RED}❌ Invalid selection${NC}"
    exit 1
fi

SELECTED_BACKUP="${BACKUP_FILES[$SELECTION]}"
echo ""
echo -e "Selected: ${BLUE}$SELECTED_BACKUP${NC}"
echo ""

# Confirm
read -p "⚠️  This will overwrite existing files. Continue? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "Cancelled."
    exit 0
fi

# Create restore directory
RESTORE_DIR="$HOME/.claude/s3-restores"
mkdir -p "$RESTORE_DIR"

TIMESTAMP=$(date '+%Y%m%d-%H%M%S')

echo ""
echo "📥 Downloading backup from S3..."
aws s3 cp "s3://$S3_BUCKET/claude-backups/$SELECTED_BACKUP" "$RESTORE_DIR/$SELECTED_BACKUP"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Download failed${NC}"
    exit 1
fi

echo -e "   ${GREEN}✅ Downloaded${NC}"
echo ""

# Extract backup
echo "📦 Extracting backup..."
cd "$RESTORE_DIR"
tar -xzf "$SELECTED_BACKUP"

BACKUP_NAME=$(echo "$SELECTED_BACKUP" | sed 's/.tar.gz//g')
EXTRACTED_DIR="$RESTORE_DIR/$BACKUP_NAME"

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo -e "${RED}❌ Extraction failed${NC}"
    exit 1
fi

echo -e "   ${GREEN}✅ Extracted${NC}"
echo ""

# Display backup contents
if [ -f "$EXTRACTED_DIR/MANIFEST.txt" ]; then
    echo "📄 Backup Contents:"
    cat "$EXTRACTED_DIR/MANIFEST.txt"
    echo ""
fi

# Restore files
echo "🔄 Restoring files..."

# Backup current files before restoring
CURRENT_BACKUP="$HOME/.claude/pre-restore-backup-$TIMESTAMP"
mkdir -p "$CURRENT_BACKUP"

if [ -d "$HOME/.claude" ]; then
    echo "   💾 Backing up current files to: $CURRENT_BACKUP"
    cp -R "$HOME/.claude"/* "$CURRENT_BACKUP/" 2>/dev/null || true
fi

# Restore memory files
if [ -d "$EXTRACTED_DIR/memory" ]; then
    echo "   🧠 Restoring memory files..."
    cp -R "$EXTRACTED_DIR/memory"/* "$HOME/.claude/" 2>/dev/null || true
fi

# Restore scripts
if [ -d "$EXTRACTED_DIR/scripts" ]; then
    echo "   🛠  Restoring scripts..."
    mkdir -p "$HOME/.claude/scripts"
    cp -R "$EXTRACTED_DIR/scripts"/* "$HOME/.claude/scripts/" 2>/dev/null || true
    chmod +x "$HOME/.claude/scripts"/*.sh 2>/dev/null || true
fi

# Restore commands
if [ -d "$EXTRACTED_DIR/commands" ]; then
    echo "   📝 Restoring commands..."
    mkdir -p "$HOME/.claude/commands"
    cp -R "$EXTRACTED_DIR/commands"/* "$HOME/.claude/commands/" 2>/dev/null || true
fi

# Restore session archives (optional)
if [ -d "$EXTRACTED_DIR/session-archives" ]; then
    read -p "   Restore session archives? (y/n): " RESTORE_SESSIONS
    if [ "$RESTORE_SESSIONS" = "y" ]; then
        mkdir -p "$HOME/.claude/session-archive"
        cp -R "$EXTRACTED_DIR/session-archives"/* "$HOME/.claude/session-archive/" 2>/dev/null || true
        echo "   ✅ Session archives restored"
    fi
fi

# Restore projects (optional)
if [ -d "$EXTRACTED_DIR/projects" ]; then
    read -p "   Restore project workspaces? (y/n): " RESTORE_PROJECTS
    if [ "$RESTORE_PROJECTS" = "y" ]; then
        mkdir -p "$HOME/.claude/projects"
        cp -R "$EXTRACTED_DIR/projects"/* "$HOME/.claude/projects/" 2>/dev/null || true
        echo "   ✅ Project workspaces restored"
    fi
fi

# Restore documentation
if [ -d "$EXTRACTED_DIR/docs" ]; then
    echo "   📚 Restoring documentation..."
    cp -R "$EXTRACTED_DIR/docs"/* "$HOME/.claude/" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              Restore Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "✅ Files restored from: $SELECTED_BACKUP"
echo "💾 Previous files backed up to: $CURRENT_BACKUP"
echo ""
echo "⚠️  Remember to reload your shell if config files were restored:"
echo "   source ~/.zshrc"
echo ""

# Cleanup
read -p "Clean up downloaded files? (y/n): " CLEANUP
if [ "$CLEANUP" = "y" ]; then
    rm -rf "$EXTRACTED_DIR"
    rm "$RESTORE_DIR/$SELECTED_BACKUP"
    echo "🧹 Cleaned up temporary files"
fi

echo ""
echo "Done!"
