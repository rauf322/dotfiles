# Enable Powerlevel10k instant prompt (This should be close to the top of ~/.zshrc).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k theme setup (Ensure it's sourced only once)
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Zsh Autosuggestions setup
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh Syntax Highlighting setup
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Alias for ls to use eza (a better version of ls)
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# Ensure the right Nerd Font is installed for Powerlevel10k and Alacritty
# (e.g., Hack Nerd Font or any compatible Nerd Font)
# Install font if it's not installed:
# brew install --cask font-hack-nerd-font

# Set PATH for Node.js installed via Homebrew (Correct usage)
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# Verify Node.js is correctly set up
if ! command -v node >/dev/null; then
  echo "Warning: Node.js is not installed or not in PATH."
fi



export BASH_SILENCE_DEPRECATION_WARNING=1
