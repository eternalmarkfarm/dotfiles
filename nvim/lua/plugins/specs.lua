
return {
  require("plugins.neotree"),
  require("plugins.bufferline"),
  require("plugins.telescope"),
  require("plugins.toggleterm"),
  require("plugins.yarepl"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.treesitter"),
  require("plugins.lualine"),
  require("plugins.trouble"),
  require("plugins.fugitive"),
  require("plugins.which-key"),


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
