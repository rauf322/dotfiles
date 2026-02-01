return {
	"NickvanDyke/opencode.nvim",
	config = function()
		vim.g.opencode_opts = {
			provider = {
				enabled = "tmux",
				tmux = {
					options = "",
				},
			},
		}

		-- Required for `opts.auto_reload`
		vim.opt.autoread = true

		-- Smart toggle: focus if exists, create if not, close if focused
		local function smart_opencode_toggle()
			-- Get current pane ID
			local current_pane = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("\n", "")

			-- Find opencode pane
			local find_cmd = "tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep 'opencode' | awk '{print $1}'"
			local opencode_pane = vim.fn.system(find_cmd):gsub("\n", "")

			if opencode_pane ~= "" then
				-- Opencode pane exists
				if current_pane == opencode_pane then
					-- Currently in opencode pane, close it
					require("opencode").toggle()
				else
					-- Focus the existing opencode pane
					vim.fn.system("tmux select-pane -t " .. opencode_pane)
				end
			else
				-- No opencode pane, create it
				require("opencode").toggle()
			end
		end

		-- Recommended/example keymaps
		vim.keymap.set("n", "<C-P>", smart_opencode_toggle, { desc = "opencode: Smart toggle" })
		vim.keymap.set({ "n", "x" }, "<C-N>", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask about this" })
		vim.keymap.set("v", "<leader>oa", function()
			require("opencode").ask("@selection: ")
		end, { desc = "opencode: Ask about selection" })
	end,
}
