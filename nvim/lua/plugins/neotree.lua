return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    close_if_last_window = true,

    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_default",

      filtered_items = {
        visible = true,        -- show hidden items (dimmed)
        hide_dotfiles = false, -- show dotfiles
        hide_gitignored = true,
        show_hidden_count = false,
      },
    },

    window = { width = 32 },
  },
}
