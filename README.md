# Dotfiles – Overview of the `.config` Directory 🛠️✨

This repository contains my personal dotfiles. They aim to make my development environment portable across **macOS 🍎** and **Linux 🐧** while keeping a consistent look and feel.  
Below is a detailed tour of the most important configuration files inside the `.config` directory and what they do.

## 🚀 Setup

```sh
./run                        # install Homebrew (if needed) + everything in Brewfile + bun/opencode
./dev-env --copy:dir:config  # deploy .config to ~/.config
./dev-env --copy:dir:local   # deploy .local scripts to ~/.local
```

All installed software lives in the `Brewfile` (taps, CLI tools, casks, fonts, VS Code extensions). To capture newly installed tools: `brew bundle dump --force --file=Brewfile`.

---

## 🖥️ Terminal & Shell

### `.zshrc` 🐚
- Bootstraps **oh-my-zsh** and plugins.  
- Defines aliases (`ls` with colors, `git` shortcuts).  
- Integrates **fzf 🔍** and **zoxide 📂** for fuzzy navigation.  
- Custom function `y` lets you change the working directory after selecting one in **Yazi 🗂️**.

### Ghostty Terminal 🪟
- Font: **MesloLGS Nerd Font**.  
- Transparent background with blur ✨.  
- Colorscheme: **rose-pine 🌹**.  
- Cursor: block ▉, reverse scroll, hide mouse while typing.

### `btop` 📊
- Colorful system monitor with CPU, RAM, network and process graphs.  
- True-color, braille graphs, 2s updates, temperature sensors 🌡️.

### `tmux` 🔗
- Based on **Oh-My-Tmux**.  
- Mouse support, UTF-8, 256 colors.  
- Keybindings like `Alt+h/j/k/l` to move between panes.  
- Custom **status bar** showing uptime, battery 🔋, and weather ☁️.  
- Script `swap-pane` enables moving panes between windows.

---

## ✍️ Editor – Neovim 💤

My Neovim setup is a **full IDE replacement**.

### Plugins 📦
- **Colors & Themes 🎨**: `rose-pine`, `kanagawa`, `tokyonight`, `catppuccin`.  
- **UI & UX 🪄**: `lualine` (statusline), `bufferline`, `indent-blankline`, `nvim-tree` (file explorer 📂).  
- **Fuzzy Finder 🔍**: `telescope.nvim`, `fzf-lua`.  
- **LSP & Completion 🤖**: `nvim-lspconfig`, `mason.nvim`, `nvim-cmp`, `LuaSnip`.  
- **Debugging 🐞**: `nvim-dap`, `nvim-dap-ui`.  
- **Git Integration 🌱**: `vim-fugitive`, `gitsigns.nvim`.  
- **Markdown & Notes 📝**: `obsidian.nvim`, `render-markdown.nvim`, `peek.nvim` (live preview).  
- **Quality of Life 🧩**: `autopairs`, `cloak.nvim` (hide secrets), `which-key`, `snacks.nvim`.

### Custom Function ⚡
Inside **nvim-tree**, I’ve mapped the key `C` to a helper function:
- **`copy_file_to_clipboard` 📋** → copies the selected file’s absolute path directly to the system clipboard for easy pasting elsewhere.

---

## 📐 Window Management (macOS)

### Aerospace 🛰️
- 9 Workspaces, apps auto-assigned (Browsers(Chrome,Arc,Zen) → 1, Ghostty → 2, and so on).  
- Keybindings: **alt + h/j/k/l** to move focus, resize, or swap windows.  
- Gaps and edges configured.  
- Notifies **Sketchybar** on workspace changes.

### Sketchybar 🧃
- Fully customized **menu bar**.  
- Nerd Font icons ⚡ for Wi-Fi, Battery, Media.  
- Colors unified with **rose-pine** and **catppuccin** palette.  
- Rounded items, transparent backgrounds ✨.

### Karabiner ⌨️
- Remaps `Ctrl+h/j/k/l` → arrow keys ⬅️⬇️⬆️➡️.  
- Swaps Command/Control keys on some devices.  
- Fn layer for media keys 🎶.

### LinearMouse 🖱️
- Per-device pointer speed.  
- Acceleration disabled for precision 🎯.  
- Natural scrolling enabled.

---

## 🗂️ File Manager – Yazi

- **Keybindings ⌨️**: Vim-style (`h/j/k/l`), copy-paste (`y`/`p`), delete (`d`/`D`).  
- **Plugins 🔌**: `fzf` integration, `zoxide` jump.  
- **Themes 🎨**: Catppuccin-macchiato + Nightfly.  
- **Previewers 👀**: images, video, PDF, fonts all rendered inside terminal.  
- **Core config ⚙️**: 3-column layout, directories first, hidden files toggled with `.`.

---

## 💡 Summary

- 💤 Neovim – IDE with LSP, DAP, Git, Markdown, Notes.  
- 🔗 Tmux – pane management + system info.  
- 🖥️ Zsh + Ghostty – modern shell environment.  
- 📊 btop – system monitor.  
- 🧃 Sketchybar + Aerospace – macOS bar & tiling WM.  
- 🗂️ Yazi – terminal file manager with plugins.  
- ⌨️ Karabiner + LinearMouse – input customization.

---

✨ These dotfiles bring together **speed, aesthetics, and workflow efficiency** across macOS and Linux.  

---
