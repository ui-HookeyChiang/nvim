local lspconfig = require('lspconfig')
local _attach = require('modules.lsp.backend')._attach
local capabilities = require('modules.lsp.backend').capabilities

-- npm i -g vscode-langservers-extracted
lspconfig.jsonls.setup({
  on_attach = _attach,
  capabilities = capabilities,
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = {
            ".babelrc",
            ".babelrc.json",
            "babel.config.json",
          },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json",
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json",
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
          },
          url = "http://json.schemastore.org/stylelintrc.json",
        },
      },
    },
  },
})

-- sudo npm cache clean -f
-- sudo npm install -g n
-- sudo n stable
-- npm i -g typescript
-- npm i -g typescript-langauge-server
lspconfig.tsserver.setup({
  on_attach = _attach,
  capabilities = capabilities,
})

-- npm i -g vscode-langservers-extracted
lspconfig.eslint.setup({
  filetypes = { 'javascriptreact', 'typescriptreact' },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    _attach(client)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
})
