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
alias cdf="cd_choose"

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