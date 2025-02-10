local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

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
  s({ trig = "autocmd ", dscr = "Neovim API autocmd", wordTrig = false, snippetType = "autosnippet" },
    fmta([[
        vim.api.nvim_create_autocmd(<>, {<>
          callback = function()
            <>
          end
        })
      ]],
      {
        c(1, {
          { t("{ \""), i(1), t("\" }") },
          { t("\""), i(1), t("\"") }
        }),
        c(2, {
          { t({ "", "\tpattern = { \"" }), i(1), t("\" },") },
          { t({ "", ("\tpattern = \"")}), i(1), t("\",") },
          { t("") },
        }),
        i(3),
      }
    ),
    { condition = out_of_string_comment }
  ),
  s({ trig = "snp", dscr = "LuaSnip lua snippet template", snippetType = "autosnippet" },
    fmta(
      [=[
        s({ trig = "<>", dscr = "<>"<><><> },
          <>
        ),
      ]=],
      {
        i(1),
        i(2),
        c(3,  { t(", regTrig = true"), t("") }),
        c(4, { t(", wordTrig = false"), t("") }),
        c(5, { t(", snippetType = \"autosnippet\""), t("") }),
        c(6, {
          sn(nil, fmta(
            [=[
              fmta(
                  [[
                    <>
                  ]],
                  {
                    <>
                  }
                )
            ]=],
            {
              i(1),
              i(2),
            }
          )),
          sn(nil, { t({ "{", "\t\tt(\"" }), i(1), t({  "\")", "\t}"}) })
        }),
      }
    ),
    { condition = out_of_string_comment }
  ),
}
