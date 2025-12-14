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

map("n", "<leader>w", ":w<CR>", opts)          -- <CR> = Enter
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>e", ":Ex<CR>", opts)         -- Ex = netrw файловый менеджер
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Удобное перемещение строк
map("n", "<A-j>", ":m .+1<CR>==", opts)        -- <A-j> = Alt+j, :m = move line
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Сдвиг отступов с сохранением выделения
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Удалить выделение "в никуда" (не трогает буфер обмена)
-- "_  = black hole register (ничего не сохранять)
-- d   = delete
vim.keymap.set("v", "<leader>d", '"_d', { silent = true })

-- Вставить из системного clipboard (Ctrl+C/Ctrl+V)
-- "+  = CLIPBOARD register
-- p/P = вставить после/до курсора
vim.keymap.set("n", "<leader>p", '"+p', { silent = true })
vim.keymap.set("n", "<leader>P", '"+P', { silent = true })
vim.keymap.set("v", "<leader>p", '"+p', { silent = true })
vim.keymap.set("v", "<leader>P", '"+P', { silent = true })


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

-- ВНИМАНИЕ: ВНУТРИ setup({...}) ДОЛЖНЫ БЫТЬ ТОЛЬКО ТАБЛИЦЫ-ПЛАГИНЫ { ... } :contentReference[oaicite:1]{index=1}
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
  { "williamboman/mason.nvim" },

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

  -------------------------------------------------------------------
  -- yarepl.nvim — REPL внутри Neovim
  -------------------------------------------------------------------
  {
    "milanglacier/yarepl.nvim",
    event = "VeryLazy", -- грузить поздно (после старта) :contentReference[oaicite:2]{index=2}
    config = function()
      require("yarepl").setup({
        buflisted = false,              -- REPL-буфер не попадает в :ls (если не нужно)
        wincmd = "belowright 15 split", -- открыть REPL снизу (split) высотой 15

        -- metas = профили REPL. Имя "python" потом используется в <Plug>(REPLStart-python) :contentReference[oaicite:3]{index=3}
        metas = {
          python = {
            cmd = "python3",
            formatter = "trim_empty_lines",
            source_syntax = "python",
          },
          ipython = {
            cmd = "ipython",
            formatter = "bracketed_pasting",
            source_syntax = "ipython",
          },
        },
      })
    end,
  },

})

-- ===== yarepl.nvim keymaps (только для Python) =====
-- nvim_create_autocmd('FileType', ...) срабатывает, когда для буфера выставлен filetype=python :contentReference[oaicite:4]{index=4}
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python", -- pattern = 'python' => только python-буферы
  callback = function(args)
    -- args.buf = номер буфера, чтобы сделать маппинги ТОЛЬКО в этом файле (buffer-local)
    -- remap=true => маппинг рекурсивный (НЕ noremap). Для <Plug>(...) это важно. :contentReference[oaicite:5]{index=5}
    local kmopts = { buffer = args.buf, silent = true, remap = true }

    -- <Plug>(...) = "виртуальная" команда, которую предоставляет плагин
    -- Суффикс "-python" означает: использовать meta с именем "python" (см. metas выше). :contentReference[oaicite:6]{index=6}
 
    vim.keymap.set("n", "<leader>rs", "<Cmd>1REPLStart! python<CR>", { buffer = args.buf, silent = true })
 
    vim.keymap.set("n", "<leader>rf", "<Plug>(REPLFocus-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: focus" }))
    vim.keymap.set("n", "<leader>rt", "<Plug>(REPLHideOrFocus-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: hide/focus toggle" }))
    vim.keymap.set("n", "<leader>rq", "<Plug>(REPLClose-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: close" }))

    -- отправка кода
    vim.keymap.set("n", "<leader>rr", "<Plug>(REPLSendLine-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: send line" }))
    vim.keymap.set("v", "<leader>rr", "<Plug>(REPLSendVisual-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: send selection" }))

    -- “source” удобнее для def/if/for (передаёт блок целиком)
    vim.keymap.set("v", "<leader>rR", "<Plug>(REPLSourceVisual-python)", vim.tbl_extend("force", kmopts, { desc = "REPL: source selection" }))
  end,
})

--------------------------------------------------------------------
-- LSP (Neovim 0.11+): vim.lsp.config + vim.lsp.enable
-------------------------------------------------------------------

-- Mason только как менеджер бинарников (ставим сервера через :Mason)
require("mason").setup()

-- capabilities для интеграции LSP с nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- keymaps при подключении LSP к буферу (вместо on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- args.buf = номер буфера, куда прицепился LSP
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

-- Настраиваем (расширяем) конфиги серверов
-- vim.lsp.config('name', {...}) = "добавь/переопредели настройки для сервера name" :contentReference[oaicite:2]{index=2}
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("clangd", {
  capabilities = capabilities,
})

-- Включаем авто-активацию по filetypes/root_markers
-- Можно строкой или списком. :contentReference[oaicite:3]{index=3}
vim.lsp.enable({ "pyright", "clangd" })


----------------------------------------------------------------
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
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

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

