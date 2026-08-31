# Neovim Configuration Agent Guidelines

## Project Structure
This is a Neovim configuration written in Lua, organized under `lua/bitrift/` with modular plugin configurations.

## Code Style & Conventions
- **Language**: Lua 5.1 (Neovim embedded)
- **Indentation**: 2 spaces (set in set.lua: tabstop=2, shiftwidth=2, expandtab)
- **Line Length**: 140 characters max (stylua --column-width=140, prettier --print-width=140)
- **Naming**: snake_case for variables/functions/files, PascalCase for classes
- **Quotes**: Single quotes for JS/TS (prettier --single-quote --jsx-single-quote)
- **Tables**: Prefer explicit table fields over positional arguments
- **Error Handling**: Always use `pcall()` for operations that may fail (LSP, formatting, requires)

## Plugin Management
- **Framework**: native `vim.pack` (Neovim built-in), NOT lazy.nvim
- **Install**: All plugins are declared in a single `vim.pack.add({ ... })` call in `lua/bitrift/pack_init.lua`
- **Configure**: Each file under `plugins/` runs its plugin's `setup()` directly at require time (no spec tables, no `return { ... }`)
- **Load order**: `pack_init.lua` requires the config modules in explicit order at the bottom of the file — order matters for dependencies
- **Build hooks**: Post-install/update steps live in the `PackChanged` autocmd at the top of `pack_init.lua`
- **Lockfile**: `nvim-pack-lock.json` pins plugin revisions
- Do NOT use lazy.nvim spec fields (`event =`, `dependencies =`, `keys =`, `opts =` as spec keys) — `vim.pack` ignores them

## Testing & Validation
- **Format**: stylua (see .stylua.toml)
- **Reload Config**: `<leader>r` sources $MYVIMRC
- **Health Check**: `:checkhealth` to validate Neovim setup

## Key Patterns
- Check module exists: `local ok, mod = pcall(require, "module")`
- Keymaps: Use `vim.keymap.set()` with descriptive `desc` field for which-key
- Autocommands: Use `vim.api.nvim_create_autocmd()` with augroups
- LSP: servers are enabled via `vim.lsp.enable()` in lspconfig.lua; per-server overrides live in `lsp/*.lua` (native auto-discovery)
