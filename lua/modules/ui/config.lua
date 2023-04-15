local config = {}

function config.dashboard()
  local db = require('dashboard')
  db.setup({
    theme = 'hyper',
    config = {
      week_header = {
        enable = true,
      },
      project = {
        enable = false,
      },
      disable_move = true,
      shortcut = {
        {
          desc = 'Update',
          group = 'Include',
          action = 'Lazy update',
          key = 'u',
        },
        {
          desc = 'Files',
          group = 'Function',
          action = 'FzfLua files',
          key = 'f',
        },
        {
          desc = 'Apps',
          group = 'String',
          action = 'Telescope app',
          key = 'a',
        },
        {
          desc = 'Configs',
          group = 'Constant',
          action = 'FzfLua files cwd=$HOME/.config',
          key = 'd',
        },
      },
    },
  })
end

function config.gitsigns()
  require('gitsigns').setup({
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┃' },
    },
  })
end

function config.tokyonight()
  vim.cmd.colorscheme('tokyonight')
end

function config.lualine()
  require('lualine').setup({
    options = {
      theme = 'nord',
    },
  })
end

function config.smartsplits()
  require('smart-splits').setup({})
end

return config
