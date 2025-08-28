# =============================================================================
# Environment Variables and PATH Configuration
# =============================================================================
# This file contains environment variables and PATH modifications
# Source this file in your .zshrc
# =============================================================================

# Source sensitive environment variables
[[ -f "$HOME/dotfiles/.env" ]] && source "$HOME/dotfiles/.env"

# Editor and Pager
export EDITOR="${EDITOR:-nvim}"
export PAGER="${PAGER:-less}"

# PATH modifications
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.npm-global/bin:$PATH" 

# Less configuration for better pager experience
export LESS='-R -S -M -i -j5'
export LESSHISTFILE='-'

# History configuration
export HISTSIZE=50000
export HISTFILESIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.zsh_history"

# Language and locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Development tools
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

# FZF configuration
export FZF_DEFAULT_OPTS='--prompt="🔍" --margin 3% --height 80% --layout=reverse --border --color=bg+:240,bg:235,fg:252,header:25,info:166,pointer:161,marker:161,spinner:161,hl:7,hl+:7'
export FZF_CTRL_T_COMMAND="fd --type file"

# Zoxide configuration
export _ZO_ECHO=1
