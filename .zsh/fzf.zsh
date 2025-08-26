dot() {
    nvim $(find ~/dotfiles -type f ! -path "*/.git/*" | fzf --preview 'cat {}')
}

nmd() {
	local vault_dir="${MY_SYNC_VAULT:-$HOME/My_Sync_Vault}"
	if [[ ! -d "$vault_dir" ]]; then
		echo "Error: Vault directory not found at $vault_dir" >&2
		return 1
	fi
	nvim "$(find "$vault_dir" -name "*.md" | fzf --preview 'cat {}')"
}


vimedit() {
	nvim +$(cat -n $1 | fzf | awk '{print $1}') $1
}


taskd() {
	task $(task all status.not:deleted | fzf -m | awk '{print $1}') delete
}

myfolder() {
	local folder_dir="${MY_FOLDER:-$HOME/my-folder}"
	if [[ ! -d "$folder_dir" ]]; then
		echo "Error: Folder directory not found at $folder_dir" >&2
		return 1
	fi
	 cd $(find "$folder_dir" -type d | fzf) && ls
 }

paths() {
    local paths_file="${MY_FOLDER:-$HOME/my-folder}/paths.txt"
    if [[ ! -f "$paths_file" ]]; then
        echo "Error: Paths file not found at $paths_file" >&2
        return 1
    fi
    local selected
    selected=$(cat -n "$paths_file" | fzf | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        cd "$selected" && ls
    fi
}

source <(fzf --zsh)

alias fzrm='rm "$(ls -p | fzf)"'

# FZF configuration moved to exports.zsh for better organization

bookmark() {
    local bookmarks_file="${MY_FOLDER:-$HOME/my-folder}/bookmarks.txt"
    if [[ ! -f "$bookmarks_file" ]]; then
        echo "Error: Bookmarks file not found at $bookmarks_file" >&2
        return 1
    fi
    local selected
    selected=$(cat -n "$bookmarks_file" | fzf | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        open "$selected"
    fi
}

