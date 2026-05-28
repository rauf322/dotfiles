#!/usr/bin/env bash
# Register text/source-code file associations to open-in-nvim.app via duti.
# Run this AFTER creating the Automator app (see comments at top of file).
#
# === Prerequisites ===
# 1. Build ~/.local/bin/open-in-nvim.sh (already exists if you followed setup).
# 2. Create Automator app:
#    - Open /System/Applications/Automator.app → New Application
#    - Add action: "Utilities" → "Run Shell Script"
#    - Shell: /bin/bash  ·  Pass input: "as arguments"
#    - Script body (exact):
#        for f in "$@"; do
#          /Users/rauffaizov/.local/bin/open-in-nvim.sh "$f"
#        done
#    - Save as "open-in-nvim" in /Applications/
# 3. Confirm bundle ID:
#      osascript -e 'id of app "open-in-nvim"'
#    Paste it into BUNDLE below if it differs.
#
# === What this does ===
# - Registers BUNDLE as the handler for broad UTI hierarchies (catches most
#   source/text files via inheritance).
# - Then belt-and-suspenders explicit extensions in case the UTI mapping is
#   wrong on your system.
# - To undo: `duti -s <other-bundle-id> <ext> all` per extension, or use
#   Finder → Get Info → Open With → Change All.

set -u

BUNDLE="com.apple.automator.open-in-nvim"

if ! command -v duti >/dev/null 2>&1; then
  echo "duti not installed. brew install duti" >&2
  exit 1
fi

if ! osascript -e 'id of app "open-in-nvim"' >/dev/null 2>&1; then
  echo "Automator app 'open-in-nvim' not found. Create it first (see header)." >&2
  exit 1
fi

echo "Registering UTI hierarchies → $BUNDLE"
for UTI in \
  public.plain-text \
  public.text \
  public.source-code \
  public.script \
  public.shell-script \
  public.python-script \
  public.ruby-script \
  public.perl-script \
  public.json \
  public.xml \
  public.yaml \
  com.netscape.javascript-source \
  com.apple.property-list \
  net.daringfireball.markdown ; do
  duti -s "$BUNDLE" "$UTI" all || true
done

echo "Registering explicit extensions → $BUNDLE"
EXTS=(
  txt md mdx markdown rst adoc org
  json jsonc json5 yaml yml toml xml ini cfg conf env editorconfig gitignore gitattributes
  html htm css scss sass less
  js jsx mjs cjs ts tsx mts cts
  lua vim
  py pyi pyx pyw rb erb rake go rs swift kt kts scala clj cljs cljc edn
  c cc cpp cxx h hh hpp hxx mm m
  java groovy gradle
  sh bash zsh fish ksh
  sql graphql gql proto
  dockerfile dockerignore makefile mk
  diff patch log
  tex bib
)
for EXT in "${EXTS[@]}"; do
  duti -s "$BUNDLE" "$EXT" all || true
done

echo "Done. Verify with: duti -x js   (should print open-in-nvim path + $BUNDLE)"
