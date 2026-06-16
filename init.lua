local g = vim.g
vim.loader.enable()
g.mapleader = vim.keycode('<space>')

-- This config enables LSP servers by name via vim.lsp.enable and expects the
-- server binaries on $PATH. Reuse the binaries already installed by mason (and
-- cargo: stylua / tree-sitter) without pulling in the mason plugin itself.
do
  local extra = {
    vim.fn.stdpath('data') .. '/mason/bin',
    vim.fn.expand('~/.local/share/nvim/mason/bin'),
    vim.fn.expand('~/.cargo/bin'),
    vim.fn.expand('~/.local/bin'),
    vim.fn.expand('~/go/bin'), -- go toolchain (gopls shells out to `go`)
  }
  local sep = vim.fn.has('win32') == 1 and ';' or ':'
  local seen = {}
  for entry in (vim.env.PATH or ''):gmatch('[^' .. sep .. ']+') do
    seen[entry] = true
  end
  local prepend = {}
  for _, dir in ipairs(extra) do
    if vim.fn.isdirectory(dir) == 1 and not seen[dir] then
      prepend[#prepend + 1] = dir
    end
  end
  if #prepend > 0 then
    vim.env.PATH = table.concat(prepend, sep) .. sep .. vim.env.PATH
  end
end

g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_rrhelper = 1
g.loaded_netrwPlugin = 1
g.loaded_matchparen = 1

local o = vim.o

-- Set an option only if this Neovim build knows it. glepnir's config tracks
-- nightly and uses options (pummaxwidth, pumborder, winborder, smoothscroll,
-- scrolloffpad, ...) that older / stable builds reject with "Unknown option".
local function oset(name, value)
  if vim.fn.exists('&' .. name) == 1 then
    o[name] = value
  end
end
o.hidden = true
o.magic = true
o.termguicolors = true
o.virtualedit = 'block'
o.clipboard = 'unnamedplus'
o.wildignorecase = true
o.swapfile = false
o.timeout = true
o.ttimeout = true
o.timeoutlen = 500
o.ttimeoutlen = 10
o.updatetime = 500
o.ignorecase = true
o.smartcase = true
o.cursorline = true
o.showmode = false
o.shortmess = 'aoOTIcF'
o.scrolloff = 4
oset('scrolloffpad', 1)
o.sidescrolloff = 5
o.ruler = false
o.showtabline = 0
o.showcmd = false
o.pumheight = 15
oset('pummaxwidth', 30)
oset('pumborder', 'rounded')
o.list = true
--eol:¬
o.listchars = 'tab:» ,nbsp:+,trail:·,extends:→,precedes:←,'

-- Highlight trailing whitespace with a red background in every window.
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg = '#ff6b6b', fg = '#ffffff' })
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    vim.fn.matchadd('TrailingWhitespace', [[\s\+$]])
  end,
})

o.fillchars = 'trunc:…'
o.foldtext = ''
o.foldlevelstart = 99
o.undofile = true
o.linebreak = true
oset('smoothscroll', true)
o.smarttab = true
o.expandtab = true
o.autoindent = true
o.tabstop = 2
o.sw = 2
o.wrap = true
o.number = true
o.signcolumn = 'yes'
o.textwidth = 80
o.colorcolumn = '+0'
oset('winborder', 'rounded')
o.splitright = true
-- reset to 2 in dashboard.lua lnum 273
o.laststatus = 0
o.cot = 'menu,menuone,noinsert,fuzzy,popup' -- nosort or not???
o.cia = 'kind,abbr,menu'
vim.opt.guicursor:remove({ 't:block-blinkon500-blinkoff500-TermCursor' })

vim.cmd.packadd('tokyonight.nvim')
vim.cmd.colorscheme('tokyonight')
g.health = { style = 'float' }
g.editorconfig = false
g._lang = {
  'c',
  'cpp',
  'rust',
  'zig',
  'lua',
  'python',
  'proto',
  'typescript',
  'javascript',
  'tsx',
  'css',
  'scss',
  'diff',
  'dockerfile',
  'graphql',
  'html',
  'sql',
  'markdown',
  'markdown_inline',
  'vimdoc',
  'vim',
  'cmake',
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, active = ev.data.spec.name, ev.data.active
    if name == 'nvim-treesitter' then
      if not active then
        vim.cmd.packadd('nvim-treesitter')
      end
      local nts = require('nvim-treesitter')
      nts.install(g.lang, { summary = true })
      nts.update(nil, { summary = true })
    end
  end,
})

vim.api.nvim_create_user_command('PackDelete', function(args)
  vim.pack.del(args.fargs, { force = true })
end, {
  nargs = '+',
  complete = function()
    return vim
      .iter(vim.pack.get())
      :map(function(p)
        return p.spec.name
      end)
      :totable()
  end,
})

