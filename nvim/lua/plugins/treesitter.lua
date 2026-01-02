return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "python", "c", "cpp", "bash", "json", "markdown", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
