local make_cond = require("snippet/luasnip").make_cond

local tex_utils = {}

tex_utils.in_mathzone = make_cond(function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end)
tex_utils.in_text = make_cond(function()
	return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1
end)
tex_utils.in_comment = function()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

local function in_environment(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end
tex_utils.in_env= make_cond(function(name)
	return in_environment(name)
end)
tex_utils.in_document = make_cond(function()
	return in_environment("document")
end)
tex_utils.in_preamble = make_cond(function() -- or after :)
	return not in_environment("document")
end)
tex_utils.in_equation = make_cond(function()
	return in_environment("equation")
end)
tex_utils.in_itemize = make_cond(function()
	return in_environment("itemize")
end)
tex_utils.in_tikz = make_cond(function()
	return in_environment("tikzpicture")
end)

return tex_utils
