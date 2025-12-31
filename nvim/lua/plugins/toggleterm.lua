return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = nil, -- disable plugin auto keymap
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
  end,
}
