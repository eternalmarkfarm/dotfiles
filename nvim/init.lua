-- ===== БАЗОВЫЕ НАСТРОЙКИ =====
vim.g.mapleader = " "          -- лидер = пробел

local o = vim.opt

-- Номера строк
o.number = true
o.relativenumber = true

-- Отступы / табы
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

-- Внешний вид
o.termguicolors = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.wrap = false
o.scrolloff = 4

-- Поиск
o.ignorecase = true
o.smartcase = true

-- Мышь и буфер обмена
o.mouse = "a"
o.clipboard = "unnamedplus"    -- всё копируется в системный буфер

-- Удобные хоткеи
local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>w", ":w<CR>", opts)          -- сохранить
map("n", "<leader>q", ":q<CR>", opts)          -- выйти
map("n", "<leader>e", ":Ex<CR>", opts)         -- файловый менеджер netrw
map("n", "<leader>h", ":nohlsearch<CR>", opts) -- убрать подсветку поиска

-- Удобное перемещение строк
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Сдвиг отступов с сохранением выделения
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- ===== lazy.nvim — менеджер плагинов =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Treesitter — подсветка
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Статус-строка
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Цветовая схема
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -------------------------------------------------------------------
  -- LSP + Mason (без mason-lspconfig)
  -------------------------------------------------------------------
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
  },

  -------------------------------------------------------------------
  -- nvim-cmp — автодополнение
  -------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
})

-------------------------------------------------------------------
-- LSP (ручная настройка серверов)
-------------------------------------------------------------------
local lspconfig = require("lspconfig")

-- Mason только как менеджер бинарников (ставим сервера через :Mason)
require("mason").setup()

-- capabilities для интеграции LSP с nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- on_attach: бинды, которые включаются, когда LSP подцепился к буферу
local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
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
end

-- Python (pyright)
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- C++ (clangd)
lspconfig.clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-------------------------------------------------------------------
-- nvim-cmp — автодополнение
-------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

-- грузим готовые сниппеты (friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter принимает подсказку

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

