return {
	"NickvanDyke/opencode.nvim",
	---@type opencode.Opts
	opts = {
		-- Your configuration, if any — see lua/opencode/config.lua
	},
	keys = {
		-- Recommended keymaps
		{
			"<leader>oA",
			function()
				require("opencode").ask()
			end,
			desc = "Ask opencode",
		},
		{
			"<leader>oa",
			function()
				require("opencode").ask("@cursor: ")
			end,
			desc = "Ask opencode about this",
			mode = "n",
		},
		{
			"<leader>oa",
			function()
				require("opencode").ask("@selection: ")
			end,
			desc = "Ask opencode about selection",
			mode = "v",
		},
		{
			"<leader>L",
			function()
				require("opencode").toggle()
			end,
			desc = "OpenCode TOGGLE embedded opencode",
		},
		{
			"<leader>on",
			function()
				require("opencode").command("session_new")
			end,
			desc = "Opencode new session",
		},
		{
			"<leader>op",
			function()
				require("opencode").select_prompt()
			end,
			desc = "Opencode select prompt",
			mode = { "n", "v" },
		},
		-- Example: keymap for custom prompt
		{
			"<leader>oe",
			function()
				require("opencode").prompt("Explain @cursor and its context")
			end,
			desc = " Opencode explain code near cursor",
		},
	},
}
