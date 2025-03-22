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
  ['gk'] = cmd('Lspsaga hover_doc'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gd'] = cmd('Lspsaga peek_definition'),
  ['gD'] = cmd('Lspsaga goto_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['gh'] = cmd('Lspsaga finder'),
  ['gf'] = cmd('lua vim.lsp.buf.format()'),
  ['gs'] = cmd('lua vim.lsp.buf.references()'),
  ['gS'] = cmd('lua vim.lsp.buf.signature_help()'),
  ['<Leader>o'] = cmd('Lspsaga outline'),
  -- dbsession
  ['<Leader>ss'] = cmd('SessionSave'),
  ['<Leader>sl'] = cmd('SessionLoad'),
  -- FzfLua
  ['<Leader>b'] = cmd('FzfLua buffers'),
  ['<Leader>fa'] = cmd('FzfLua live_grep_native'),
  ['<Leader>fs'] = cmd('FzfLua grep_cword'),
  ['<Leader>ff'] = cmd('FzfLua files'),
  ['<Leader>fh'] = cmd('FzfLua helptags'),
  ['<Leader>fo'] = cmd('FzfLua oldfiles'),
  ['<Leader>fg'] = cmd('FzfLua git_files'),
  ['<Leader>gc'] = cmd('FzfLua git_commits'),
  ['<Leader>fc'] = cmd('FzfLua files cwd=$HOME/.config'),
  -- flybuf.nvim
  ['<Leader>j'] = cmd('FlyBuf'),
  --gitsign
  [']g'] = cmd('lua require"gitsigns".next_hunk()<CR>'),
  ['[g'] = cmd('lua require"gitsigns".prev_hunk()<CR>'),
})

map.ni('<C-X><C-f>', cmd('Dired'))

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
