# =============================================================================
# Git Aliases and Functions
# =============================================================================
# Git-specific shortcuts and utilities for better version control workflow
# =============================================================================

# Git Status and Information
alias gs='git status'
alias gst='git status --short'
alias gl='git log --oneline --graph --decorate --all'
alias gll='git log --graph --pretty=format:"%C(yellow)%h%C(reset) - %C(blue)%an%C(reset), %C(green)%cr%C(reset) : %s"'
alias glo='git log --oneline'

# Git Branch Management
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main'
alias gcd='git checkout develop'

# Git Add and Commit
alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -am'
alias gcf='git commit --fixup'
alias gcs='git commit -S'  # Signed commit
alias gitdate="git add -A && git commit -m 'Update: $(date)'"

# Git Diff and Show
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gdh='git diff HEAD'

# Git Push and Pull
alias gp='git push'
alias gpu='git push -u origin'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gpr='git pull --rebase'

# Git Merge and Rebase
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias gra='git rebase --abort'

# Git Stash
alias gss='git stash'
alias gsp='git stash pop'
alias gsl='git stash list'
alias gsd='git stash drop'

# Git Remote
alias gre='git remote'
alias grev='git remote -v'
alias grea='git remote add'
alias grer='git remote remove'

# Git Clean and Reset
alias gclean='git clean -fd'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias grm='git reset --mixed'

# Git Utilities
alias gwt='git worktree'
alias gtag='git tag'
alias gsh='git show'
alias gcp='git cherry-pick'

# Custom Git Functions

# Quick commit with message
gcom() {
    if [[ -z "$1" ]]; then
        echo "Usage: gcom 'commit message'" >&2
        return 1
    fi
    git add . && git commit -m "$1"
}

# Create and switch to new branch
gnb() {
    if [[ -z "$1" ]]; then
        echo "Usage: gnb 'branch-name'" >&2
        return 1
    fi
    git checkout -b "$1"
}

# Delete local and remote branch
gbdr() {
    if [[ -z "$1" ]]; then
        echo "Usage: gbdr 'branch-name'" >&2
        return 1
    fi
    git branch -d "$1"
    git push origin --delete "$1"
}

# Git log with search
gls() {
    if [[ -z "$1" ]]; then
        echo "Usage: gls 'search-term'" >&2
        return 1
    fi
    git log --grep="$1" --oneline
}

# Show files changed in last commit
glast() {
    git diff --name-only HEAD~1 HEAD
}

# Undo last commit but keep changes
gundo() {
    git reset --soft HEAD~1
}

# Show current branch name
gbname() {
    git rev-parse --abbrev-ref HEAD
}

# Git ignore function - add file to .gitignore
gignore() {
    if [[ -z "$1" ]]; then
        echo "Usage: gignore 'file-or-pattern'" >&2
        return 1
    fi
    echo "$1" >> .gitignore
    git add .gitignore
    echo "Added '$1' to .gitignore"
}