require('keymap.remap')
local map = require('core.keymap')
local cmd = map.cmd

map.n({
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
  ['<Leader>a'] = cmd('Telescope app'),
  ['<Leader>fw'] = cmd('Telescope live_grep'),
  ['<Leader>fs'] = cmd('Telescope grep_string'),
  ['<Leader>ff'] = cmd(
    'Telescope find_files cwd=$HOME/workspace' .. ' find_command=rg,--ignore,--hidden,--files'
  ),
  ['<Leader>fg'] = cmd('Telescope git_files'),
  ['<Leader>fh'] = cmd('Telescope help_tags'),
  ['<Leader>fo'] = cmd('Telescope oldfiles'),
  ['<Leader>gc'] = cmd('Telescope git_commits'),
  ['<Leader>fd'] = cmd('Telescope dotfiles'),
  -- flybuf.nvim
  ['<Leader>j'] = cmd('FlyBuf'),
  --gitsign
  [']g'] = cmd('lua require"gitsigns".next_hunk()<CR>'),
  ['[g'] = cmd('lua require"gitsigns".prev_hunk()<CR>'),
  --rapid
  ['<leader>c'] = cmd('Rapid'),
  -- hop.nvim
  ['f'] = cmd('HopWordAC'),
  ['F'] = cmd('HopWordBC'),
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
