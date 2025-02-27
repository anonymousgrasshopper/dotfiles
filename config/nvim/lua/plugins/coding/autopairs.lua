return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      filetype = {
        nft = {
          "TelescopePrompt",
          "grug-far",
        },
      },
      fastwarp = {
        multi = true,
        {},
        { faster = true, map = "<C-A-e>", cmap = "<C-A-e>" },
      },
      extensions = {
        -- Improve performance when typing fast, see
        -- https://github.com/altermo/ultimate-autopair.nvim/issues/74
        utf8 = false,
        cond = {
          cond = {
            function(fn, o)
              if fn.get_mode == "R" then -- disable in replace mode
                return false
              end
              if o.key ~= vim.api.nvim_replace_termcodes("<bs>", true, true, true) then
                return true -- return true, unless we've hitten backspace
              else
                if
                  vim.tbl_contains({ '""', "()", "[]", "{}", "''", "<>", "$$", "**", "~~" }, o.line:sub(o.col - 2, o.col - 1))
                then
                  return false -- if the two characters before the cursor are paired, don't remove them
                else
                  return true
                end
              end
            end,
          },
        },
      },
      { "<", ">", disable_start = true, disable_end = true },
      { "\\(", "\\)", newline = true },
      { "\\{", "\\}", newline = true },
      { "\\[", "\\]", newline = true, nft = { "tex" } },

      { "$", "$", ft = { "tex", "markdown" } },
      { "$$", "$$", ft = { "markdown" } },
      { "*", "*", ft = { "markdown" } },
      { "**", "**", ft = { "markdown" } },
      { "~~", "~~", ft = { "markdown" } },
      { "[=[", "]=]", ft = { "lua" } },
      { "[==[", "]==]", ft = { "lua" } },
      { "[===[", "]===]", ft = { "lua" } },
      {
        [=[\[]=],
        [=[\]]=],
        ft = { "tex" },
        newline = true,
        disable_start = true,
        disable_end = true,
      },
      {
        "/*",
        "*/",
        ft = { "c", "cpp", "css", "go" },
        newline = true,
        space = true,
      },
      {
        ">",
        "<",
        ft = { "html", "xml", "markdown" },
        disable_start = true,
        disable_end = true,
        newline = true,
        space = true,
      },
      {
        "\\left(",
        "\\right)",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left[",
        "\\right]",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left{",
        "\\right}",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left<",
        "\\right>",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left\\lfloor",
        "\\right\\rfloor",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left\\lceil",
        "\\right\\rceil",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left\\vert",
        "\\right\\vert",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left\\lVert",
        "\\right\\rVert",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\left\\lVert",
        "\\right\\rVert",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\begin{bmatrix}",
        "\\end{bmatrix}",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
      {
        "\\begin{pmatrix}",
        "\\end{pmatrix}",
        newline = true,
        space = true,
        ft = { "markdown", "tex" },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "glimmer",
      "handlebars",
      "html",
      "javascript",
      "jsx",
      "liquid",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "tsx",
      "twig",
      "typescript",
      "vue",
      "xml",
    },
    opts = {},
  },
}
