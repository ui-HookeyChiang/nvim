local name = vim.api.nvim_buf_get_name(0)
--when develop kernel project it use 8 space
--othewise use 4
local v = name and name:find('linux') and 8 or 4
vim.opt_local.shiftwidth = v
vim.opt_local.softtabstop = v
vim.opt_local.tabstop = v
vim.opt_local.expandtab = (v==4)
