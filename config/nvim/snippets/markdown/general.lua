local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local get_visual = function(_, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {
  s({ trig = "lnk", dscr = "link", snippetType = "autosnippet" },
    {
      t("["),
      d(2, get_visual),
      t("]("),
      i(1, "https://"),
      t(")"),
    }
  ),
  s({ trig = "cbl", dscr = "Code block", snippetType = "autosnippet" },
    {
      t("```"),
      i(1),
      t({ "", "" }),
      d(2, get_visual),
      t({ "", "```", "" }),
    }
  ),
}
