# Auto-start tmux (must be before any other init)
if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null && [[ -n "$TERM" ]]; then
    exec tmux new-session -A -s Terminal-session
fi

export ZSH="$HOME/.oh-my-zsh"
ulimit -n 524288
# ZSH_THEME="robbyrussell"
eval "$(starship init zsh)"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

# alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"

# fnm (fast node manager) - replaces nvm
eval "$(fnm env --use-on-cd --shell zsh)"

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey -r '^[[Z'

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


# Vim to Nvim alias
alias v="nvim"

# Eza command alias 
alias ls="eza -la --icons --created --bytes --all"
alias ll="eza -l "
alias la="eza -la"

#Bun alias
alias b="bun"

# Opencode alias
alias p='pgrep -f "meridian$" > /dev/null || (MERIDIAN_PASSTHROUGH=1 meridian > /dev/null 2>&1 &); ANTHROPIC_API_KEY=dummy ANTHROPIC_BASE_URL=http://127.0.0.1:3456 opencode --continue --port 0'
alias pweb='pgrep -f "meridian$" > /dev/null || (MERIDIAN_PASSTHROUGH=1 meridian > /dev/null 2>&1 &); ANTHROPIC_API_KEY=dummy ANTHROPIC_BASE_URL=http://127.0.0.1:3456 OPENCODE_SERVER_PASSWORD="$_OPENCODE_PASSWORD" opencode web --mdns --port 0'

# LazyGit alias
alias lg="ghostty --config-file=$HOME/.config/ghostty/config --config='font-size=12' -e lazygit"

. "$HOME/.local/bin/env"

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


#yazi-cwd
fcur() {
    file=$(fd --type f --max-depth 1 --hidden --exclude .git | fzf) || return
    cursor --reuse-window "$file"
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

bindkey -v

# Cursor shape - keep a steady block at the shell prompt
reset_cursor_block() {
  echo -ne '\e[2 q'
}

precmd_functions+=(reset_cursor_block)

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--layout=reverse --border=rounded --info=inline --preview "bat {}" --preview-window=right:60%:border-rounded'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat {}' --preview-window=right:60%:border-rounded"

# FZF shell integration (already loaded via `source <(fzf --zsh)` above)

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


# bun completions
[ -s "/Users/rauffaizov/.bun/_bun" ] && source "/Users/rauffaizov/.bun/_bun"
