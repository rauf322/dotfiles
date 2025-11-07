function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	-- Remove background
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

	-- Make command line transparent
	vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
	vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "none" })
	vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

	-- Add subtle UI borders (0.2px equivalent)
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3e4452", bg = "none" })
	vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4452", bg = "none" })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#3e4452", bg = "none" })
	vim.api.nvim_set_hl(0, "NormalBorder", { fg = "#3e4452", bg = "none" })

	-- Subtle statusline underline border
	vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "none", underline = true })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6c7086", bg = "none", underline = true })

	-- Globally remove all italics from any theme
	local highlight_groups = {
		"Comment",
		"Conditional",
		"Repeat",
		"Label",
		"Keyword",
		"Exception",
		"Include",
		"PreProc",
		"Define",
		"Macro",
		"PreCondit",
		"StorageClass",
		"Structure",
		"Typedef",
		"Special",
		"SpecialChar",
		"Tag",
		"Delimiter",
		"SpecialComment",
		"Debug",
		"Function",
		"Identifier",
		"Type",
		"String",
		"Character",
		"Number",
		"Boolean",
		"Float",
		"Statement",
		"Operator",
		"Constant",
		"Variable",
		"Property",
		"Parameter",
		"Field",
		"Method",
		"Constructor",
		"Namespace",
		"Class",
		"Interface",
		"Enum",
		"EnumMember",
	}

	for _, group in ipairs(highlight_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		if hl.italic then
			hl.italic = false
			vim.api.nvim_set_hl(0, group, hl)
		end
	end

	-- Brighter visual mode highlight
	vim.api.nvim_set_hl(0, "Visual", { bg = "#404040", fg = "none" })

	-- LSP reference highlighting (for document_highlight)
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3e4452" })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3e4452" })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#4a3e45" })
end

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "moon",
				disable_background = true,
				disable_float_background = true,
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
				groups = {
					background = "none",
					background_nc = "none",
					panel = "none",
					panel_nc = "none",
					border = "none",
				},
				palette = {
					love = "#b4637a",
				},
				before_highlight = function(group, highlight, palette)
					if highlight.bg then
						highlight.bg = "none"
					end
				end,
			})

			ColorMyPencils()
		end,
	},
}
