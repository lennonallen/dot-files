# =============================================================================
# Useful ZSH Aliases
# =============================================================================
# Source this file in your .zshrc: source ~/.zshrc_aliases
# =============================================================================

# =============================================================================
# NAVIGATION & DIRECTORY OPERATIONS
# =============================================================================

# Enhanced directory listing
alias ll='ls -alF'                 # Long listing with file types
alias la='ls -A'                   # List all files except . and ..
alias l='ls -CF'                   # List in columns with file types
alias ls='ls --color=auto'         # Colorized ls output
alias lh='ls -lah'                 # Human readable file sizes
alias lt='ls -lat'                 # Sort by time, newest first
alias ltr='ls -latr'               # Sort by time, oldest first
alias lsize='ls -laSh'             # Sort by size, largest first

# Quick directory navigation
alias ..='cd ..'
alias home='cd ~ && clear'
alias desk='cd ~/Desktop'
alias docs='cd ~/Documents'
alias down='cd ~/Downloads'
alias cdl='cd "$1" && ls'          # CD and list contents

# Directory operations
alias md='mkdir -p'                # Create directory and parents
alias rd='rmdir'                   # Remove directory


# =============================================================================
# FILE OPERATIONS
# =============================================================================

# File operations
alias cp='cp -i'                   # Prompt before overwrite
alias mv='mv -i'                   # Prompt before overwrite
alias rm='rm -i'                   # Prompt before delete
alias rmd='rm -rf'                 # Remove directory and contents

# Search and find
alias grep='grep --color=auto'     # Colorized grep
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# File viewing
alias cat='cat -n'                 # Show line numbers

# =============================================================================
# SYSTEM & PROCESS MANAGEMENT
# =============================================================================

# Process management
alias ps='ps aux'                  # Show all processes
alias psg='ps aux | grep'          # Search processes
alias top='top -o cpu'             # Sort top by CPU usage
alias htop='htop'                  # Better top alternative

# System information
alias path='echo -e ${PATH//:/\\n}' # Print PATH on separate lines
alias ports='lsof -i -P -n | grep LISTEN' # Show listening ports
alias myip='curl -s ifconfig.me'   # Get external IP
alias localip='ifconfig | grep "inet " | grep -v 127.0.0.1'

# System shortcuts
alias c='clear'                    # Clear terminal
alias h='history'                  # Show command history
alias j='jobs -l'                  # List active jobs
alias reload='source ~/.zshrc'    # Reload zsh config

# =============================================================================
# MACOS SPECIFIC ALIASES
# =============================================================================

# macOS specific commands
alias brewup='brew update && brew upgrade'      # Update Homebrew
alias cask='brew install --cask'                # Install cask apps
alias flushdns='sudo dscacheutil -flushcache'   # Flush DNS cache
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder' # Show hidden files
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'  # Hide hidden files
alias dsclean='find . -name ".DS_Store" -delete' # Remove .DS_Store files

# Set docker aliases
alias cdkr='cd ~/docker'
alias down='docker compose down -v'
alias up='docker compose up -d'
alias inspect='docker inspect'
alias del='docker rm'
alias logs='docker logs -f'
alias ddf='docker system df'
alias dlist='docker ps -a --format "table {{.Names}}"'


#ranger 
alias rr='ranger-cd'
