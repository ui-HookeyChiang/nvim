local api = vim.api
local au = api.nvim_create_autocmd
local group = api.nvim_create_augroup('_my_events', {})

-- Fallback YankHighlight for schemes that don't define it (e.g. tokyonight).
-- `default` lets custom colorschemes (vsdark/solarized/eink) keep their override.
au('ColorScheme', {
  group = group,
  callback = function()
    api.nvim_set_hl(0, 'YankHighlight', { link = 'IncSearch', default = true })
  end,
})
-- colorscheme is set in init.lua before this file is sourced, so set it once now too.
api.nvim_set_hl(0, 'YankHighlight', { link = 'IncSearch', default = true })

au('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank({ higroup = 'YankHighlight', timeout = 400 })
  end,
})

-- tmux fast pane nav: set the @is_vim pane variable so tmux can route
-- <C-h/j/k/l> to Neovim (smart-splits) without forking `ps` on each keypress.
-- See ~/.tmux.conf.local (dotfiles). No-op outside tmux.
if vim.env.TMUX then
  local function set_is_vim(val)
    -- fire-and-forget; don't block the UI on the tmux call
    vim.system({ 'tmux', 'set-option', '-p', '@is_vim', val })
  end
  au({ 'VimEnter', 'FocusGained' }, {
    group = group,
    callback = function()
      set_is_vim('1')
    end,
  })
  au({ 'VimLeave', 'FocusLost' }, {
    group = group,
    callback = function()
      set_is_vim('')
    end,
  })
end

au('TermOpen', {
  group = group,
  command = 'setl stc= nonumber | startinsert!',
})

au('LspAttach', {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

au('InsertLeave', {
  group = group,
  callback = function()
    if vim.fn.executable('iswitch') == 0 then
      return
    end

    vim.system({ 'iswitch', '-s', 'com.apple.keylayout.ABC' }, nil, function(proc)
      if proc.code ~= 0 then
        vim.notify('Failed to switch input source: ' .. proc.stderr, vim.log.levels.WARN)
      end
    end)
  end,
  desc = 'auto switch to abc input',
})

au('InsertEnter', {
  group = group,
  once = true,
  callback = function()
    require('private.pairs')
  end,
  desc = 'auto pairs',
})

local function startuptime()
  if vim.g.strive_startup_time ~= nil then
    return
  end
  vim.g.strive_startup_time = 0
  local usage = vim.uv.getrusage()
  if usage then
    -- Calculate time in milliseconds (user + system time)
    local user_time = (usage.utime.sec * 1000) + (usage.utime.usec / 1000)
    local sys_time = (usage.stime.sec * 1000) + (usage.stime.usec / 1000)
    vim.g.nvim_startup_time = user_time + sys_time
  end
end

vim.lsp.enable({
  'luals',
  -- 'emmylua_ls',
  'clangd',
  'rust_analyzer',
  'basedpyright',
  'ruff',
  'gopls',
  'zls',
  'cmake',
  'tsls',
})

au('UIEnter', {
  group = group,
  once = true,
  callback = function()
    startuptime()
    vim.schedule(function()
      require('private.dashboard').show()
      require('private.keymap')
      require('private.indent')
      require('private.compile')

      -- smart-splits: nvim<->tmux seamless pane nav. Set here (not via the
      -- vim.pack re-add loader, which doesn't fire for already-registered
      -- plugins) so <C-h/j/k/l> reliably bind after private.keymap loads.
      pcall(function()
        vim.cmd.packadd('smart-splits.nvim')
        local ss = require('smart-splits')
        ss.setup({ log_level = 'warn' })
        vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
        vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
        vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
        vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
      end)

      if vim.version().minor >= 13 and pcall(require, 'vim._core.ui2') then
        require('vim._core.ui2').enable({ msg = { target = 'cmd' } })
      end

      vim.lsp.log.set_level(vim.log.levels.OFF)
      vim.diagnostic.config({
        float = {
          header = '',
        },
        -- i don't like CursorMoved so...
        virtual_text = {
          virt_text_pos = 'eol_right_align',
        },
        signs = {
          text = { '●', '●', '●', '●' },
          numhl = {
            'DiagnosticError',
            'DiagnosticWarn',
            'DiagnosticInfo',
            'DiagnosticHint',
          },
        },
        severity_sort = true,
      })

      api.nvim_create_user_command('LspLog', function()
        vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
      end, {
        desc = 'Opens the Nvim LSP client log.',
      })

      api.nvim_create_user_command('LspDebug', function()
        vim.lsp.log.set_level(vim.log.levels.WARN)
      end, { desc = 'enable lsp log' })

      vim.cmd.packadd('nohlsearch')
      vim.cmd.packadd('nvim.undotree')
    end)
  end,
  desc = 'Initializer',
})

au('FileType', {
  pattern = vim.g._lang,
  group = group,
  callback = function(opts)
    local lang = vim.treesitter.language.get_lang(vim.bo[opts.buf].filetype)
    if not lang then
      return
    end
    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(opts.buf, lang)
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
  desc = 'try start treesitter highlight',
})

au('BufWritePre', {
  pattern = '*',
  callback = function(args)
    local fname = api.nvim_buf_get_name(args.buf)
    if vim.bo[args.buf].filetype == 'vim' and fname:find('test') then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! keepjumps keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = 'remove tail space',
})
-- `wildmode=noinsert` + `wildtrigger()` cmdline completion is Neovim 0.13+ only.
-- Probe whether this build accepts the `noinsert` wildmode value before using it.
local has_noinsert = vim.fn.exists('*wildtrigger') == 1
  and pcall(vim.api.nvim_set_option_value, 'wildmode', 'noinsert:lastused,full', {})
if has_noinsert then
  vim.cmd([[autocmd CmdlineChanged [:\?] call wildtrigger()]])
else
  vim.o.wildmode = 'lastused:full'
end
