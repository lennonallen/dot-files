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

source <(fzf --zsh)

alias fzrm='rm "$(ls -p | fzf)"'

export FZF_DEFAULT_OPTS='--prompt="🔍" --margin 3% --height 80% --layout=reverse --border --color=bg+:240,bg:235,fg:252,header:25,info:166,pointer:161,marker:161,spinner:161,hl:7,hl+:7'
export  FZF_CTRL_T_COMMAND="fd --type file"

bookmark() {
    local selected
    selected=$(cat -n /Users/lennonallen/my-folder/bookmarks.txt | fzf | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        open "$selected"
    fi
}

