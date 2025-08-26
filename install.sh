#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# =============================================================================
# This script sets up the dotfiles configuration on a new machine
# Usage: ./install.sh
# =============================================================================

set -e  # Exit on any error

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the dotfiles directory
check_location() {
    if [[ ! -f "$(pwd)/install.sh" ]] || [[ ! -d "$(pwd)/.zsh" ]]; then
        log_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    DOTFILES_DIR="$(pwd)"
    log_info "Dotfiles directory: $DOTFILES_DIR"
}

# Create backup directory
create_backup() {
    log_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
}

# Backup existing files
backup_existing() {
    local files=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.gitignore_global"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]] || [[ -L "$file" ]]; then
            log_info "Backing up existing $(basename "$file")"
            cp "$file" "$BACKUP_DIR/"
        fi
    done
}

# Create symbolic links
create_symlinks() {
    log_info "Creating symbolic links..."
    
    # Link main dotfiles
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig" 
    ln -sf "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
    
    log_success "Symbolic links created"
}

# Setup environment file
setup_env() {
    if [[ ! -f "$DOTFILES_DIR/.env" ]]; then
        log_warning ".env file not found. Creating template..."
        cat > "$DOTFILES_DIR/.env" << 'EOF'
# =============================================================================
# Environment Variables for dotfiles
# =============================================================================
# Copy this template and fill in your values
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
        log_warning "Please edit $DOTFILES_DIR/.env with your actual values"
    else
        log_success ".env file already exists"
    fi
}

# Check for required dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing_deps=()
    local optional_deps=()
    
    # Required dependencies
    if ! command -v zsh &> /dev/null; then
        missing_deps+=("zsh")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Optional dependencies
    if ! command -v nvim &> /dev/null; then
        optional_deps+=("neovim")
    fi
    
    if ! command -v fzf &> /dev/null; then
        optional_deps+=("fzf")
    fi
    
    if ! command -v zoxide &> /dev/null; then
        optional_deps+=("zoxide")
    fi
    
    if ! command -v oh-my-posh &> /dev/null; then
        optional_deps+=("oh-my-posh")
    fi
    
    if ! command -v brew &> /dev/null && [[ "$OSTYPE" == "darwin"* ]]; then
        optional_deps+=("homebrew")
    fi
    
    # Report missing required dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        log_error "Please install missing dependencies and try again"
        exit 1
    fi
    
    # Report optional dependencies
    if [[ ${#optional_deps[@]} -gt 0 ]]; then
        log_warning "Optional dependencies not found (some features may not work):"
        for dep in "${optional_deps[@]}"; do
            echo "  - $dep"
        done
    fi
    
    log_success "Dependency check complete"
}

# Install Homebrew packages (macOS only)
install_homebrew_packages() {
    if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
        log_info "Installing recommended Homebrew packages..."
        
        local packages=(
            "fzf"
            "zoxide" 
            "neovim"
            "ripgrep"
            "fd"
            "oh-my-posh"
        )
        
        for package in "${packages[@]}"; do
            if ! brew list "$package" &> /dev/null; then
                log_info "Installing $package..."
                brew install "$package"
            else
                log_info "$package already installed"
            fi
        done
        
        log_success "Homebrew packages installed"
    fi
}

# Change default shell to zsh
change_shell() {
    if [[ "$SHELL" != *"zsh" ]]; then
        log_info "Changing default shell to zsh..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            chsh -s /bin/zsh
        else
            chsh -s $(which zsh)
        fi
        log_success "Default shell changed to zsh (restart your terminal)"
    else
        log_success "zsh is already the default shell"
    fi
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."
    
    check_location
    create_backup
    backup_existing
    check_dependencies
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_homebrew_packages
    fi
    
    create_symlinks
    setup_env
    change_shell
    
    log_success "Installation complete!"
    log_info "Backup created at: $BACKUP_DIR"
    log_info "Please:"
    log_info "1. Edit $DOTFILES_DIR/.env with your actual values"
    log_info "2. Restart your terminal or run: source ~/.zshrc"
    log_info "3. Verify everything works with: validate-dotfiles"
}

# Run main function
main "$@"