# =============================================================================
# Git Aliases and Functions
# =============================================================================
# Git-specific shortcuts and utilities for better version control workflow
# =============================================================================

# Git Status and Information
alias gs='git status'  # Show working tree status
alias gst='git status --short'  # Show status in short format (compact)
alias gl='git log --oneline --graph --decorate --all'  # Show commit history as graph with decorations for all branches
alias gll='git log --graph --pretty=format:"%C(yellow)%h%C(reset) - %C(blue)%an%C(reset), %C(green)%cr%C(reset) : %s"'  # Detailed colored log with author and relative time
alias glo='git log --oneline'  # Show commit history in compact one-line format

# Git Branch Management
alias gb='git branch'  # List local branches
alias gba='git branch -a'  # List all branches (local and remote)
alias gbd='git branch -d'  # Delete branch (safe, checks if merged)
alias gbD='git branch -D'  # Force delete branch (unsafe, doesn't check if merged)
alias gco='git checkout'  # Switch branches or restore files
alias gcb='git checkout -b'  # Create and switch to new branch
alias gcm='git checkout main'  # Switch to main branch
alias gcd='git checkout develop'  # Switch to develop branch

# Git Add and Commit
alias ga='git add'  # Add files to staging area
alias gaa='git add .'  # Add all files in current directory to staging
alias gap='git add -p'  # Interactively add parts of files to staging (patch mode)
alias gc='git commit'  # Create a commit (opens editor for message)
alias gcm='git commit -m'  # Create commit with message inline
alias gca='git commit -a'  # Commit all modified files (skip staging)
alias gcam='git commit -am'  # Commit all modified files with inline message
alias gcf='git commit --fixup'  # Create fixup commit for later squashing
alias gcs='git commit -S'  # Create signed commit with GPG key
alias gitdate="git add -A && git commit -m 'Update: $(date)'"  # Add all files and commit with current date/time

# Git Diff and Show
alias gd='git diff'  # Show unstaged changes
alias gds='git diff --staged'  # Show staged changes
alias gdt='git difftool'  # Open diff in configured diff tool
alias gdh='git diff HEAD'  # Show all changes since last commit

# Git Push and Pull
alias gp='git push'  # Push commits to remote repository
alias gpu='git push -u origin'  # Push and set upstream tracking to origin
alias gpf='git push --force-with-lease'  # Force push safely (checks for updates first)
alias gpl='git pull'  # Fetch and merge changes from remote
alias gpr='git pull --rebase'  # Fetch and rebase local commits on top of remote changes

# Git Merge and Rebase
alias gm='git merge'  # Merge another branch into current branch
alias gr='git rebase'  # Reapply commits on top of another branch
alias gri='git rebase -i'  # Interactive rebase (edit, squash, reorder commits)
alias grc='git rebase --continue'  # Continue rebase after resolving conflicts
alias gra='git rebase --abort'  # Cancel rebase and return to original state

# Git Stash
alias gss='git stash'  # Temporarily save uncommitted changes
alias gsp='git stash pop'  # Apply most recent stash and remove it from stash list
alias gsl='git stash list'  # Show list of all stashes
alias gsd='git stash drop'  # Delete a stash without applying it

# Git Remote
alias gre='git remote'  # List remote repositories
alias grev='git remote -v'  # List remote repositories with URLs
alias grea='git remote add'  # Add new remote repository
alias grer='git remote remove'  # Remove remote repository

# Git Clean and Reset
alias gclean='git clean -fd'  # Remove untracked files and directories
alias grh='git reset --hard'  # Reset working directory and index to match commit (loses changes)
alias grs='git reset --soft'  # Reset to commit but keep changes in staging area
alias grm='git reset --mixed'  # Reset to commit but keep changes in working directory (default)

# Git Utilities
alias gwt='git worktree'  # Manage multiple working trees
alias gtag='git tag'  # Create, list, or delete tags
alias gsh='git show'  # Show commit details and diff
alias gcp='git cherry-pick'  # Apply specific commit to current branch

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
