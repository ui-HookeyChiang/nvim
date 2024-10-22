require('keymap.remap')
local map = require('core.keymap')
local cmd = map.cmd

map.n({
  -- lazy
  ['<Leader>pu'] = cmd('Lazy update'),
  ['<Leader>pi'] = cmd('Lazy install'),

  -- Lspsaga
  ['[e'] = cmd('Lspsaga diagnostic_jump_next'),
  [']e'] = cmd('Lspsaga diagnostic_jump_prev'),
  ['K'] = cmd('Lspsaga hover_doc'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gd'] = cmd('Lspsaga peek_definition'),
  ['gD'] = cmd('Lspsaga goto_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['gh'] = cmd('Lspsaga finder'),
  ['gf'] = cmd('lua vim.lsp.buf.format()'),
  ['gs'] = cmd('lua vim.lsp.buf.references()'),
  ['gS'] = cmd('lua vim.lsp.buf.signature_help()'),
  ['<Leader>o'] = cmd('Lspsaga outline'),
  ['<Leader>dw'] = cmd('Lspsaga show_workspace_diagnostics'),
  ['<Leader>db'] = cmd('Lspsaga show_buf_diagnostics'),
  -- dbsession
  ['<Leader>ss'] = cmd('SessionSave'),
  ['<Leader>sl'] = cmd('SessionLoad'),
  -- FzfLua
  ['<Leader>b'] = cmd('FzfLua buffers'),
  ['<Leader>fw'] = cmd('FzfLua live_grep_native'),
  ['<Leader>fs'] = cmd('FzfLua grep_cword'),
  ['<Leader>ff'] = cmd('FzfLua files'),
  ['<Leader>fh'] = cmd('FzfLua helptags'),
  ['<Leader>fo'] = cmd('FzfLua oldfiles'),
  ['<Leader>fg'] = cmd('FzfLua git_files'),
  ['<Leader>gc'] = cmd('FzfLua git_commits'),
  ['<Leader>fc'] = cmd('FzfLua files cwd=$HOME/.config'),
  -- flybuf.nvim
  ['<Leader>j'] = cmd('FlyBuf'),

  --rapid
  ['<leader>c'] = cmd('Rapid'),

  --gitsign
  [']g'] = cmd('lua require"gitsigns".next_hunk()'),
  ['[g'] = cmd('lua require"gitsigns".prev_hunk()'),
  ['<leader>gs'] = cmd('lua require"gitsigns".stage_hunk()'),
  ['<leader>gu'] = cmd('lua require"gitsigns".undo_stage_hunk()'),
  ['<leader>gr'] = cmd('lua require"gitsigns".reset_hunk()'),
  ['<leader>gp'] = cmd('lua require"gitsigns".preview_hunk()'),
  ['<leader>gb'] = cmd('lua require"gitsigns".blame_line()'),

  -- hop.nvim
  ['s'] = cmd('HopWordAC'),
  ['x'] = cmd('HopWordBC'),

  -- splits
  ['<C-Left>'] = cmd('SmartCursorMoveLeft'),
  ['<C-Down>'] = cmd('SmartCursorMoveDown'),
  ['<C-Up>'] = cmd('SmartCursorMoveUp'),
  ['<C-Right>'] = cmd('SmartCursorMoveRight'),
  ['<C-h>'] = cmd('SmartCursorMoveLeft'),
  ['<C-j>'] = cmd('SmartCursorMoveDown'),
  ['<C-k>'] = cmd('SmartCursorMoveUp'),
  ['<C-l>'] = cmd('SmartCursorMoveRight'),
  ['<A-Left>'] = cmd('SmartResizeLeft 3'),
  ['<A-Down>'] = cmd('SmartResizeDown 3'),
  ['<A-Up>'] = cmd('SmartResizeUp 3'),
  ['<A-Right>'] = cmd('SmartResizeRight 3'),
  ['<A-h>'] = cmd('SmartResizeLeft 3'),
  ['<A-j>'] = cmd('SmartResizeDown 3'),
  ['<A-k>'] = cmd('SmartResizeUp 3'),
  ['<A-l>'] = cmd('SmartResizeRight 3'),
})

map.i({
  -- hop.nvim
  ['<C-s>'] = cmd('HopWordAC'),
  ['<C-x>'] = cmd('HopWordBC'),
})

map.v({
  -- hop.nvim
  ['s'] = cmd('HopWordAC'),
  ['x'] = cmd('HopWordBC'),
})

vim.keymap.set({ 'i', 'n' }, '<C-x><C-f>', function()
  require('fzf-lua').complete_file({
    cmd = 'rg --files',
    winopts = { preview = { hidden = 'nohidden' } },
  })
end, { silent = true, desc = 'Fuzzy complete file' })

--template.nvim
map.n('<Leader>t', function()
  local tmp_name
  if vim.bo.filetype == 'lua' then
    tmp_name = 'nvim_temp'
  end
  if tmp_name then
    vim.cmd('Template ' .. tmp_name)
    return
  end
  return ':Template '
end, { expr = true })

-- Lspsaga floaterminal
map.nt('<A-d>', cmd('Lspsaga term_toggle'))

map.nx('ga', cmd('Lspsaga code_action'))

local loaded_netrw = false
-- keymap see internal/event.lua
map.n('<leader>n', function()
  if not loaded_netrw then
    vim.g.loaded_netrwPlugin = nil
    vim.g.netrw_keepdir = 0
    vim.g.netrw_winsize = math.floor((30 / vim.o.columns) * 100)
    vim.g.netrw_banner = 0
    vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
    vim.g.netrw_liststyle = 3
    vim.cmd.source(vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim')
    vim.cmd('Lexplore %:p:h')
    loaded_netrw = true
    return
  end
  vim.cmd('Lexplore %:p:h')
end)
