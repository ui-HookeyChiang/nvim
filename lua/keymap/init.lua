require('keymap.remap')
local map = require('core.keymap')
local cmd = map.cmd

map.n({
  -- lazy
  ['<Leader>pu'] = cmd('Lazy update'),
  ['<Leader>pi'] = cmd('Lazy install'),

  -- Lspsaga
  ['[e'] = ':Lspsaga diagnostic_jump_next<CR>',
  [']e'] = ':Lspsaga diagnostic_jump_prev<CR>',
  ['K'] = cmd('Lspsaga hover_doc'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gr'] = cmd('Lspsaga rename'),
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
  -- Telescope
  ['<Leader>fa'] = cmd('Telescope app'),
  ['<Leader>fw'] = cmd('Telescope live_grep'),
  ['<Leader>fs'] = cmd('Telescope grep_string'),
  ['<Leader>ff'] = cmd(
    'Telescope find_files find_command=rg,--ignore,--hidden,--files'
  ),
  ['<Leader>fg'] = cmd('Telescope git_files'),
  ['<Leader>fh'] = cmd('Telescope help_tags'),
  ['<Leader>fo'] = cmd('Telescope oldfiles'),
  ['<Leader>fc'] = cmd('Telescope git_commits'),
  ['<Leader>fd'] = cmd('Telescope dotfiles'),
  ['<Leader>fb'] = cmd('Telescope buffers'),
  -- flybuf.nvim
  ['<Leader>j'] = cmd('FlyBuf'),

  --gitsign
  [']g'] = cmd('lua require"gitsigns".next_hunk()<CR>'),
  ['[g'] = cmd('lua require"gitsigns".prev_hunk()<CR>'),
  --rapid
  ['<leader>c'] = cmd('Rapid'),

  ['<leader>gs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
  ['<leader>gu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
  ['<leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
  ['<leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
  ['<leader>gb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',

  -- hop.nvim
  ['s'] = cmd('HopWordAC'),
  ['x'] = cmd('HopWordBC'),

  -- splits
  ['<C-Left>'] = cmd('SmartCursorMoveLeft'),
  ['<C-Down>'] = cmd('SmartCursorMoveDown'),
  ['<C-Up>'] = cmd('SmartCursorMoveUp'),
  ['<C-Right>'] = cmd('SmartCursorMoveRight'),
  ['<A-Left>'] = cmd('SmartResizeLeft 3'),
  ['<A-Down>'] = cmd('SmartResizeDown 3'),
  ['<A-Up>'] = cmd('SmartResizeUp 3'),
  ['<A-Right>'] = cmd('SmartResizeRight 3'),
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
