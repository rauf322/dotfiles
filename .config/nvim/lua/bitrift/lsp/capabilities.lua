local M = {}

function M.get()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- Try to extend with cmp capabilities if available
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
	end

	-- Try to extend with file operations if available
	local ok_file_ops, file_ops = pcall(require, "lsp-file-operations")
	if ok_file_ops then
		capabilities = vim.tbl_deep_extend("force", capabilities, file_ops.default_capabilities())
	end

	return capabilities
end

return M.get()

