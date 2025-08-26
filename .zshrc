# =========================
# Modular Zsh Config Sourcing
# =========================
# Source all .zsh files from ~/dotfiles/.zsh directory for modular configuration
if [ -d "$HOME/dotfiles/.zsh" ]; then
  # Source in specific order to ensure dependencies are loaded first
  local config_files=(
    "exports.zsh"      # Environment variables first
    "completions.zsh"  # Completions setup
    "prompt.zsh"       # Prompt configuration
    "aliases.zsh"      # Aliases
    "functions.zsh"    # Custom functions
    "fzf.zsh"         # FZF integration
    "zoxide.zsh"      # Zoxide configuration
  )
  
  for config_file in "${config_files[@]}"; do
    local full_path="$HOME/dotfiles/.zsh/$config_file"
    [ -r "$full_path" ] && source "$full_path"
  done
  
  # Source any additional .zsh files not in the ordered list
  for config_file in "$HOME/dotfiles/.zsh"/*.zsh; do
    local basename=$(basename "$config_file")
    if [[ ! " ${config_files[*]} " =~ " ${basename} " ]]; then
      [ -r "$config_file" ] && source "$config_file"
    fi
  done
fi
