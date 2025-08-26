# =============================================================================
# Shell Prompt Configuration
# =============================================================================
# This file configures the shell prompt using oh-my-posh
# =============================================================================

# Initialize oh-my-posh if available
if command -v oh-my-posh >/dev/null 2>&1; then
    # Check if custom theme exists, otherwise use default
    if [[ -f "$HOME/.config/oh-my-posh/themes/ohmyposh_theme.omp.json" ]]; then
        eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/ohmyposh_theme.omp.json)"
    else
        # Fallback to a default theme if custom theme doesn't exist
        eval "$(oh-my-posh init zsh)"
    fi
else
    # Fallback simple prompt if oh-my-posh is not available
    autoload -Uz vcs_info
    precmd() { vcs_info }
    
    zstyle ':vcs_info:git:*' formats '%b '
    
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%1~%f %F{red}${vcs_info_msg_0_}%f$ '
fi