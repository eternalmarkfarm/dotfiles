
-- Python-only REPL keymaps
vim.keymap.set("n", "<leader>rs", "<Cmd>1REPLStart! python<CR>", { buffer = true, silent = true })

local kmopts = { buffer = true, silent = true, remap = true }
vim.keymap.set("n", "<leader>rf", "<Plug>(REPLFocus-python)", kmopts)
vim.keymap.set("n", "<leader>rt", "<Plug>(REPLHideOrFocus-python)", kmopts)
vim.keymap.set("n", "<leader>rq", "<Plug>(REPLClose-python)", kmopts)

vim.keymap.set("n", "<leader>rr", "<Plug>(REPLSendLine-python)", kmopts)
vim.keymap.set("v", "<leader>rr", "<Plug>(REPLSendVisual-python)", kmopts)
vim.keymap.set("v", "<leader>rR", "<Plug>(REPLSourceVisual-python)", kmopts)
