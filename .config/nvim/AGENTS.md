# Neovim Configuration Agent Guidelines

## Project Structure
This is a Neovim configuration written in Lua, split into two top-level module trees:
- `lua/bitrift/` — orchestration and custom, non-plugin features. One file per concern: `options.lua` (vim.opt/vim.g), `keymaps.lua` (global keymaps), `pack.lua` (`vim.pack.add` + plugin config requires), plus small single-purpose autocmd modules (`highlight_yank.lua`, `restore_cursor.lua`, `vertical_help.lua`, `resize_splits.lua`, `active_cursorline.lua`, `lsp_reference_highlight.lua`, `no_auto_comment.lua`, `server.lua`), and `utils/` for helper modules used by multiple plugin configs (`git.lua`, `opencode.lua`, `runner.lua`, `jsx-autofix.lua`).
- `lua/plugins/` — one file per plugin, each running that plugin's `setup()`/keymaps directly at require time. `mason.lua` + the old `lspconfig.lua` are merged into `plugins/lsp.lua` (shared `servers` table drives both `mason-lspconfig.ensure_installed` and `vim.lsp.enable`); `github.lua` is split into `plugins/fugitive.lua` and `plugins/gitsigns.lua`.

`lua/bitrift/init.lua` requires, in order: `options` → `keymaps` → `pack` (which loads all of `lua/plugins/*`) → the custom feature modules. Order matters — `keymaps` loads before `pack` so plugin-registered keymaps (e.g. lspsaga's `<leader>d`) can override the base ones set in `keymaps.lua`.

## Code Style & Conventions
- **Language**: Lua 5.1 (Neovim embedded)
- **Indentation**: 2 spaces (set in options.lua: tabstop=2, shiftwidth=2, expandtab)
- **Line Length**: 140 characters max (stylua --column-width=140, prettier --print-width=140)
- **Naming**: snake_case for variables/functions/files, PascalCase for classes
- **Quotes**: Single quotes for JS/TS (prettier --single-quote --jsx-single-quote)
- **Tables**: Prefer explicit table fields over positional arguments
- **Error Handling**: Always use `pcall()` for operations that may fail (LSP, formatting, requires)

## Plugin Management
- **Framework**: native `vim.pack` (Neovim built-in), NOT lazy.nvim
- **Install**: All plugins are declared in a single `vim.pack.add({ ... })` call in `lua/bitrift/pack.lua`
- **Configure**: Each file under `lua/plugins/` runs its plugin's `setup()` directly at require time (no spec tables, no `return { ... }`)
- **Load order**: `pack.lua` requires the `plugins.*` config modules in explicit order at the bottom of the file — order matters for dependencies
- **Build hooks**: Post-install/update steps live in the `PackChanged` autocmd at the top of `pack.lua`
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
- LSP: servers are enabled via `vim.lsp.enable()` in `lua/plugins/lsp.lua`; per-server overrides live in `lsp/*.lua` (native auto-discovery)
