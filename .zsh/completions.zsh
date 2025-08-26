# =============================================================================
# Shell Completions Configuration
# =============================================================================
# This file sets up command completions for various tools
# =============================================================================

# Enable completion system
autoload -Uz compinit
compinit

# Docker CLI completions
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=($HOME/.docker/completions $fpath)
fi

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Git completion
autoload -Uz bashcompinit && bashcompinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu select for completions
zstyle ':completion:*' menu select

# Group completions by type
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# Show completion for hidden files
zstyle ':completion:*' file-patterns '*:all-files'

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"