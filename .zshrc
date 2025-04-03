export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

alias tmux="tmux -f /Users/rauffaizov/.config/tmux/.tmux.conf"

if [[ -z "$TMUX" && -t 1 ]]; then
    if ps -o command= -p $PPID | grep -qi "Cursor Helper"; then
        exec tmux new-session -A -s Cursor-session
    else
        exec tmux new-session -A -s Terminal-session
    fi
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

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Zoxide (better cd)
eval "$(zoxide init zsh)"

# System Aliases
alias home="cd ~"
alias ..="cd .."
alias x="exit"


#Cursor
alias c=cursor


# Reset PATH to prevent duplication issues
export PATH=""

#PATH TO NODE JS
export PATH="$HOME/.nvm/versions/node/v22.14.0/bin:$PATH"
# System-wide binaries (Keeps default macOS paths intact)
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Homebrew paths (Ensures Homebrew binaries take precedence)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Apple-specific system paths (Keeps system integrity)
export PATH="/System/Cryptexes/App/usr/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:$PATH"
export PATH="/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$PATH"
export PATH="/Library/Apple/usr/bin:$PATH"


# Git Aliases
alias add="git add"
alias commit="git commit"
alias pull="git pull"
alias stat="git status"
alias push="git push"
alias python="python3"


alias ls.="ls -a"
