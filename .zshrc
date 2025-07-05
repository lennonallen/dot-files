# Custom Zsh Prompt with Git Dirty Status - Add to ~/.zshrc

# Define colors using tput (cross-platform)
orange=$(tput setaf 166)
yellow=$(tput setaf 228)
green=$(tput setaf 71)
white=$(tput setaf 15)
red=$(tput setaf 196)
cyan=$(tput setaf 51)
bold=$(tput bold)
reset=$(tput sgr0)

# Git dirty status function
git_dirty_status() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        local git_status=$(git status --porcelain 2>/dev/null)
        if [ "$git_status" ]; then
            echo " on ${red}${branch}${white}"  # Red if dirty
        else
            echo " on ${cyan}${branch}${white}"  # Cyan if clean
        fi
    fi
}

# Enable command substitution
setopt PROMPT_SUBST

# Build the prompt with git dirty status
PROMPT="${bold}
${orange}%n${white} at ${yellow}%m${white} in ${green}%~${white}\$(git_dirty_status)
${white}$ ${reset}"

# Single line version:
# PROMPT="${bold}${orange}%n${white} at ${yellow}%m${white} in ${green}%~${white}\$(git_dirty_status) ${white}$ ${reset}"



# Aliases
alias ll="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias h="history"
alias c="clear"
alias o="cd ~/My_Sync_Vault"
alias home="cd ~"
alias desktop="cd ~/Desktop"
alias backup="/Users/lennonallen/scripts/obsidian_backup.sh"
alias gitdate="git add -A && git commit -m 'Update: $(date)'"

# Edit ~/.zshrc
nano ~/.zshrc

# Replace your note function with this absolute path version:
note() {
    if [ -z "$1" ]; then
        subl "Usage: note 'filename'"
        return 1
    fi
    
    filename="$1"
    # Use absolute path so it works from anywhere
    filepath="/Users/lennonallen/My_Sync_Vault/${filename}.md"
    
    # Create empty note
    touch "$filepath"
    
    # Open it for editing
    subl "$filepath"
}


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


#fzf cd shortcut
cdt() {
    cd "$1" 2>/dev/null || return
    local selected=$(fzf --preview 'cat {}' --preview-window=right:60%:wrap)
    if [[ -n "$selected" ]]; then
        print -z "$selected"  # This puts the selection on the command line
    fi
}