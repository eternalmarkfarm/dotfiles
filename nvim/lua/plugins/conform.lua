return {
  "stevearc/conform.nvim",
  event = "BufWritePre", -- format right before save
  opts = {
    -- Formatters per filetype
    formatters_by_ft = {
      python = {
        "ruff_fix",             -- ruff check --fix
        "ruff_format",          -- ruff format
        "ruff_organize_imports" -- organize imports
      },
      c = { "clang_format" },
      cpp = { "clang_format" },
    },

    -- Auto format on save
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}

