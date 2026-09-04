-- Listen on a stable socket so external tools (Finder double-clicks via the
-- open-in-nvim.app wrapper, CLI tools, etc.) can route files into this nvim
-- instance via `nvim --server /tmp/nvim-server.pipe --remote-tab`.
-- First nvim wins; later instances silently no-op.
pcall(vim.fn.serverstart, "/tmp/nvim-server.pipe")
