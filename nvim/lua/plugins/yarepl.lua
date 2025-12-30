
return {
  {
    "milanglacier/yarepl.nvim",
    event = "VeryLazy",
    config = function()
      require("yarepl").setup({
        buflisted = false,
        wincmd = "belowright 15 split",
        metas = {
          python  = { cmd = "python3", formatter = "trim_empty_lines", source_syntax = "python" },
          ipython = { cmd = "ipython", formatter = "bracketed_pasting", source_syntax = "ipython" },
        },
      })
    end,
  },
}
