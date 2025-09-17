# AGENTS.md - Dotfiles Development Guide

## Build/Test/Lint Commands
- **Run all setup scripts**: `./run` (executes scripts in runs_MacOS/)
- **Run specific component**: `./run <filter>` (e.g., `./run nvim`, `./run tmux`)
- **Test mode (preview)**: `./run --dry` (shows what would execute without running)
- **Build C components**: `make` (in .config/sketchybar/helpers/ - builds event providers/menus)

## Repository Structure
- `runs_MacOS/`: Individual setup scripts for each tool (aerospace, cursor, neovim, etc.)
- `.config/`: Application configurations (nvim, sketchybar, tmux, fish, etc.)
- `.local/scripts/`: Custom utility scripts (tmux helpers, session management)

## Applications & Tools
### Core Development
- **Neovim**: Editor with Lua config, cmake, gettext dependencies
- **Cursor**: AI-powered editor
- **Fish**: Shell with modern features
- **Tmux**: Terminal multiplexer
- **Git**: Version control with gh CLI

### System & Window Management
- **Aerospace**: Tiling window manager
- **Karabiner Elements**: Keyboard customization
- **Sketchybar**: Custom status bar with C helpers
- **Ice**: Menu bar management
- **BetterDisplay**: Display management

### Terminal & CLI Tools
- **Ghostty**: Modern terminal emulator
- **Fzf**: Fuzzy finder with zsh integration
- **Ripgrep**: Fast text search
- **Eza**: Modern ls replacement
- **Yazi**: File manager
- **Zoxide**: Smart directory jumping
- **Btop**: System monitor
- **Lazygit**: Git TUI

### Languages & Runtimes
- **Node.js**: With npm, pnpm, yarn package managers
- **Python**: Multiple versions via pyenv
- **Lua**: With language server
- **Rust**: Systems programming
- **Go**: Programming language
- **Ruby**: Scripting language

### Media & Utilities
- **EQMac**: System-wide equalizer
- **IINA**: Media player
- **Arc/Firefox**: Web browsers
- **Discord**: Communication
- **Raycast**: Launcher and productivity

## Code Style Guidelines
### Lua (Neovim/Sketchybar)
- 2-space indentation, snake_case variables
- Module imports at top: `require("module.submodule")`
- Explicit table syntax: `{ key = value }`, return tables for modules
- Use centralized color/settings modules (e.g., colors.lua)

### Shell Scripts
- `#!/usr/bin/env bash` shebang, quote all variables: `"$variable"`
- Support `--dry` flag for preview mode, use functions for reusable logic
- Implement proper error handling with meaningful messages

### C Code (Sketchybar helpers)
- K&R brace style, 2-space indentation, descriptive function names
- Use `snprintf` for safe formatting, early returns for error handling