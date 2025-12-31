return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "n",
      desc = "Format file",
    },
  },
  opts = {
    formatters_by_ft = {
      python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      c = { "clang_format" },
      cpp = { "clang_format" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
