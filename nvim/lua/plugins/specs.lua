
return {
  require("plugins.neotree"),
  require("plugins.yarepl"),
  require("plugins.lsp"),
  require("plugins.cmp"),


  -- UI / theme
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup() end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight-night") end,
  },
}
