return {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
  confi = function()
    require'colorizer'.setup() 
  end
}
