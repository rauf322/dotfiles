# AGENTS.md - Neovim Configuration Guide

## Project Structure
This is a personal Neovim configuration using Lua and lazy.nvim plugin manager.
- Main config: `init.lua` → `lua/bitrift/`
- Plugins: `lua/bitrift/plugins/`
- Utils: `lua/bitrift/utils/`

## Build/Lint/Test Commands
No package.json or Makefile - this is a Neovim config.
- **Lint**: Uses nvim-lint with eslint_d (JS/TS) and pylint (Python)
  - Manual lint trigger: `<leader>tl`
- **Format**: Uses conform.nvim with prettier (JS/TS/JSON/etc), stylua (Lua), black/isort (Python)
  - Format and save: `<leader>s`
- **Test**: Uses neotest with adapters for Python and Go
  - Run single test: `<leader>tr` 
  - Run test suite: `<leader>ts`
  - Debug test: `<leader>td`
  - Test output: `<leader>to`
  - Test summary: `<leader>tv`

## Code Style Guidelines
- **Lua formatting**: Use stylua, 2-space indents, tabs for tables/functions
- **Import style**: Use `require()` statements at top, group by type  
- **Plugin structure**: Return table with lazy.nvim spec format
- **Naming**: snake_case for files/functions, PascalCase for modules
- **Comments**: Inline comments for keymaps with `desc` parameter
- **Error handling**: Use pcall() for optional requires, vim.notify() for user messages
- **Keymaps**: Always include descriptive `desc` parameter for which-key integration

No .cursorrules or copilot-instructions.md found in this repository.