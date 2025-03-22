packadd({
  'neovim/nvim-lspconfig',
  ft = program_ft,
  -- uncomment for arm64 clangd
  -- opts = {
  --   servers = {
  --     clangd = {
  --       mason = false,
  --     },
  --   },
  -- },
  config = function()
    -- vim.lsp.set_log_level(vim.lsp.log_levels.OFF)
    local i = '●'
    vim.diagnostic.config({
      virtual_text = { current_line = true },
      signs = {
        text = { i, i, i, i },
      },
    })
    require('modules.lsp.config')
  end,
})

packadd({
  'nvimdev/phoenix.nvim',
  ft = program_ft,
})

packadd({
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  config = function()
    require('lspsaga').setup({
      ui = { use_nerd = false },
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
      outline = {
        layout = 'float',
      },
      finder = {
        keys = {
          toggle_or_open = '<cr>',
          vsplit = 'v',
          split = 'x',
          quit = '<C-c>',
        },
      },
    })
  end,
})
