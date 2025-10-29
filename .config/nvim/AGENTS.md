# Neovim Configuration Agent Guidelines

## Project Structure
This is a Neovim configuration written in Lua, organized under `lua/bitrift/` with modular plugin configurations.

## Code Style & Conventions
- **Language**: Lua 5.1 (Neovim embedded)
- **Indentation**: 2 spaces (set in set.lua: tabstop=2, shiftwidth=2, expandtab)
- **Line Length**: 140 characters max (stylua --column-width=140, prettier --print-width=140)
- **Naming**: snake_case for variables/functions/files, PascalCase for classes
- **Quotes**: Single quotes for JS/TS (prettier --single-quote --jsx-single-quote)
- **Module Pattern**: Use `return { ... }` for plugin specs, `require("module")` for imports
- **Tables**: Prefer explicit table fields over positional arguments
- **Error Handling**: Always use `pcall()` for operations that may fail (LSP, formatting, requires)

## Testing & Validation
- **Lint**: `<leader>tl` triggers linting (eslint_d for JS/TS, pylint for Python)
- **Format**: `<leader>s` formats and saves (prettier, stylua, black)
- **Reload Config**: `<leader>r` reloads lazy.nvim and sources $MYVIMRC
- **Health Check**: `:checkhealth` to validate Neovim setup

## Plugin Management
- **Framework**: lazy.nvim (imports from `bitrift.plugins` and `bitrift.plugins.linting`)
- **Structure**: Each plugin in separate file under `plugins/` returning a lazy.nvim spec
- **Lazy Loading**: Use `event = "BufReadPre"` or `event = "VeryLazy"` for performance
- **Dependencies**: Explicitly declare in the `dependencies` field

## Key Patterns
- Check module exists: `local ok, mod = pcall(require, "module")`
- Keymaps: Use `vim.keymap.set()` with descriptive `desc` field for which-key
- Autocommands: Use `vim.api.nvim_create_autocmd()` with augroups
- LSP setup: Register keymaps in `LspAttach` autocmd (see lspconfig.lua)
