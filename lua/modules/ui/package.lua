local conf = require('modules.ui.config')

packadd({
  'nvimdev/dashboard-nvim',
  event = 'UIEnter',
  config = conf.dashboard,
})

packadd({
  'nvimdev/modeline.nvim',
  event = { 'BufReadPost */*', 'BufNewFile' },
  config = function()
    require('modeline').setup()
  end,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter */*',
  config = conf.gitsigns,
})

packadd({
  'nvimdev/dired.nvim',
  cmd = 'Dired',
})

packadd({
  'nvimdev/indentmini.nvim',
  event = 'BufEnter */*',
  config = function()
    vim.opt.listchars:append({ tab = '  ' })
    require('indentmini').setup({
      only_current = true,
    })
  end,
})

packadd({
  'folke/tokyonight.nvim',
  config = conf.tokyonight,
})

packadd({
  'nvim-lualine/lualine.nvim',
  config = conf.lualine,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
})

packadd({
  'mrjones2014/smart-splits.nvim',
  config = conf.smartsplits,
})
