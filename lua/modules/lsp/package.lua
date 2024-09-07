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
        'pylsp',
        'bashls',
        'jsonls',
        'tsserver',
        'gopls',
        'lua_ls',
        'rust_analyzer',
        'clangd',
        'sqlls',
        'marksman',
        'html',
        'vimls',
        'yamlls',
        'texlab',
      },
      automatic_installation = true,
    })
    pylsp_postinst()
  end,
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim',          build = ':MasonUpdate' },
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

function pylsp_postinst()
  local pylsp = require("mason-registry").get_package("python-lsp-server")
  pylsp:on("install:success", function()
    -- Install pylsp plugins...
    local function mason_package_path(package)
      local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
      return path
    end

    local path = mason_package_path("python-lsp-server")
    local command = path .. "/venv/bin/pip"
    local args = {
      "install",
      "pylsp-rope",
      "python-lsp-black",
      "pyflakes",
      "python-lsp-ruff",
      "pyls-flake8",
      "sqlalchemy-stubs",
    }

    require("plenary.job")
        :new({
          command = command,
          args = args,
          cwd = path,
        })
        :start()
  end)
end
