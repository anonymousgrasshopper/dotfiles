local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

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
        sn(1, c(1, { sn(nil, { t("{ \""), i(1), t("\" }") }), sn(nil, { t("\""), i(1), t("\"") }) })),
        sn(2, c(1, { sn(nil, { t({ "", "\tpattern = { \"" }), i(1), t("\" },")}), sn(nil, { t({ "", ("\tpattern = \"")}), i(1), t("\",") }), sn(nil, { t("") })})),
        i(3),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "snp", dscr = "LuaSnip lua snippet template", snippetType = "autosnippet" },
    fmta(
      [=[
        s({ trig = "<>", dscr = "<>"<><><> },
          <>
        )
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
    { condition = line_begin }
  )
}
