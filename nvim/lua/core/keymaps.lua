local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Insert spaces but return to Normal immediately
map("n", "<leader>i", "i <Esc>h", { desc = "Add 1 space after cursor (stay Normal)" })


-- Insert-mode cursor movement with Ctrl + hjkl

map("i", "<C-h>", "<Left>", opts)
map("i", "<C-j>", "<Down>", opts)
map("i", "<C-k>", "<Up>", opts)
map("i", "<C-l>", "<Right>", opts)



-- Blank lines without staying in Insert
map("n", "<leader>o", "o<Esc>", { desc = "Add blank line below (stay Normal)" })
map("n", "<leader>O", "O<Esc>", { desc = "Add blank line above (stay Normal)" })

map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Delete without back
map("v", "<leader>d", '"_d', { silent = true })

-- TIP (Linux):
-- "+  = CLIPBOARD (Ctrl+C / Ctrl+V)
-- "*  = PRIMARY (mouse selection / middle-click paste)
map({ "n", "v" }, "<leader>p", '"+p', { silent = true })
map({ "n", "v" }, "<leader>P", '"+P', { silent = true })
map({ "n", "v" }, "<leader>y", '"+y', { silent = true })
-- Copy (yank) the entire file to the system clipboard
map("n", "<leader>Y", "<Cmd>%yank +<CR>", { silent = true, desc = "Yank whole file to clipboard" })
-- Select whole file (visual)
map("n", "<leader>v", "ggVG", { silent = true, desc = "Select whole file" })

-- Insert
map("i", "jj", "<Esc>")

-- Window navigation (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window right" })


-- Splits
map("n", "<leader>sv", "<C-w>v", { silent = true, desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { silent = true, desc = "Split horizontally" })

-- Bufferline Tabs

local function bl(cmd)
    return function()
        -- Load bufferline right now (so its :BufferLine* commands exist)
        require("lazy").load({ plugins = { "bufferline.nvim" } })
        vim.cmd(cmd)
    end
end

map("n", "<Tab>", bl("BufferLineCyclePrev"), { desc = "Prev buffer" })
map("n", "<s-Tab>", bl("BufferLineCycleNext"), { desc = "Next buffer" })
map("n", "<leader>x", bl("BufferLinePickClose"), { desc = "Next buffer" })

-- Neo-Tree

map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { silent = true, desc = "Neo-tree (toggle)" })

-- lua/core/lsp_keymaps.lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        local function bufmap(mode, lhs, rhs, desc)
            map(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        bufmap("n", "gr", vim.lsp.buf.references, "References")
        bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
        bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        bufmap("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        bufmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
})

-- Telescope
map("n", "<leader>ff", function()
    require("telescope.builtin").find_files({
        cwd = vim.fn.expand("~"),
        hidden = true,    -- show dotfiles/dotdirs
        no_ignore = true, -- optional: include ignored files too
    })
end, { silent = true, desc = "Find files in ~ (incl hidden)" })

-- ToggleTerm: terminal-mode keymaps (only inside ToggleTerm buffers)
local map = vim.keymap.set
map("n", "<C-\\>", "<cmd>ToggleTerm direction=horizontal dir=%:p:h<cr>",
    { silent = true, desc = "ToggleTerm (file dir)" })

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*toggleterm#*",
    callback = function()
        local opts = { buffer = 0, silent = true }

        -- exit terminal-mode
        map("t", "<esc>", [[<C-\><C-n>]], opts)
        map("t", "jj", [[<C-\><C-n>]], opts)

        -- window navigation from terminal
        map("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        map("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        map("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        map("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)

        -- start window command mode (like normal <C-w>)
        map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end,
})


map("n", "<leader>F", function()
    require("lazy").load({ plugins = { "conform.nvim" } }) -- load plugin now
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format file" })
