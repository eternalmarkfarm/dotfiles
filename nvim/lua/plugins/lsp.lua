
return {
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local function bufmap(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
          end

          bufmap("n", "gd", vim.lsp.buf.definition)
          bufmap("n", "gD", vim.lsp.buf.declaration)
          bufmap("n", "gi", vim.lsp.buf.implementation)
          bufmap("n", "gr", vim.lsp.buf.references)
          bufmap("n", "K", vim.lsp.buf.hover)
          bufmap("n", "<leader>rn", vim.lsp.buf.rename)
          bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
          bufmap("n", "[d", vim.diagnostic.goto_prev)
          bufmap("n", "]d", vim.diagnostic.goto_next)
        end,
      })

      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.enable({ "pyright", "clangd" })
    end,
  },
}
