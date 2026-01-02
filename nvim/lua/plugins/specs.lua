return {
    require("plugins.neotree"),
    require("plugins.bufferline"),
    require("plugins.telescope"),
    require("plugins.toggleterm"),
    require("plugins.lsp"),
    require("plugins.cmp"),
    require("plugins.treesitter"),
    require("plugins.lualine"),
    require("plugins.trouble"),
    require("plugins.fugitive"),
    require("plugins.which-key"),
    require("plugins.conform"),
    require("plugins.dashboard"),
    require("plugins.devicons"),
    require("plugins.mini_icons"),

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd.colorscheme("tokyonight-night") end,
    },
}
