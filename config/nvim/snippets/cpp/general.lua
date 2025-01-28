local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	s({ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
		fmta(
      "if (<>) {\n\t<>\n}<>",
      {
			  i(1),
			  d(2, get_visual),
			  i(0),
		  }
    ),
		{ condition = line_begin }
	),
	s({ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
		fmta(
			[[
        for (<>) {
          <>
        }<>
      ]],
			{
				i(1),
				d(2, get_visual),
				i(0),
			}
		),
		{ condition = line_begin }
	),
	s({ trig = "while ", dscr = "while loop", snippetType = "autosnippet" },
		fmta(
			[[
        while (<>) {
          <>
        }<>
      ]],
			{
				i(1),
				d(2, get_visual),
				i(0),
			}
		),
		{ condition = line_begin }
	),
  s({ trig = "template", dscr = "template", snippetType = "autosnippet" },
    {
      t({ "template<typename T>", "" }),
      i(0),
    }
  ),
}
