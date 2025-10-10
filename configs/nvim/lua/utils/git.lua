local M = {}

function M.git_root()
	if vim.b.git_dir then return vim.b.git_dir end
	local gitdir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.getcwd()))
	local isgitdir = vim.fn.matchstr(gitdir, "^fatal:.*") == ""
	vim.b.git_dir = isgitdir and vim.trim(vim.fn.fnamemodify(gitdir, ":t")) or "git"
	return vim.b.git_dir
end

return M
