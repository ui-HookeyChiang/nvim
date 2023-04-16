packadd({
  'neovim/nvim-lspconfig',
  ft = {
    'go',
    'lua',
    'sh',
    'rust',
    'c',
    'cpp',
    'zig',
    'python',
    'proto',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
    'markdown',
  },
  config = function()
    local i = '■'
    vim.diagnostic.config({ signs = { text = { i, i, i, i } } })
    require('modules.lsp.backend')
    require('modules.lsp.frontend')

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
      symbol_in_winbar = {
        hide_keyword = true,
        folder_level = 0,
      },
      lightbulb = {
        sign = false,
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

packadd({
  'nvimdev/epo.nvim',
  event = 'LspAttach',
  config = function()
    require('epo').setup()
  end,
})
