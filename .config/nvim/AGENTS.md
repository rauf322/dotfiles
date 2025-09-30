# Neovim Configuration Agent Guidelines

## Project Structure

This is a Neovim configuration written in Lua, organized under `lua/bitrift/` with modular plugin configurations.

## Code Style & Conventions

- **Language**: Lua 5.1 (Neovim embedded)
- **Formatting**: Use `stylua` for Lua files (configured in formatingLinting.lua)
- **Module Pattern**: Use `return { ... }` for plugin specs, `require("module")` for imports
- **Naming**: Use snake_case for variables/functions, PascalCase for classes
- **Tables**: Prefer explicit table fields over positional arguments
- **Error Handling**: Use `pcall()` for operations that may fail, especially LSP/formatting operations

## Plugin Management

- **Framework**: lazy.nvim (see lazy_init.lua)
- **Structure**: Each plugin in separate file under `plugins/` returning a table spec
- **Dependencies**: Explicitly declare in the `dependencies` field

## Testing & Validation

- **Lint**: Trigger via `<leader>tl` keymap (configured eslint_d, pylint)
- **Format**: Use `<leader>s` to format and save (prettier, stylua, black)
- **Reload Config**: `:source %` for current file, restart Neovim for full reload

## Key Patterns

- Always check if module exists before requiring: `pcall(require, "module")`
- Use `vim.keymap.set()` for keybindings with descriptive `desc` field
- Prefer event-based lazy loading: `event = "BufReadPre"` or `event = "VeryLazy"`

foo
