packadd({
  'neovim/nvim-lspconfig',
  ft = program_ft,
  config = function()
    vim.lsp.set_log_level(vim.lsp.log_levels.OFF)
    local i = '●'
    vim.diagnostic.config({
      signs = {
        text = { i, i, i, i },
      },
    })
    require('modules.lsp.config')
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = {
        'dockerls',
        'pyright',
        'bashls',
        'jsonls',
        'tsserver',
        'gopls',
        'lua_ls',
        'rust_analyzer',
        'clangd',
        'sqlls',
        'marksman',
      },
      automatic_installation = true,
    })
  end,
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate' },
  },
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

