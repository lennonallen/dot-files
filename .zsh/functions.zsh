# Directory Chooser Function
cd_choose() {
 local dirs=(
  "$HOME"
  "$HOME/My_Sync_Vault"
  "$HOME/Desktop"
  "$HOME/backups"
  "$HOME/Library/Scripts"
  "$HOME/dotfiles"
  "$HOME/temp-directories"
  "$HOME/archives"
 )
  echo "Choose a directory:"
  select dir in "${dirs[@]}"; do
    if [[ -n "$dir" ]]; then
      cd "$dir"
      break
    else
      echo "Invalid selection."
    fi
  done
}

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; } 

# Extract almost any archive type, with optional cleanup
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via extract()" ; return 1 ;;
    esac
    # Prompt for cleanup
    echo "Delete archive $1 after extraction? (y/N)"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      /bin/rm -f -- "$1"
      echo "Archive $1 deleted."
    else
      echo "Archive $1 kept."
    fi
  else
    echo "'$1' is not a valid file"
  fi
}

# Make and enter a temporary directory inside ~/temp-directories
mktmpd() {
  mkdir -p "$HOME/temp-directories"
  tmpd=$(mktemp -d "$HOME/temp-directories/tmp.XXXXXXXXXX") && cd "$tmpd"
} 

# Delete all contents of the current directory (with confirmation)
emptydir() {
  echo "Are you sure you want to delete ALL contents of $(pwd)? (y/N)"
  read -r answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    setopt null_glob
    /bin/rm -rf ./* ./.??*
    echo "Directory emptied."
  else
    echo "Aborted."
  fi
} 

# sync drectory to server
server-sync() {
    echo "Syncing $(basename "$PWD") to server..."
    rsync -av --delete --ignore-errors --exclude='.git' --exclude='.gitignore' --exclude='.gitconfig' --exclude='.gitignore_global' "$PWD" ssh macmini:~/Server
    echo "✓ Sync complete!"
}

# Add a task (REST API)

    todoist() {
    local content="$1"
    local due="${2:-}"
    local priority="${3:-1}"
    
    curl "https://api.todoist.com/rest/v2/tasks" \
        -X POST \
        --data "{\"content\": \"$content\", \"due_string\": \"$due\", \"due_lang\": \"en\", \"priority\": $priority}" \
        -H "Content-Type: application/json" \
        -H "X-Request-Id: $(uuidgen)" \
        -H "Authorization: Bearer b142f47bb9363d5e65455800f36c65efaffc2b4a"
}

# Usage:
# todoist "Buy Milk" "tomorrow at 12:00" 4
