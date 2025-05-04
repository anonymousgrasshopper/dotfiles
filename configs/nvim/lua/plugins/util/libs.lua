M = {}

libs = {
	"nvim-lua/plenary.nvim",
	"nvim-neotest/nvim-nio",
	"MunifTanjim/nui.nvim",
	"nvim-tree/nvim-web-devicons",
}
if vim.fn.executable("magick") then
	table.insert(libs, "3rd/image.nvim")
end

for _, lib in ipairs(libs) do
	table.insert(M, { lib, lazy = true })
end

return M
