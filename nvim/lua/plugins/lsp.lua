return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "clangd" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Neovim 0.11+ style (recommended)
      if vim.lsp.config and vim.lsp.enable then
        vim.lsp.config("lua_ls", {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }, -- <-- fixes "Undefined global vim"
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })

        vim.lsp.config("pyright", { capabilities = capabilities })
        vim.lsp.config("clangd", { capabilities = capabilities })

        vim.lsp.enable({ "lua_ls", "pyright", "clangd" })
      else
        -- Older fallback
        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        })

        lspconfig.pyright.setup({ capabilities = capabilities })
        lspconfig.clangd.setup({ capabilities = capabilities })
      end
    end,
  },
}
