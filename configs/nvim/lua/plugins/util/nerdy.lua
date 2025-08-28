return {
	"2kabhishek/nerdy.nvim",
	cmd = "Nerdy",
	config = function()
		if package.loaded["telescope"] then
			require("telescope").load_extension("nerdy")
		end
		vim.api.nvim_create_user_command("Nerdy", function()
			require("telescope").extensions.nerdy.nerdy()
		end,{})
	end,
}
