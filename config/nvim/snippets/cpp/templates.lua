local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

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
  s({ trig = "tmp ", dscr = "CP template", snippetType = "autosnippet"},
    fmta(
      [[
        #pragma GCC optimize("O3,unroll-loops")
        #include <<bits/stdc++.h>>
        using namespace std;

        #ifdef LOCAL
        #include "dbg.h"
        #else
        #define n(...) 42
        #define id(...) 42
        #define dbg(...) 42
        #define line(...) 42
        #define dbgarr(...) 42
        #define dbg_var(...) 42
        #endif

        ///////////////////////////////////


        ///////////////////////////////////


        int main() {
          ios::sync_with_stdio(false); cin.tie(nullptr);
          <>
        }
    ]],
      {
        i(0),
      }
    ),
    { condition = line_begin, not_in_string_comment }
  ),
  s({ trig = "cf ", dscr = "Codeforces template", snippetType = "autosnippet" },
    fmta(
      [[
        #pragma GCC optimize("O3,unroll-loops")
        #include <<bits/stdc++.h>>
        using namespace std;

        #ifdef LOCAL
        #include "dbg.h"
        #else
        #define n(...) 42
        #define id(...) 42
        #define dbg(...) 42
        #define line(...) 42
        #define dbgarr(...) 42
        #define dbg_var(...) 42
        #endif

        ///////////////////////////////////

        void solve() {
          <>
        }

        ///////////////////////////////////

        int main(){
          ios::sync_with_stdio(false); cin.tie(nullptr);
          int nbTests; cin >>>> nbTests;
          while (nbTests--){
            solve();
          }
        }
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin, not_in_string_comment }
  ),
  s({ trig = "io ", dscr = "Set io for USACO", snippetType = "autosnippet" },
    fmta(
      [[
        void setIO(string name = "<>") {
          if ( name!="" ) {
            freopen((name+".in").c_str(), "r", stdin);
            freopen((name+".out").c_str(), "w", stdout);
          }
        }
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin, not_in_string_comment }
  )
}
