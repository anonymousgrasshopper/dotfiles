local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local check_not_in_node = function(ignored_nodes)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2] - 1
  local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()
  return not vim.tbl_contains(ignored_nodes, node_type)
end

local not_in_string_comment = function()
  return check_not_in_node({ "string_content", "comment" })
end

return {
  s({ trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
    fmta([[
        #!/bin/<>
        <>
      ]],
      {
        i(1, "bash"),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
    fmta(
      "if <>; then\n\t<>\nfi<>",
      {
        i(1),
        d(2, get_visual),
        i(0)
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
    fmta(
      [[
        for <> in <>; do
          <>
        done<>
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        i(0)
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "while ", dscr = "while loop", snippetType = "autosnippet" },
    fmta(
      [[
        while <>; do
          <>
        done <>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0),
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "until ", dscr = "until loop", snippetType = "autosnippet" },
    fmta(
      [[
        until <>; do
          <>
        done <>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0),
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "select ", dscr = "select loop", snippetType = "autosnippet" },
    fmta(
      [[
        select <> in <>; do
          <>
        done <>
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        i(0),
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "if [", dscr = "test condition", snippetType = "autosnippet" },
    fmta(
      "if [[ <> ]",
      {
        i(1)
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "while [", dscr = "test condition", snippetType = "autosnippet" },
    fmta(
      "while [[ <> ]",
      {
        i(1)
      }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig = "case", name = "cases", dscr = "cases" },
    fmta(
      [[ 
        case <> in 
            <>
            *) <> ;; 
        esac
      ]],
      {
        i(1, "expr"),
        i(2),
        i(3, "exit 1") }
    ),
    { condition = not_in_string_comment }
  ),
  s({ trig="func", name="function", dscr="define a function"},
    fmta(
      [[
        <>() {
            <>
        }
      ]],
      {
        i(1),
        i(0)
      }
    ),
    { condition = not_in_string_comment }
  ),
}
