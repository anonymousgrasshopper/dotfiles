local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local check_not_in_node = function(ignored_nodes)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2] - 1

  local node_type = vim.treesitter
    .get_node({
      pos = { row, col },
    })
    :type()

  return not vim.tbl_contains(ignored_nodes, node_type)
end

local out_of_string_comment = function()
  return check_not_in_node({ "string", "comment" })
end

return {
  s({ trig = "class%s+([%w_]+)%s", regTrig = true, dscr = "class template", snippetType = "autosnippet" },
    fmta(
      [[
        class <> <><>
        };
      ]],
      {
        f(function(_, snip) return snip.captures[1] end),
        c(1, {
          { t({ "{", "\t" }), i(1), i(0) },
          { t(": public "), i(1), t({ " {", "\t" }), i(0)},
          { t(": protected "), i(1), t({" {", "\t" }), i(0)},
          { t(": private "), i(1), t({ " {", "\t" }), i(0)},
        }),
        i(0),
      }
    ),
    { condition = out_of_string_comment }
  ),
  s({ trig = "struct%s+([%w_]+)%s", regTrig = true, dscr = "struct template", snippetType = "autosnippet" },
    fmta(
      [[
        struct <> <><>
        };
      ]],
      {
        f(function(_, snip) return snip.captures[1] end),
        c(1, {
          { t({ "{", "\t" }), i(1), i(0) },
          { t(": public "), i(1), t({ " {", "\t" }), i(0)},
          { t(": protected "), i(1), t({" {", "\t" }), i(0)},
          { t(": private "), i(1), t({ " {", "\t" }), i(0)},
        }),
        i(0),
      }
    ),
    { condition = out_of_string_comment }
  ),
  s({ trig = "u:", dscr = "public access specifier", snippetType = "autosnippet" },
    {
      t({ "public:", "" })
    },
    { condition = out_of_string_comment }
  ),
  s({ trig = "o:", dscr = "protected access specifier", snippetType = "autosnippet" },
    {
      t({ "protected:", "" })
    },
    { condition = out_of_string_comment }
  ),
  s({ trig = "i:", dscr = "private access specifier", snippetType = "autosnippet" },
    {
      t({ "private:", "" })
    },
    { condition = out_of_string_comment }
  ),
}
