# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository focused on Zsh shell configuration. The structure is modular, with each configuration aspect separated into specific files within the `.zsh/` directory.

## Architecture

### Core Structure
```
dotfiles/.zsh/
├── aliases.zsh       # System, navigation, and macOS-specific aliases
├── functions.zsh     # Utility functions (extract, directory management, sync operations)
├── git.zsh          # Git aliases and workflow shortcuts
├── maintenance.zsh  # Backup and restore functions for dotfiles
├── completions.zsh  # Command completion configuration
├── exports.zsh      # Environment variable exports
├── fzf.zsh         # FZF (fuzzy finder) integration
├── prompt.zsh      # Shell prompt customization
└── zoxide.zsh      # Zoxide (smart cd) integration
```

### Configuration Loading
The dotfiles are sourced from a main `.zshrc` file that loads each module. Environment variables are defined in a `.env` file at the repository root (not tracked in git).

## Common Commands

### Dotfiles Management
- `dotfiles-backup [name]` - Create timestamped backup of current configuration
- `dotfiles-backups` - List all available backups with details
- `dotfiles-restore <backup-name>` - Restore from a specific backup (creates safety backup first)
- `dotfiles-cleanup [count]` - Keep only N most recent backups (default: 5)
- `dotfiles-export [name]` - Export configuration for sharing (excludes secrets)

### Development Workflow
- `reload` - Reload zsh configuration (`source ~/.zshrc`)
- `gitdate` - Add all files and commit with current timestamp
- Git aliases are extensive - see `git.zsh` for full list (gs, gst, gl, etc.)

### Directory and File Operations
- `mkcd <dir>` - Create directory and cd into it
- `mktmpd` - Create and enter temporary directory in `~/temp-directories`
- `extract <archive>` - Extract any archive type with optional cleanup
- `emptydir` - Delete all contents of current directory (with confirmation)
- `ranger-cd` (alias: `rr`) - Use ranger file manager to navigate and cd

### Sync Operations
- `proton-sync` - Sync current directory to ProtonDrive (requires PROTON_DRIVE_PATH)
- `server-sync` - Sync current directory to remote server (requires REMOTE_SERVER, REMOTE_PATH)
- `rrsync` - Custom rsync with exclusion file

### API Integration
- `todoist <content> [due] [priority]` - Add task to Todoist (requires TODOIST_API_TOKEN)

## Environment Variables

The `.env` file (not tracked) should contain:
```bash
export TODOIST_API_TOKEN="your-token"
export PROTON_DRIVE_PATH="path-to-proton-drive"
export REMOTE_SERVER="server-address"  
export REMOTE_PATH="~/Server"
export MY_SYNC_VAULT="$HOME/My_Sync_Vault"
export TEMP_DIRECTORIES="$HOME/temp-directories"
export ARCHIVES_DIR="$HOME/archives"
export BACKUPS_DIR="$HOME/backups"
```

## Key Features

- **Modular Design**: Each configuration aspect is in a separate file
- **Backup System**: Built-in backup/restore functionality with automatic cleanup  
- **Sync Integration**: ProtonDrive and remote server sync capabilities
- **Enhanced Navigation**: FZF, zoxide, and ranger integration
- **Git Workflow**: Comprehensive git aliases and functions
- **Safety Features**: Confirmation prompts for destructive operations
- **Docker Integration**: Docker compose aliases (up, down, logs, etc.)

## Installation

The repository includes an `install.sh` script for setting up the configuration on new systems. The backup/export functions facilitate migration between machines.