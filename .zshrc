# =========================
# Color and Formatting Vars
# =========================
orange=$(tput setaf 166)
yellow=$(tput setaf 228)
green=$(tput setaf 71)
white=$(tput setaf 15)
red=$(tput setaf 196)
cyan=$(tput setaf 51)
bold=$(tput bold)
reset=$(tput sgr0)

# =============
# Functions
# =============
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


# =====================
# Prompt Configuration
# =====================

# Enable command substitution

setopt PROMPT_SUBST

# Build the prompt with git dirty status

PROMPT="${bold}
${orange}%n${white} at ${yellow}%m${white} in ${green}%~${white}\$(git_dirty_status)
${white}▶ ${reset}"

# =========
# Aliases
# =========

alias ll="ls -la"
alias gitdirs="find . -name '.git' -type d | sed 's|/.git||'"
alias zshrc='subl ~/.zshrc'
alias t5='cd /Volumes/Samsung_T5'
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias h="history"
alias c="clear"
alias o="cd ~/My_Sync_Vault"
alias home="cd ~"
alias desktop="cd ~/Desktop"
alias gitdate="git add -A && git commit -m 'Update: $(date)'"
alias dot="cd ~/dotfiles"
alias scripts='cd ~/Library/Scripts'
alias backup_obsidian='rsync -a -r -v --exclude='.git' --exclude='.gitignore' --delete ~/My_Sync_Vault ~/backups'
alias restore_obsidian='rsync -a -r -v --exclude='.git' --exclude='.gitignore' ~/Desktop/back_up_desktop/My_Sync_Vault/ ~/My_Sync_Vault/'