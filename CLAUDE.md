# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS zsh configuration. The repository follows a modular architecture where the main `.zshrc` file sources individual configuration files from the `.zsh/` directory.

## Architecture & Structure

### Modular Configuration System
- **Main entry point**: `.zshrc` - Sources all `.zsh` files from the `.zsh/` directory
- **Configuration modules**: Located in `.zsh/` directory, each handling specific functionality:
  - `aliases.zsh` - System aliases and shortcuts
  - `functions.zsh` - Custom shell functions and utilities
  - `fzf.zsh` - FZF (fuzzy finder) integration and custom functions
  - `zoxide.zsh` - Zoxide (smart directory jumping) configuration

### Key Components

#### Aliases System (`aliases.zsh`)
- Organized by categories: Navigation, File Operations, System Management, macOS-specific
- Enhanced directory listing commands (`ll`, `la`, `lh`, `lt`, etc.)
- Safety aliases with confirmation prompts (`cp -i`, `mv -i`, `rm -i`)
- macOS system management (`brewup`, `flushdns`, `showfiles`/`hidefiles`)

#### Custom Functions (`functions.zsh`)
- **Directory utilities**: `mkcd()`, `mktmpd()`, `emptydir()`, `cd_choose()`
- **Archive extraction**: Universal `extract()` function with cleanup prompt
- **Sync operations**: `proton-sync()`, `server-sync()` for file synchronization
- **Task management**: `todoist()` integration with REST API
- **Note**: Contains API token for Todoist - handle with care

#### FZF Integration (`fzf.zsh`)
- Custom FZF functions: `dot()`, `nmd()`, `vimedit()`, `taskd()`, `paths()`, `bookmark()`
- Custom FZF styling with color scheme and layout configuration
- File and directory selection workflows

#### Zoxide Configuration (`zoxide.zsh`)
- Smart directory jumping with `z` and `zi` commands
- Hook system for tracking directory usage
- Auto-completion and interactive selection

## Configuration Files

### Git Configuration
- **Global gitconfig**: `.gitconfig` with LFS, user settings, and custom excludes
- **Global gitignore**: `.gitignore_global` for common ignore patterns
- **Default branch**: Uses `master` instead of `main`

### Rsync Configuration
- **Exclude file**: `.rsync_exclude` with comprehensive ignore patterns for syncing

## Development Workflow

### Making Changes
1. Edit individual `.zsh` files for specific functionality
2. Test changes by running `source ~/.zshrc` or using the `reload` alias
3. The modular system automatically sources all `.zsh` files on shell startup

### File Management
- Use `dsclean` alias to remove `.DS_Store` files
- Sync functions available for backup to ProtonDrive and remote servers
- Temporary directory management via `mktmpd` function

### Directory Navigation
- Use `z <partial-name>` for smart directory jumping (zoxide)
- Use `zi` for interactive directory selection
- Use `cd_choose()` function for predefined directory selection
- FZF-based navigation with `dot()`, `paths()`, and other custom functions

## Security Considerations
- Todoist API token is present in `functions.zsh` - treat as sensitive
- Rsync and sync functions may expose directory structures
- SSH configuration references (`macmini` server) indicate remote access setup