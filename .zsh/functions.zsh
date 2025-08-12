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

# Find files by name (case-insensitive)
ff() { find . -iname "*$1*"; }

# Find and grep for a pattern
fgr() { grep -rnw . -e "$1"; }

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

# List all custom functions defined in this file
myfuncs() {
  awk '/\{$/ && /^[a-zA-Z_]/ { print $1 }' ~/dotfiles/.zsh/functions.zsh | sort
} 

# sync drectory to server
server-sync() {
    echo "Syncing $(basename "$PWD") to server..."
    rsync -av --delete --ignore-errors --exclude='.git' --exclude='.gitignore' --exclude='.gitconfig' --exclude='.gitignore_global' "$PWD" ssh macmini:~/Server
    echo "✓ Sync complete!"
}

# Quickly add a Taskwarrior task with prompts
tadd() {
  if ! command -v task >/dev/null 2>&1; then
    echo "Taskwarrior ('task') not found. Install it first."
    return 1
  fi

  local description project due priority tags_input tag

  printf "Task description: "
  read -r description
  if [[ -z "$description" ]]; then
    echo "Aborted: description is required."
    return 1
  fi

  printf "Project (optional): "
  read -r project

  printf "Due (e.g., tomorrow, 2025-08-09) (optional): "
  read -r due

  printf "Priority [H/M/L] (optional): "
  read -r priority
  if [[ "$priority" != "H" && "$priority" != "M" && "$priority" != "L" ]]; then
    priority=""
  fi

  printf "Tags (space or comma-separated, optional): "
  read -r tags_input

  local cmd
  cmd=(task add)

  if [[ -n "$project" ]]; then
    cmd+=("project:$project")
  fi
  if [[ -n "$due" ]]; then
    cmd+=("due:$due")
  fi
  if [[ -n "$priority" ]]; then
    cmd+=("priority:$priority")
  fi
  if [[ -n "$tags_input" ]]; then
    tags_input="${tags_input//,/ }"
    for tag in $tags_input; do
      [[ -n "$tag" ]] && cmd+=("+$tag")
    done
  fi

  cmd+=("$description")

  printf "Adding: "
  printf "%q " "${cmd[@]}"
  echo
  "${cmd[@]}"
}

twt() { task "$1" modify wait:tomorrow; }

# fd - cd to selected directory

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
