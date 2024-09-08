local conf = require('modules.tools.config')

packadd({
  'nvimdev/flybuf.nvim',
  cmd = 'FlyBuf',
  config = function()
    require('flybuf').setup({
      quit = '<C-c>', -- quit flybuf window
      delete = 'c',   -- delete marked buffers or buffers which cursor in
    })
  end,
})

packadd({ 'nvimdev/coman.nvim', event = 'BufRead' })

packadd({
  'nvimdev/template.nvim',
  cmd = 'Template',
  ft = { 'c', 'cpp', 'rust', 'lua', 'go' },
  config = conf.template_nvim,
})

packadd({
  'nvimdev/guard.nvim',
  ft = program_ft,
  config = conf.guard,
  dependencies = {
    { 'nvimdev/guard-collection' },
  },
})

packadd({
  'norcalli/nvim-colorizer.lua',
  event = 'BufEnter */colors/*',
  config = function()
    vim.opt.termguicolors = true
    require('colorizer').setup()
  end,
})

packadd({
  'nvimdev/dbsession.nvim',
  cmd = { 'SessionSave', 'SessionLoad', 'SessionDelete' },
  opts = true,
})

packadd({
  'nvimdev/rapid.nvim',
  cmd = 'Rapid',
  config = function()
    require('rapid').setup()
  end,
})

packadd({
  'nvimdev/nerdicons.nvim',
  cmd = 'NerdIcons',
  opts = true,
})

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

packadd({ 'smoka7/hop.nvim', event = 'BufRead', config = conf.hop })

packadd({
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
  end
})

packadd({
  "ellisonleao/glow.nvim",
  config = function()
    require("glow").setup()
  end
})
