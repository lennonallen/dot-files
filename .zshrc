# =========================
# Modular Zsh Config Sourcing
# =========================
# Source all .zsh files from ~/dotfiles/.zsh directory for modular configuration
if [ -d "$HOME/dotfiles/.zsh" ]; then
  for config_file in "$HOME/dotfiles/.zsh"/*.zsh; do
    [ -r "$config_file" ] && source "$config_file"
  done
fi

# (Other configuration can go here if needed)
# Existing aliases, functions, and other config have been moved to ~/.zsh/*.zsh files for modularity.# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/lennonallen/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
# Add this to your ~/.zshrc file:
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/ohmyposh_theme.omp.json)"


export EDITOR=nvim
