# open-in-nvim — system-wide nvim routing on macOS

A setup that routes any text/source file opened from Finder, `lazygit`, or any
OS-level "open" call into the running Neovim instance (or spawns a fresh
Ghostty + nvim if no instance is running).

**Zero nvim plugins.** Built on `duti` + an Automator wrapper + nvim's built-in
`--server` / `--remote-tab` flags.

## What this gives you

- Double-click any source file in Finder → opens in your running nvim as a new tab.
- `o` (open) in lazygit → routes to running nvim (instead of Chrome/VS Code).
- `e` (edit) in lazygit → opens in running nvim same-tab.
- Files of unfamiliar extensions still fall through to whatever OS default is set.
- Without a running nvim: a fresh Ghostty window pops up running nvim on the file.

## Architecture

```
double-click foo.lua in Finder
   │
   ▼
macOS LaunchServices  (looks up duti registration for .lua)
   │
   ▼
/Applications/open-in-nvim.app  (Automator Application)
   │  forwards file path as $1
   ▼
~/.local/bin/open-in-nvim.sh  (wrapper)
   │  probes /tmp/nvim-server.pipe
   ├── socket alive → nvim --server SOCK --remote-tab "$FILE"
   └── socket dead  → open -na Ghostty --args --command="nvim $FILE"
```

The running nvim binds the socket at startup via this line in
`~/.config/nvim/lua/bitrift/set.lua`:

```lua
pcall(vim.fn.serverstart, "/tmp/nvim-server.pipe")
```

---

## Fresh-Mac setup (~10 min)

### 0. Prerequisites

```bash
brew install neovim duti
brew install --cask ghostty   # or your terminal of choice; adjust wrapper
```

Confirm:
```bash
which nvim duti
ls /Applications | grep -i ghostty
```

### 1. Install the wrapper scripts

The two scripts are in this directory. Copy them into `~/.local/bin/` and make
executable:

```bash
mkdir -p ~/.local/bin
cp ~/.config/open-in-nvim/open-in-nvim.sh ~/.local/bin/
cp ~/.config/open-in-nvim/register-nvim-associations.sh ~/.local/bin/
chmod +x ~/.local/bin/open-in-nvim.sh ~/.local/bin/register-nvim-associations.sh
```

### 2. Make nvim listen on the stable socket

Verify this line exists near the top of `~/.config/nvim/lua/bitrift/set.lua`:

```lua
pcall(vim.fn.serverstart, "/tmp/nvim-server.pipe")
```

Restart nvim and check:
```bash
ls -la /tmp/nvim-server.pipe   # should show 'srwxr-xr-x' (socket)
```

### 3. Verify the wrapper routes correctly

With nvim running:
```bash
~/.local/bin/open-in-nvim.sh ~/.config/nvim/init.lua
```
The file should open as a new tab in the running nvim.

### 4. Build the Automator wrapper app

Automator only registers `.app` bundles, so we wrap the script in a tiny
Application.

1. Open `/System/Applications/Automator.app`.
2. **File → New → Application** (must be Application, not Workflow).
3. Search **Run Shell Script** in the left sidebar, drag into the workflow.
4. Settings:
   - **Shell**: `/bin/bash`
   - **Pass input**: `as arguments` ← CRITICAL, default is "to stdin"
5. Script body (exactly):
   ```bash
   for f in "$@"; do
     ~/.local/bin/open-in-nvim.sh "$f"
   done
   ```
6. **File → Save** → name `open-in-nvim` → location `/Applications/`.

Confirm the bundle ID:
```bash
osascript -e 'id of app "open-in-nvim"'
# expected: com.apple.automator.open-in-nvim
```

If the bundle ID differs, edit the `BUNDLE=` line at the top of
`~/.local/bin/register-nvim-associations.sh`.

### 5. Register file associations

```bash
~/.local/bin/register-nvim-associations.sh
```

Verify:
```bash
duti -x lua    # should print: open-in-nvim, /Applications/open-in-nvim.app, com.apple.automator.open-in-nvim
duti -x js
duti -x ts
```

### 6. Lazygit config

Ensure `~/.config/lazygit/config.yml` has:
```yaml
os:
  editPreset: nvim-remote
```

This makes `e` in lazygit open files in the running nvim. The `o` key uses
macOS `open` which now goes through duti → wrapper → running nvim
automatically.

### 7. End-to-end test

1. Open Finder → navigate to any `.lua` / `.ts` / `.tsx` file.
2. Double-click → should land as a new tab in the running nvim.
3. Quit all nvims, then double-click again → should spawn a new Ghostty
   window with nvim on that file.

---

## Troubleshooting

### Double-click opens the wrong app
- Re-run the duti registration: `~/.local/bin/register-nvim-associations.sh`
- Chrome/VS Code occasionally re-claim `.js`/`.ts` after updates.

### File opens in Ghostty instead of running nvim
The wrapper's socket probe is failing. Causes:
- Socket file is stale (nvim crashed). Just restart nvim.
- nvim isn't where the wrapper expects. Check the `candidate` loop in
  `~/.local/bin/open-in-nvim.sh`.
- PATH is stripped at Finder launch — wrapper hardcodes `/opt/homebrew/bin/nvim`
  and `/usr/local/bin/nvim`; add more candidates if your nvim lives elsewhere.

### Nothing happens on double-click
The Automator action's "Pass input" is set to `to stdin`. Fix:
- Open `/Applications/open-in-nvim.app` in Automator
- Click the Run Shell Script action
- Top-right dropdown → change to `as arguments` → save.

Diagnostic — temporarily replace the script body with:
```bash
echo "fired: $#  args: $*" >> /tmp/open-in-nvim.log
date >> /tmp/open-in-nvim.log
for f in "$@"; do
  ~/.local/bin/open-in-nvim.sh "$f"
done
```
Then `rm -f /tmp/open-in-nvim.log && open -a open-in-nvim ~/some/file.lua && cat /tmp/open-in-nvim.log`.

### Two nvims running, opens go to the wrong one
Only the first nvim claims the socket. Predictable but inflexible. If you
need per-window routing, look into `nvr` (`brew install neovim-remote`) and
per-session socket files.

### Undo a single extension
```bash
duti -s com.apple.dt.Xcode lua all   # or whichever app you want back
```

### Undo everything
Inspect current mapping with `duti -x <ext>`, then re-register the original
app via `duti -s`. There is no bulk-revert command.

---

## Files in this repo / dir

- `README.md` — this file.
- `open-in-nvim.sh` — wrapper that routes a single file to nvim or Ghostty.
- `register-nvim-associations.sh` — duti registration for text/source extensions.

Both scripts are kept in sync with `~/.local/bin/`. Re-copy after editing.
