
local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>e", ":Ex<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)

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
vim.keymap.set("n", "<leader>Y", "<Cmd>%yank +<CR>", { silent = true, desc = "Yank whole file to clipboard" })
-- Select whole file (visual)
vim.keymap.set("n", "<leader>v", "ggVG", { silent = true, desc = "Select whole file" })

-- Insert
map("i", "jj", "<Esc>")

-- Window navigation (Ctrl + hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window right" })


-- Splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { silent = true, desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { silent = true, desc = "Split horizontally" })

