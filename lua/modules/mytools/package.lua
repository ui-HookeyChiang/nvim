packadd({
  'ojroques/nvim-osc52',
  config = function()
    require('osc52').setup()
    local function copy()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        require('osc52').copy_register('"')
      end
    end

    local augroup = vim.api.nvim_create_augroup('osc52', {})
    vim.api.nvim_create_autocmd('TextYankPost', {
      group = augroup,
      callback = copy,
    })
  end,
})

packadd({
  'smoka7/hop.nvim',
  event = 'BufRead',
  config = function()
    local hop = require('hop')
    hop.setup({
      keys = 'qazwsxedcrfvtgb',
    })
  end,
})

packadd({
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
  end,
})

packadd({
  'ellisonleao/glow.nvim',
  config = function()
    require('glow').setup()
  end,
})
