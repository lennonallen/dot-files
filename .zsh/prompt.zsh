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
${white}▶ ${reset}" 