g.phoenix = {
  snippet = vim.fn.stdpath('config') .. '/snippets',
}

local P = {}

local function normalize_url(s)
  if s:match('^https?://') or s:match('^git@') then
    return s
  end
  return 'git@github.com:' .. s .. '.git'
end

local function normalize_spec(spec)
  if type(spec) == 'string' then
    return normalize_url(spec)
  end
  if spec.src then
    return vim.tbl_extend('force', spec, { src = normalize_url(spec.src) })
  end
  return spec
end

local function ensure_list(specs)
  return (type(specs) == 'string' or (type(specs) == 'table' and specs.src)) and { specs } or specs
end

local function on_cmd(cmd, pkg_name, setup_fn)
  return function()
    vim.api.nvim_create_user_command(cmd, function(data)
      vim.api.nvim_del_user_command(cmd)
      vim.cmd.packadd(pkg_name)
      if setup_fn then
        setup_fn()
      end
      vim.cmd(('%s %s'):format(cmd, data.args))
    end, { nargs = '?' })
  end
end

local function on_event(events, pkg_name, setup_fn)
  return function()
    vim.api.nvim_create_autocmd(events, {
      once = true,
      callback = function()
        for _, p in ipairs(ensure_list(pkg_name)) do
          vim.cmd.packadd(p)
        end
        if setup_fn then
          setup_fn()
        end
      end,
    })
  end
end

function P:add(specs, opts)
  specs = vim.tbl_map(normalize_spec, ensure_list(specs))
  vim.pack.add(specs, vim.tbl_extend('keep', opts or {}, { confirm = false }))
  return self
end

P:add({
  'nvimdev/modeline.nvim',
  'lewis6991/gitsigns.nvim',
  'nvimdev/phoenix.nvim',
  { src = 'nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'folke/tokyonight.nvim',
  'mrjones2014/smart-splits.nvim',
  'folke/flash.nvim',
  'kylechui/nvim-surround',
  'NvChad/nvim-colorizer.lua',
  'booperlv/nvim-gomove',
  'ojroques/nvim-osc52',
}, { load = false })
  :add('nvimdev/dired.nvim', {
    load = on_cmd('Dired', 'dired.nvim'),
  })
  :add('ibhagwan/fzf-lua', {
    load = on_cmd('FzfLua', 'fzf-lua', function()
      require('fzf-lua').setup({
        lsp = { symbols = { symbol_style = 3 } },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --colors 'path:fg:blue'",
        },
        live_grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --colors 'path:fg:blue'",
        },
        winopts = {
          preview = {
            default = true,
            builtin = {
              treesitter = { enabled = false },
            },
          },
        },
        files = { file_icons = false },
      })
    end),
  })
  :add({ 'nvimdev/guard.nvim', 'nvimdev/guard-collection' }, {
    load = on_event('BufReadPost', { 'guard.nvim', 'guard-collection' }, function()
      local ft = require('guard.filetype')
      ft('c,cpp'):fmt({
        cmd = 'clang-format',
        args = function(bufnr)
          local f = vim.bo[bufnr].filetype == 'cpp' and '.cc-format' or '.c-format'
          return { ('--style=file:%s/%s'):format(vim.env.HOME, f) }
        end,
        stdin = true,
        ignore_patterns = { 'neovim', 'vim' },
      })
      ft('lua'):fmt({
        cmd = 'stylua',
        args = { '-' },
        stdin = true,
        ignore_patterns = 'function.*_spec%.lua',
        find = '.stylua.toml',
      })
      ft('rust'):fmt('rustfmt')
      ft('typescript', 'javascript', 'typescriptreact', 'javascriptreact'):fmt('prettier')
    end),
  })
  :add('mrjones2014/smart-splits.nvim', {
    load = on_event('UIEnter', 'smart-splits.nvim', function()
      local ss = require('smart-splits')
      ss.setup({ log_level = 'warn' })
      vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
      vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
      vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
      vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
    end),
  })
  :add('folke/flash.nvim', {
    load = on_event('BufReadPost', 'flash.nvim', function()
      require('flash').setup({})
    end),
  })
  :add('kylechui/nvim-surround', {
    load = on_event('BufReadPost', 'nvim-surround', function()
      require('nvim-surround').setup({})
    end),
  })
  :add('NvChad/nvim-colorizer.lua', {
    load = on_event('BufReadPost', 'nvim-colorizer.lua', function()
      require('colorizer').setup({})
    end),
  })
  :add('booperlv/nvim-gomove', {
    load = on_event('BufReadPost', 'nvim-gomove', function()
      require('gomove').setup({})
    end),
  })
  :add('ojroques/nvim-osc52', {
    load = on_event('UIEnter', 'nvim-osc52', function()
      require('osc52').setup({ max_length = 0, silent = true, trim = false })
      vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
          if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
            require('osc52').copy_register('+')
          end
        end,
      })
    end),
  })
