dot() {
    nvim $(find ~/dotfiles -type f ! -path "*/.git/*" | fzf --preview 'cat {}')
}

nmd() {
	nvim "$(find ~/My_Sync_Vault -name "*.md" | fzf --preview 'cat {}')"
}


vimedit() {
	nvim +$(cat -n $1 | fzf | awk '{print $1}') $1
}


taskd() {
	task $(task all status.not:deleted | fzf -m | awk '{print $1}') delete
}

myfolder() {
	 cd $(find ~/my-folder -type d | fzf) && ls
 }

paths() {
    local selected
    selected=$(cat -n /Users/lennonallen/my-folder/paths.txt | fzf | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        cd "$selected" && ls
    fi
}
