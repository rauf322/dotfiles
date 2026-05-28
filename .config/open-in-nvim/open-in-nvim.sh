#!/usr/bin/env bash
# Route a file open into the running nvim instance, fall back to a fresh window.
# Used by the Automator "open-in-nvim.app" wrapper that duti points file
# associations at, and can be invoked directly from anywhere.
#
# IMPORTANT: when invoked via Finder/Automator, PATH is minimal and does not
# include Homebrew. We resolve nvim explicitly.

set -e

# Pick the first nvim we can find. Homebrew on Apple Silicon vs Intel vs custom.
NVIM=""
for candidate in /opt/homebrew/bin/nvim /usr/local/bin/nvim "$HOME/.local/bin/nvim" "$(command -v nvim 2>/dev/null)"; do
  if [[ -n "$candidate" && -x "$candidate" ]]; then
    NVIM="$candidate"
    break
  fi
done
if [[ -z "$NVIM" ]]; then
  osascript -e 'display dialog "open-in-nvim: nvim binary not found." buttons {"OK"} default button "OK"'
  exit 1
fi

FILE="${1:-}"
[[ -z "$FILE" ]] && exit 0

# Resolve to an absolute path so --remote-tab works regardless of cwd.
if [[ -e "$FILE" ]]; then
  FILE="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"
fi

SOCK="/tmp/nvim-server.pipe"

# If a stable nvim socket is alive (probe it with --remote-expr), route there.
if [[ -S "$SOCK" ]] && "$NVIM" --server "$SOCK" --remote-expr "1" >/dev/null 2>&1; then
  exec "$NVIM" --server "$SOCK" --remote-tab "$FILE"
fi

# Fallback: open a new Ghostty window running nvim with that file.
# Ghostty's -e takes the program + args as separate values, so we use
# `--command=` to pass a single shell-escaped string.
QUOTED=$(printf '%q' "$FILE")
exec open -na Ghostty --args --command="$NVIM $QUOTED"
