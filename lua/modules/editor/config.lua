local M = {}
local api = vim.api

function M.nvim_treesitter()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'rust',
      'zig',
      'lua',
      'go',
      'python',
      'proto',
      'typescript',
      'javascript',
      'tsx',
      'css',
      'scss',
      'diff',
      'dockerfile',
      'gomod',
      'gosum',
      'gowork',
      'graphql',
      'html',
      'sql',
      'markdown',
      'markdown_inline',
      'json',
      'jsonc',
      'vimdoc',
      'vim',
      'cmake',
    },
    highlight = {
      enable = true,
      disable = function(_, buf)
        local bufname = vim.api.nvim_buf_get_name(buf)
        local max_filesize = 300 * 1024
        local ok, stats = pcall(vim.uv.fs_stat, bufname)
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
  })

  api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local ok = pcall(vim.treesitter.get_parser, args.buf)
      if ok and vim.wo.foldmethod ~= 'expr' then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.defer_fn(function()
          vim.cmd('normal! zx')
        end, 50)
      end
    end,
  })
end

function M.gomove()
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
end

return M
