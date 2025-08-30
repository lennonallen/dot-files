# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS zsh configuration. The repository follows a modular architecture where the main `.zshrc` file sources individual configuration files from the `.zsh/` directory.

## Architecture & Structure

### Modular Configuration System
- **Main entry point**: `.zshrc` - Sources all `.zsh` files in specific order for dependency management
- **Configuration modules**: Located in `.zsh/` directory, each handling specific functionality:
  - `exports.zsh` - Environment variables and PATH modifications (loaded first)
  - `completions.zsh` - Shell completions setup and configuration
  - `prompt.zsh` - Oh-my-posh prompt configuration with fallback
  - `aliases.zsh` - System aliases and shortcuts
  - `functions.zsh` - Custom shell functions and utilities  
  - `fzf.zsh` - FZF (fuzzy finder) integration and custom functions
  - `zoxide.zsh` - Zoxide (smart directory jumping) configuration
  - `git.zsh` - Git aliases and custom git functions
  - `maintenance.zsh` - Backup, restore, and export utilities

### Key Components

#### Environment Setup (`exports.zsh`)
- Environment variables (EDITOR, PAGER, LANG, etc.)
- PATH modifications for local binaries and npm global packages
- Shell history configuration (50k entries)
- FZF and Zoxide default options
- Homebrew analytics disabled
- Sources sensitive variables from `.env` file

#### Completions System (`completions.zsh`)
- Zsh completion system initialization with compinit
- Docker CLI and Homebrew completions
- Case-insensitive matching and colored output
- Menu selection and completion caching

#### Prompt Configuration (`prompt.zsh`)
- Oh-my-posh integration with custom theme support
- Fallback to simple git-aware prompt if oh-my-posh unavailable
- Custom theme path: `~/.config/oh-my-posh/themes/ohmyposh_theme.omp.json`

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

#### Git Integration (`git.zsh`)
- Comprehensive git aliases: status (`gs`, `gst`), branching (`gb`, `gco`, `gcb`), commits (`gc`, `gcm`, `gca`)
- Custom git functions: `gcom()` (quick commit), `gnb()` (new branch), `gbdr()` (delete branch)
- Specialized utilities: `gls()` (search commits), `gundo()` (undo last commit), `gignore()` (add to .gitignore)
- Quick date commit alias: `gitdate` for automatic timestamped commits

#### Zoxide Configuration (`zoxide.zsh`)
- Smart directory jumping with `z` and `zi` commands
- Hook system for tracking directory usage
- Auto-completion and interactive selection

#### Maintenance Utilities (`maintenance.zsh`)
- **Backup system**: `dotfiles-backup()` creates timestamped backups with metadata
- **Restore functionality**: `dotfiles-restore()` with safety backup before restoration
- **Backup management**: `dotfiles-backups()` (list), `dotfiles-cleanup()` (remove old)
- **Export system**: `dotfiles-export()` creates shareable packages with template files

## Configuration Files

### Git Configuration
- **Global gitconfig**: `.gitconfig` with LFS, user settings, and custom excludes
- **Global gitignore**: `.gitignore_global` for common ignore patterns
- **Default branch**: Uses `master` instead of `main`

### Rsync Configuration
- **Exclude file**: `.rsync_exclude` with comprehensive ignore patterns for syncing

## Common Commands

### Installation and Setup
- **Fresh installation**: `./install.sh` - Automated setup with dependency checking and symlink creation
- **Reload configuration**: `source ~/.zshrc` or use the `reload` alias
- **Create backup**: `dotfiles-backup [backup-name]` - Creates timestamped backup in `~/.dotfiles-backups/`
- **List backups**: `dotfiles-backups` - Shows available backups with dates and sizes
- **Restore from backup**: `dotfiles-restore <backup-name>` - Restores configuration with safety backup

### Testing Changes
- **Test configuration**: `source ~/.zshrc` after editing any `.zsh` file
- **Validate setup**: After installation, the system provides built-in validation
- **Environment check**: Verify `.env` file contains required API tokens and paths

### Backup and Export
- **Export for sharing**: `dotfiles-export [export-name]` - Creates sanitized export package
- **Clean old backups**: `dotfiles-cleanup [keep-count]` - Removes old backups (default keeps 5)
- **Sync to ProtonDrive**: `proton-sync` - Syncs dotfiles to ProtonDrive (requires setup)
- **Sync to server**: `server-sync` - Syncs to remote server (requires SSH config)

## Development Workflow

### Making Changes
1. **Edit specific modules**: Modify individual `.zsh` files for targeted functionality
2. **Follow load order**: Dependencies follow the order in `.zshrc` - `exports.zsh` loads first, then `completions.zsh`, `prompt.zsh`, etc.
3. **Test immediately**: Run `source ~/.zshrc` or use the `reload` alias after changes
4. **Verify dependencies**: Environment variables from `exports.zsh` must be available before other modules use them
5. **Handle sensitive data**: API tokens and credentials go in `.env` file (sourced by `exports.zsh`)

### File Management
- Use `dsclean` alias to remove `.DS_Store` files
- Sync functions available for backup to ProtonDrive and remote servers
- Temporary directory management via `mktmpd` function

### Directory Navigation
- Use `z <partial-name>` for smart directory jumping (zoxide)
- Use `zi` for interactive directory selection
- Use `cd_choose()` function for predefined directory selection
- FZF-based navigation with `dot()`, `paths()`, and other custom functions

## Architecture Details

### Dependency Loading Order
The `.zshrc` file enforces a specific loading order to ensure dependencies are available:
1. `exports.zsh` - Environment variables and PATH (foundation)
2. `completions.zsh` - Completion system initialization
3. `prompt.zsh` - Prompt setup (requires environment variables)
4. `aliases.zsh` - Command shortcuts
5. `functions.zsh` - Custom functions (may use environment variables)
6. `fzf.zsh` - FZF integration (uses FZF_DEFAULT_OPTS from exports)
7. `zoxide.zsh` - Directory jumping (uses _ZO_ECHO from exports)
8. Additional `.zsh` files are sourced last

### Environment File Pattern
- **Sensitive data**: Stored in `.env` file (gitignored)
- **Template system**: `install.sh` creates `.env` template with placeholders
- **Export pattern**: `dotfiles-export()` creates `.env.template` without secrets
- **Sourcing**: `exports.zsh` sources `.env` if it exists

## Security Considerations
- **API tokens**: Todoist and other API tokens stored in `.env` file (not committed)
- **Server credentials**: SSH server references (`macmini`) in sync functions
- **Directory exposure**: Sync functions may expose directory structures in command history
- **Backup security**: Backups created by maintenance functions include sensitive paths
- **Export safety**: Export function strips sensitive data but includes directory structure