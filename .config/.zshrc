export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
export EDITOR=nvim
export VISUAL=nvim
eval "$(starship init zsh)"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
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

# Ghostty
export GHOSTTY_BIN_DIR="/Applications/Ghostty.app/Contents/MacOS"
export PATH="$GHOSTTY_BIN_DIR:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"

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
alias switch="git switch"
alias rebase="git rebase"
alias merge="git merge"
alias pull="git pull"
alias status="git status"
alias push="git push"
alias python="python3"


# File type specific nvim aliases
alias js="nvim"
alias ts="nvim"
alias toml="nvim"
alias nvo="nvopen-file"

# Function to open files with nvim based on extension
nvopen() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvopen <file>"
        return 1
    fi

    local file="$1"
    case "${file##*.}" in
        js|ts|tsx|jsx|json|toml|yaml|yml|md|txt|py|sh|zsh|bash|conf|config)
            nvim "$file"
            ;;
        *)
            echo "Opening with nvim anyway..."
            nvim "$file"
            ;;
    esac
}

 # Vim to Nvim alias
alias v="nvim"

#yazi-cwd
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
bindkey -v

# Cursor shape for vi mode - steady block in normal, blinking thin line for insert
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'  # steady block for normal mode
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'  # blinking thin line for insert mode
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'  # blinking thin line for insert mode
}
zle -N zle-line-init

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--layout=reverse --border=rounded --info=inline --preview "bat {}" --preview-window=right:60%:border-rounded'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat {}' --preview-window=right:60%:border-rounded"

# FZF shell integration
source /opt/homebrew/Cellar/fzf/0.66.1/shell/key-bindings.zsh
source /opt/homebrew/Cellar/fzf/0.66.1/shell/completion.zsh

# Custom widget to open file in nvim with Ctrl+T (must be after sourcing FZF)
fzf-nvim-widget() {
  local selected
  selected=$(eval "$FZF_DEFAULT_COMMAND" | fzf --layout=reverse --border=rounded --info=inline --preview 'bat {}' --preview-window=right:60%:border-rounded)
  if [[ -n "$selected" ]]; then
    BUFFER="nvim $selected"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-nvim-widget
bindkey '^T' fzf-nvim-widget

alias ls="eza -la --icons --created --bytes --all"
alias ll="eza -l "
alias la="eza -la"
alias b="bun"
alias p="opencode --port"
alias lg="ghostty --config-file=$HOME/.config/ghostty/config --config='font-size=12' -e lazygit"

. "$HOME/.local/bin/env"


# Load Angular CLI autocompletion.
source <(ng completion script)

# bun completions
[ -s "/Users/rauffaizov/.bun/_bun" ] && source "/Users/rauffaizov/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
