return {
    "nvim-mini/mini.icons",
    version = "*",
    opts = {}, -- default is fine
    config = function(_, opts)
        require("mini.icons").setup(opts)
    end,
}
