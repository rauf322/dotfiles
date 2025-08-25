# AGENTS.md - Dotfiles Development Guide

## Build/Test/Lint Commands
- **Run all setup scripts**: `./run` (executes all scripts in runs_MacOS/)
- **Run specific setup**: `./run <filter>` (e.g., `./run nvim`)
- **Build C components**: `make` (in .config/sketchybar/helpers/)
- **Dry run mode**: `./run --dry` (preview without execution)

## Languages & Technologies
- **Lua**: Neovim configuration, Sketchybar widgets
- **C**: System monitoring tools (CPU/network load providers)
- **Shell/Bash**: Setup scripts, automation
- **Fish**: Shell configuration
- **Configuration files**: TOML, JSON, YAML

## Code Style Guidelines
### Lua (Neovim/Sketchybar)
- Use 2-space indentation, snake_case variables
- Require modules at top: `local module = require("module")`
- Use explicit table keys: `{ key = value }`
- Colors/settings via centralized modules

### C Code
- K&R brace style, 2-space indentation
- Include guards, descriptive function names
- Use `snprintf` for safe string formatting
- Error handling with early returns

### Shell Scripts
- Use `#!/usr/bin/env bash` shebang
- Quote variables: `"$variable"`
- Use functions for reusable code
- Implement dry-run mode with `--dry` flag

## Error Handling
- Check return values and use early returns
- Provide helpful error messages with usage examples
- Implement graceful degradation where possible