# =============================================================================
# Maintenance and Backup Functions
# =============================================================================
# Functions for managing, backing up, and restoring dotfiles configuration
# =============================================================================

# Create a backup of current dotfiles configuration
dotfiles-backup() {
    local backup_name="${1:-backup-$(date +%Y%m%d-%H%M%S)}"
    local backup_dir="$HOME/.dotfiles-backups"
    local backup_path="$backup_dir/$backup_name"
    
    echo "Creating dotfiles backup: $backup_name"
    
    # Create backup directory
    mkdir -p "$backup_path"
    
    # Files to backup
    local files=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig" 
        "$HOME/.gitignore_global"
        "$HOME/dotfiles/.env"
    )
    
    # Directories to backup
    local dirs=(
        "$HOME/dotfiles/.zsh"
    )
    
    # Backup files
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "  Backing up $(basename "$file")"
            cp "$file" "$backup_path/"
        fi
    done
    
    # Backup directories
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "  Backing up $(basename "$dir")/"
            cp -r "$dir" "$backup_path/"
        fi
    done
    
    # Create backup info file
    cat > "$backup_path/backup-info.txt" << EOF
Dotfiles Backup Information
===========================
Created: $(date)
Hostname: $(hostname)
User: $(whoami)
Shell: $SHELL
OS: $(uname -s) $(uname -r)

Backup Contents:
$(ls -la "$backup_path")
EOF
    
    echo "✓ Backup created at: $backup_path"
    echo "  Total size: $(du -sh "$backup_path" | cut -f1)"
}

