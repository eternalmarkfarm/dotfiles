return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope", -- lazy-load when you run :Telescope ...
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    pickers = {
      find_files = { hidden = true },
    },
  },
  config = function()
    require("telescope").setup({})
  end,
}
