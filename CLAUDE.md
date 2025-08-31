# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Setup and Installation
- `./install.sh` - Install dotfiles configuration with automatic dependency checking and symlink creation
- `./validate-dotfiles` - Validate the entire dotfiles setup (shell config, aliases, functions, dependencies, git config)

### Key Functions
- `dot` - Navigate to dotfiles directory quickly
- `reload` - Reload zsh configuration (alias for `source ~/.zshrc`)
- `dotfiles-backup [name]` - Create timestamped backup of current dotfiles configuration
- `dotfiles-restore <backup-name>` - Restore from a specific backup
- `dotfiles-export [name]` - Export dotfiles for sharing (excludes sensitive data)

### Sync Operations
- `proton-sync` - Sync current directory to ProtonDrive (requires PROTON_DRIVE_PATH)
- `server-sync` - Sync current directory to remote server (requires REMOTE_SERVER, REMOTE_PATH)

## Architecture

### Modular Configuration Structure
The dotfiles use a modular approach with each component in separate `.zsh` files:

- **exports.zsh** - Environment variables and PATH configuration (must load first)
- **completions.zsh** - Shell completion setup
- **prompt.zsh** - Prompt configuration (oh-my-posh integration)
- **aliases.zsh** - Command aliases for navigation, file operations, system management
- **functions.zsh** - Custom shell functions (directory operations, archive extraction, API integrations)
- **fzf.zsh** - FZF fuzzy finder integration
- **zoxide.zsh** - Zoxide smart directory jumping
- **git.zsh** - Git-specific configurations and aliases
- **maintenance.zsh** - Dotfiles backup, restore, and export functions

### Environment Configuration
- **Main config**: `.zshrc` sources all modules in dependency order
- **Environment variables**: `.env` file contains sensitive/personal configuration (not version controlled)
- **rsync exclusions**: `.rsync_exclude` defines patterns for sync operations

### Installation System
- **install.sh**: Full installation with dependency checks, backup creation, symlink setup
- **validate-dotfiles**: Comprehensive validation of shell config, functions, tools, and integrations
- Supports both macOS (with Homebrew) and Linux environments

### Key Integrations
- **FZF**: Configured for file finding with custom styling and fd integration
- **Zoxide**: Smart directory navigation with echo enabled
- **oh-my-posh**: Prompt theming system
- **API Integration**: Todoist task creation via REST API
- **Cloud Sync**: ProtonDrive and remote server synchronization with rsync

### Directory Structure
```
~/dotfiles/
├── .zsh/           # Modular configuration files
├── .env            # Environment variables (user-specific)
├── .zshrc          # Main configuration loader
├── install.sh      # Installation script
└── validate-dotfiles # Validation script
```

The configuration loads in strict dependency order to ensure proper initialization of shell features and integrations.