# List available backups
dotfiles-backups() {
    local backup_dir="$HOME/.dotfiles-backups"
    
    if [[ ! -d "$backup_dir" ]]; then
        echo "No backups found. Create one with: dotfiles-backup"
        return 1
    fi
    
    echo "Available dotfiles backups:"
    echo "=========================="
    
    for backup in "$backup_dir"/*; do
        if [[ -d "$backup" ]]; then
            local backup_name=$(basename "$backup")
            local backup_date=""
            local backup_size=$(du -sh "$backup" 2>/dev/null | cut -f1)
            
            # Try to get date from backup-info.txt
            if [[ -f "$backup/backup-info.txt" ]]; then
                backup_date=$(grep "Created:" "$backup/backup-info.txt" | cut -d: -f2- | xargs)
            fi
            
            echo "  $backup_name"
            [[ -n "$backup_date" ]] && echo "    Date: $backup_date"
            echo "    Size: $backup_size"
            echo "    Path: $backup"
            echo ""
        fi
    done
}

# Restore from a backup
dotfiles-restore() {
    local backup_name="$1"
    local backup_dir="$HOME/.dotfiles-backups"
    local backup_path="$backup_dir/$backup_name"
    
    if [[ -z "$backup_name" ]]; then
        echo "Usage: dotfiles-restore <backup-name>"
        echo "Available backups:"
        dotfiles-backups
        return 1
    fi
    
    if [[ ! -d "$backup_path" ]]; then
        echo "Error: Backup '$backup_name' not found"
        echo "Available backups:"
        dotfiles-backups
        return 1
    fi
    
    echo "Restoring from backup: $backup_name"
    echo "Warning: This will overwrite current configuration!"
    echo "Press Enter to continue, Ctrl+C to cancel..."
    read -r
    
    # Create a backup of current state before restoring
    echo "Creating safety backup of current state..."
    dotfiles-backup "pre-restore-$(date +%Y%m%d-%H%M%S)"
    
    # Restore files
    local files=(
        ".zshrc"
        ".gitconfig"
        ".gitignore_global"
        ".env"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$backup_path/$file" ]]; then
            echo "  Restoring $file"
            if [[ "$file" == ".env" ]]; then
                cp "$backup_path/$file" "$HOME/dotfiles/$file"
            else
                cp "$backup_path/$file" "$HOME/$file"
            fi
        fi
    done
    
    # Restore .zsh directory
    if [[ -d "$backup_path/.zsh" ]]; then
        echo "  Restoring .zsh directory"
        rm -rf "$HOME/dotfiles/.zsh"
        cp -r "$backup_path/.zsh" "$HOME/dotfiles/"
    fi
    
    echo "✓ Restore complete!"
    echo "  Please restart your shell or run: source ~/.zshrc"
}

# Clean old backups (keep only the most recent N backups)
dotfiles-cleanup() {
    local keep_count="${1:-5}"
    local backup_dir="$HOME/.dotfiles-backups"
    
    if [[ ! -d "$backup_dir" ]]; then
        echo "No backup directory found"
        return 0
    fi
    
    echo "Cleaning up old backups (keeping $keep_count most recent)..."
    
    # Get list of backups sorted by modification time (newest first)
    local backups=($(ls -t "$backup_dir"))
    local backup_count=${#backups[@]}
    
    if [[ $backup_count -le $keep_count ]]; then
        echo "Only $backup_count backups found, nothing to clean"
        return 0
    fi
    
    echo "Found $backup_count backups, removing $((backup_count - keep_count)) old ones:"
    
    # Remove old backups
    for ((i=$keep_count; i<$backup_count; i++)); do
        local backup_path="$backup_dir/${backups[$i]}"
        if [[ -d "$backup_path" ]]; then
            echo "  Removing: ${backups[$i]}"
            rm -rf "$backup_path"
        fi
    done
    
    echo "✓ Cleanup complete!"
}

# Export dotfiles configuration (for sharing/migration)
dotfiles-export() {
    local export_name="${1:-dotfiles-export-$(date +%Y%m%d-%H%M%S)}"
    local export_dir="$HOME/Downloads"
    local export_path="$export_dir/$export_name"
    
    echo "Exporting dotfiles configuration..."
    
    # Create export directory
    mkdir -p "$export_path"
    
    # Copy non-sensitive files
    cp "$HOME/dotfiles/.zshrc" "$export_path/"
    cp "$HOME/dotfiles/.gitconfig" "$export_path/"
    cp "$HOME/dotfiles/.gitignore_global" "$export_path/"
    cp "$HOME/dotfiles/.rsync_exclude" "$export_path/"
    cp "$HOME/dotfiles/install.sh" "$export_path/"
    cp -r "$HOME/dotfiles/.zsh" "$export_path/"
    
    # Create template .env file (without secrets)
    cat > "$export_path/.env.template" << 'EOF'
# =============================================================================
# Environment Variables Template
# =============================================================================
# Copy this to .env and fill in your actual values
# =============================================================================

# API Keys and Tokens
export TODOIST_API_TOKEN="your-token-here"

# Directory Paths (customize these for your system)
export MY_SYNC_VAULT="$HOME/My_Sync_Vault"
export MY_FOLDER="$HOME/my-folder"
export TEMP_DIRECTORIES="$HOME/temp-directories"
export ARCHIVES_DIR="$HOME/archives" 
export BACKUPS_DIR="$HOME/backups"

# ProtonDrive Path (update with your path)
export PROTON_DRIVE_PATH="$HOME/Library/CloudStorage/ProtonDrive-your-email-folder"

# Server Configuration
export REMOTE_SERVER="your-server"
export REMOTE_PATH="~/Server"

# Tool Configuration  
export EDITOR="nvim"
export PAGER="less"
EOF
    
    # Create README for the export
    cat > "$export_path/README.md" << 'EOF'
# Dotfiles Export

This is an exported dotfiles configuration.

## Installation

1. Copy this directory to `~/dotfiles`
2. Run: `cd ~/dotfiles && ./install.sh`  
3. Copy `.env.template` to `.env` and fill in your values
4. Restart your shell

## What's Included

- Modular zsh configuration
- Git aliases and functions
- FZF integration
- Custom shell functions
- Completion system
- Installation script

Enjoy your new shell setup! 🚀
EOF
    
    # Create archive
    cd "$export_dir"
    tar -czf "$export_name.tar.gz" "$export_name"
    
    echo "✓ Export complete!"
    echo "  Directory: $export_path"
    echo "  Archive: $export_path.tar.gz"
    echo "  Ready to share or move to another machine!"
}