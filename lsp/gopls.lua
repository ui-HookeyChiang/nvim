return {
  cmd = { 'gopls', 'serve' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      env = {
        GOFLAGS = '-tags=windows,linux,testing,debug',
      },
    },
  },
} --[[@as vim.lsp.Config]]
