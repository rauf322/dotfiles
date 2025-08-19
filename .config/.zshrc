export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
echo -ne '\e[2 q'
#Reset PATH to prevent duplication issues
export PATH=""
export XDG_CONFIG_HOME="$HOME/.config"

#PATH TO NODE JS
#System-wide binaries (Keeps default macOS paths intact)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

#Homebrew paths (Ensures Homebrew binaries take precedence)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Apple-specific system paths (Keeps system integrity)
export PATH="/System/Cryptexes/App/usr/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$PATH"
export PATH="/Library/Apple/usr/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"

alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if [[ -z "$TMUX" && -t 1 ]]; then
    exec tmux new-session -A -s Terminal-session
fi

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey -r '^[[Z'

alias reload-zsh="source ~/.zshrc"
# Zsh Autosuggestions & Syntax Highlighting
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Alias for ls to use eza (a better version of ls)
alias ls="eza --icons=always"



# Zoxide (better cd)
eval "$(zoxide init zsh)"

# System Aliases
alias home="cd ~"
alias ..="cd .."
alias x="exit"

#Cursor
alias c="open $1 -a \"Cursor\""

# Git Aliases
alias add="git add"
alias commit="git commit"
alias rebase="git rebase"
alias merge="git merge"
alias pull="git pull"
alias status="git status"
alias push="git push"
alias python="python3"

# ls for . file alias
alias ls.="ls -a"

#Vim to Nvim alias
alias v="nvim ."
alias vim="nvim"
alias v.="nvim ."

#yazi-cwd
export FZF_DEFAULT_COMMAND='find "$PWD" -mindepth 1 -maxdepth 4 \( -type f -o -type d \)'
export EDITOR="nvim"
fcur() {
    file=$(fd --type f --max-depth 1 --hidden --exclude .git | fzf) || return
    cursor --reuse-window "$file"
}
EDITOR="nvim"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
