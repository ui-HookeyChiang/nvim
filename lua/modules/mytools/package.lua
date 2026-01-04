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
  'kylechui/nvim-surround',
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup({})
  end,
})

packadd({
  'booperlv/nvim-gomove',
  config = function()
    require('gomove').setup({
      -- whether or not to map default key bindings, (true/false)
      map_defaults = true,
      -- whether or not to reindent lines moved vertically (true/false)
      reindent = true,
      -- whether or not to undojoin same direction moves (true/false)
      undojoin = true,
      -- whether to not to move past end column when moving blocks horizontally, (true/false)
      move_past_end_col = true,
    })
  end,
})
