# Auto-start tmux (must be before any other init)
if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null && [[ -n "$TERM" ]]; then
    exec tmux new-session -A -s Terminal-session
fi


ulimit -n 524288
eval "$(starship init zsh)"

# Completions (previously provided by oh-my-zsh)
autoload -Uz compinit && compinit

# History (previously provided by oh-my-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_dups hist_ignore_space hist_verify

# Vi mode — must come before custom bindkeys or they get wiped
bindkey -v

source <(fzf --zsh)

# alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"

# fnm is initialized in ~/.zshenv so non-interactive shells (git hooks
# via lazygit, etc.) also get node on PATH.

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
alias c='open -a "Cursor"'

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
alias gitsync='git config --replace-all remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" && git config remote.origin.prune true && git fetch origin --prune --tags'


# File type specific nvim aliases
alias js="nvim"
alias ts="nvim"
alias toml="nvim"
alias nvo="nvopen"


# Vim to Nvim alias
alias v="nvim"

# Eza command alias 
alias ls="eza -la --icons --created --bytes --all"
alias ll="eza -l "
alias la="eza -la"

#Bun alias
alias b="bun"

# Opencode alias
alias p='ANTHROPIC_API_KEY=x ANTHROPIC_BASE_URL=http://127.0.0.1:3456 OPENCODE_EXPERIMENTAL=1 opencode --port --continue'
alias pweb2='OPENCODE_EXPERIMENTAL=1 OPENCODE_SERVER_PASSWORD="$_OPENCODE_PASSWORD" opencode web --mdns --port 0'
pweb() {
  local tailscale_ip password

  tailscale_ip="$(tailscale ip -4 2>/dev/null | head -n 1)"
  if [[ -z "$tailscale_ip" ]]; then
    echo "Tailscale IP not found. Is Tailscale running?" >&2
    return 1
  fi

  if ! lsof -nP -iTCP:4096 -sTCP:LISTEN >/dev/null 2>&1; then
    OPENCODE_EXPERIMENTAL=1 opencode serve --hostname 127.0.0.1 --port 4096 >/tmp/opencode-web.log 2>&1 &
  fi

  password="${OPENCHAMBER_UI_PASSWORD:-}"
  if [[ -z "$password" ]]; then
    read -rs "password?OpenChamber UI password: "
    echo
  fi

  openchamber stop -p 3000 >/dev/null 2>&1 || true
  OPENCODE_HOST=http://127.0.0.1:4096 \
    OPENCODE_SKIP_START=true \
    OPENCHAMBER_UI_PASSWORD="$password" \
    openchamber --host "$tailscale_ip" --port 3000

  echo "OpenChamber: http://$tailscale_ip:3000/"
}

pwoff() {
  local opencode_pid

  openchamber stop -p 3000 >/dev/null 2>&1 || true

  opencode_pid="$(lsof -tiTCP:4096 -sTCP:LISTEN -c opencode 2>/dev/null | head -n 1)"
  if [[ -n "$opencode_pid" ]]; then
    kill "$opencode_pid"
  fi

  echo "OpenChamber stopped. OpenCode web server stopped if it was running on 4096."
}

# LazyGit: run in-place, cd to the worktree we ended in (if switched)
lg() {
  local tmp
  tmp="$(mktemp -t lazygit-newdir.XXXXXX)"
  LAZYGIT_NEW_DIR_FILE="$tmp" lazygit "$@"
  if [[ -s "$tmp" ]]; then
    builtin cd -- "$(<"$tmp")"
  fi
  rm -f -- "$tmp"
}

. "$HOME/.local/bin/env"

nvopen() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: nvopen <file>"
        return 1
    fi
    nvim "$1"
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

# FZF configuration (^T is rebound to fzf-nvim-widget below, so no CTRL_T vars needed)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--layout=reverse --border=rounded --info=inline --preview "bat {}" --preview-window=right:60%:border-rounded'

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

# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
# <<< oh-my-opencode-slim background subagents <<<
