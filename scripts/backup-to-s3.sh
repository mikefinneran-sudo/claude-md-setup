#!/bin/bash
# Backup to S3 - Intelligent Session and Project Archival
# Backs up Claude.md system, projects, and session archives

set -e

S3_BUCKET="${S3_BACKUP_BUCKET}"
TIMESTAMP=$(date '+%Y-%m-%d-%H%M%S')
BACKUP_ROOT="$HOME/.claude/s3-backups"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if S3 bucket is configured
if [ -z "$S3_BUCKET" ]; then
    echo "❌ S3_BACKUP_BUCKET environment variable not set"
    echo "   Set it in your ~/.zshrc:"
    echo "   export S3_BACKUP_BUCKET=your-bucket-name"
    exit 1
fi

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found"
    echo "   Install: brew install awscli"
    echo "   Configure: aws configure"
    exit 1
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}              S3 Backup - Starting${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Create temporary backup directory
mkdir -p "$BACKUP_ROOT"
BACKUP_DIR="$BACKUP_ROOT/backup-$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "📦 Creating backup in: $BACKUP_DIR"
echo ""

# Backup 1: Core Memory Files
echo "🧠 Backing up memory files..."
mkdir -p "$BACKUP_DIR/memory"

for file in CLAUDE.md WORKING-CONTEXT.md PROJECT-REGISTRY.md AUTOMATION_LOCATIONS.md; do
    if [ -f "$HOME/.claude/$file" ]; then
        cp "$HOME/.claude/$file" "$BACKUP_DIR/memory/"
    fi
done

memory_count=$(ls -1 "$BACKUP_DIR/memory" 2>/dev/null | wc -l | xargs)
echo "   ✅ $memory_count memory files backed up"

# Backup 2: Session Archives (if they exist)
if [ -d "$HOME/.claude/session-archive" ]; then
    echo "📝 Backing up session archives..."
    session_count=$(find "$HOME/.claude/session-archive" -type f -name "*.md" | wc -l | xargs)

    if [ "$session_count" -gt 0 ]; then
        mkdir -p "$BACKUP_DIR/session-archives"
        cp -R "$HOME/.claude/session-archive"/* "$BACKUP_DIR/session-archives/" 2>/dev/null || true
        echo "   ✅ $session_count session files"
    else
        echo "   ℹ️  No session archives found"
    fi
else
    session_count=0
fi

# Backup 3: Project Workspaces (if they exist)
if [ -d "$HOME/.claude/projects" ]; then
    echo "📁 Backing up project workspaces..."
    project_count=$(find "$HOME/.claude/projects" -maxdepth 1 -type d | tail -n +2 | wc -l | xargs)

    if [ "$project_count" -gt 0 ]; then
        mkdir -p "$BACKUP_DIR/projects"
        cp -R "$HOME/.claude/projects"/* "$BACKUP_DIR/projects/" 2>/dev/null || true
        echo "   ✅ $project_count projects"
    else
        echo "   ℹ️  No project workspaces found"
    fi
else
    project_count=0
fi

# Backup 4: Scripts and Commands
echo "🛠  Backing up scripts and commands..."
mkdir -p "$BACKUP_DIR/scripts"
mkdir -p "$BACKUP_DIR/commands"

if [ -d "$HOME/.claude/scripts" ]; then
    cp -R "$HOME/.claude/scripts"/* "$BACKUP_DIR/scripts/" 2>/dev/null || true
fi

if [ -d "$HOME/.claude/commands" ]; then
    cp -R "$HOME/.claude/commands"/* "$BACKUP_DIR/commands/" 2>/dev/null || true
fi

script_count=$(ls -1 "$BACKUP_DIR/scripts" 2>/dev/null | wc -l | xargs)
command_count=$(ls -1 "$BACKUP_DIR/commands" 2>/dev/null | wc -l | xargs)
echo "   ✅ $script_count scripts, $command_count commands"

# Backup 5: Configuration Files
echo "⚙️  Backing up configuration..."
mkdir -p "$BACKUP_DIR/config"

# Backup shell config (sanitize sensitive data)
if [ -f "$HOME/.zshrc" ]; then
    # Remove lines with sensitive tokens/keys
    grep -v -E "(export.*TOKEN|export.*KEY|export.*SECRET|export.*PASSWORD)" "$HOME/.zshrc" > "$BACKUP_DIR/config/zshrc-backup" 2>/dev/null || cp "$HOME/.zshrc" "$BACKUP_DIR/config/zshrc-backup"
fi

echo "   ✅ Configuration backed up"

# Backup 6: Documentation
echo "📚 Backing up documentation..."
mkdir -p "$BACKUP_DIR/docs"

# Backup any markdown files in .claude root
for doc in "$HOME/.claude"/*.md; do
    if [ -f "$doc" ]; then
        cp "$doc" "$BACKUP_DIR/docs/" 2>/dev/null || true
    fi
done

doc_count=$(ls -1 "$BACKUP_DIR/docs" 2>/dev/null | wc -l | xargs)
echo "   ✅ $doc_count documentation files"

# Create backup manifest
cat > "$BACKUP_DIR/MANIFEST.txt" <<EOF
Claude Code Backup
Created: $(date '+%Y-%m-%d %H:%M:%S')
Bucket: $S3_BUCKET
Host: $(hostname)

Contents:
- Memory Files: $memory_count files
- Session Archives: $session_count files
- Projects: $project_count workspaces
- Scripts: $script_count files
- Commands: $command_count files
- Documentation: $doc_count files

Backup Size: $(du -sh "$BACKUP_DIR" | cut -f1)
EOF

echo ""
echo "📊 Backup Summary:"
cat "$BACKUP_DIR/MANIFEST.txt" | grep -v "^$"
echo ""

# Compress backup
echo "🗜  Compressing backup..."
cd "$BACKUP_ROOT"
tar -czf "backup-$TIMESTAMP.tar.gz" "backup-$TIMESTAMP"
COMPRESSED_SIZE=$(du -sh "backup-$TIMESTAMP.tar.gz" | cut -f1)
echo "   ✅ Compressed to $COMPRESSED_SIZE"
echo ""

# Upload to S3
echo "☁️  Uploading to S3..."
aws s3 cp "backup-$TIMESTAMP.tar.gz" "s3://$S3_BUCKET/claude-backups/backup-$TIMESTAMP.tar.gz" \
    --storage-class STANDARD_IA \
    --metadata "type=claude-backup,timestamp=$TIMESTAMP"

if [ $? -eq 0 ]; then
    echo -e "   ${GREEN}✅ Uploaded successfully${NC}"
    echo ""
    echo "S3 Location:"
    echo "   s3://$S3_BUCKET/claude-backups/backup-$TIMESTAMP.tar.gz"
else
    echo "   ❌ Upload failed"
    exit 1
fi

# Cleanup local backup
echo ""
echo "🧹 Cleaning up local files..."
rm -rf "$BACKUP_DIR"
rm "backup-$TIMESTAMP.tar.gz"
echo "   ✅ Local backup removed"

# List recent backups
echo ""
echo "📋 Recent backups in S3:"
aws s3 ls "s3://$S3_BUCKET/claude-backups/" --recursive | tail -5

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              Backup Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Backup: s3://$S3_BUCKET/claude-backups/backup-$TIMESTAMP.tar.gz"
echo "Size: $COMPRESSED_SIZE"
echo ""
