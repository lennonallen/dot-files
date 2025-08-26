# Directory Chooser Function
cd_choose() {
 local dirs=(
  "$HOME"
  "${MY_SYNC_VAULT:-$HOME/My_Sync_Vault}"
  "$HOME/Desktop"
  "${BACKUPS_DIR:-$HOME/backups}"
  "$HOME/Library/Scripts"
  "$HOME/dotfiles"
  "${TEMP_DIRECTORIES:-$HOME/temp-directories}"
  "${ARCHIVES_DIR:-$HOME/archives}"
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
  local temp_dir="${TEMP_DIRECTORIES:-$HOME/temp-directories}"
  mkdir -p "$temp_dir"
  tmpd=$(mktemp -d "$temp_dir/tmp.XXXXXXXXXX") && cd "$tmpd"
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
# Add a task (REST API)

    todoist() {
    if [[ -z "$TODOIST_API_TOKEN" ]]; then
        echo "Error: TODOIST_API_TOKEN not set. Please set it in your .env file." >&2
        return 1
    fi
    
    local content="$1"
    local due="${2:-}"
    local priority="${3:-1}"
    
    if [[ -z "$content" ]]; then
        echo "Usage: todoist 'task content' ['due date'] [priority]" >&2
        return 1
    fi
    
    curl "https://api.todoist.com/rest/v2/tasks" \
        -X POST \
        --data "{\"content\": \"$content\", \"due_string\": \"$due\", \"due_lang\": \"en\", \"priority\": $priority}" \
        -H "Content-Type: application/json" \
        -H "X-Request-Id: $(uuidgen)" \
        -H "Authorization: Bearer $TODOIST_API_TOKEN"
}

# Usage:
# todoist "Buy Milk" "tomorrow at 12:00" 4
#

proton-sync() {
    if [[ -z "$PROTON_DRIVE_PATH" ]]; then
        echo "Error: PROTON_DRIVE_PATH not set in .env file" >&2
        return 1
    fi
    
    if [[ ! -d "$PROTON_DRIVE_PATH" ]]; then
        echo "Error: ProtonDrive directory not found at $PROTON_DRIVE_PATH" >&2
        return 1
    fi
    
    local current_dir=$(basename "$PWD")
    echo "Syncing $current_dir to ProtonDrive..."
    
    if rsync -av --delete --ignore-errors --exclude-from="$HOME/dotfiles/.rsync_exclude" "$PWD" "$PROTON_DRIVE_PATH"; then
        echo "✓ Sync complete!"
    else
        echo "✗ Sync failed!" >&2
        return 1
    fi
}
# sync drectory to server
server-sync() {
    if [[ -z "$REMOTE_SERVER" || -z "$REMOTE_PATH" ]]; then
        echo "Error: REMOTE_SERVER or REMOTE_PATH not set in .env file" >&2
        return 1
    fi
    
    # Test SSH connection
    if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$REMOTE_SERVER" true 2>/dev/null; then
        echo "Error: Cannot connect to $REMOTE_SERVER" >&2
        return 1
    fi
    
    local current_dir=$(basename "$PWD")
    echo "Syncing $current_dir to $REMOTE_SERVER..."
    
    if rsync -av --delete --ignore-errors --exclude-from="$HOME/dotfiles/.rsync_exclude" "$PWD" "$REMOTE_SERVER:$REMOTE_PATH"; then
        echo "✓ Sync complete!"
    else
        echo "✗ Sync failed!" >&2
        return 1
    fi
}
