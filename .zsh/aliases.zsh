alias ll="ls -la"
alias gitdirs="find . -name '.git' -type d | sed 's|/.git||'"
alias zshrc='subl ~/.zshrc'
alias t5='cd /Volumes/Samsung_T5'
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias h="history"
alias c="clear"
alias home="cd ~"
alias gitdate="git add -A && git commit -m 'Update: $(date)'"
alias backup_obsidian='rsync -a -r -v --exclude='.git' --exclude='.gitignore' --delete ~/My_Sync_Vault ~/backups'
alias restore_obsidian='rsync -a -r -v --exclude='.git' --exclude='.gitignore' ~/Desktop/back_up_desktop/My_Sync_Vault/ ~/My_Sync_Vault/' 
alias reload='source ~/.zshrc' 
alias cds="cd_choose"
alias usb-sync="bash '/Volumes/Samsung USB/sync_to_usb.sh'"

# --- Safety Aliases ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i' 