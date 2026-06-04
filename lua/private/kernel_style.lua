-- Detect whether a C file lives in a Linux-kernel-style source tree, so the
-- ftplugin can switch to kernel coding style (hard tabs, width 8).
local M = {}

---@param fname string absolute path of the buffer file
---@return boolean
function M.is_kernel_source(fname)
  fname = fname or vim.fn.expand('%:p')
  if fname == '' then
    return false
  end
  local dir = vim.fn.fnamemodify(fname, ':h')

  -- Fast path: path mentions linux/kernel and a Kbuild/Kconfig sits next to it.
  if fname:lower():match('linux') or fname:lower():match('kernel') then
    if vim.fn.filereadable(dir .. '/Kbuild') == 1 or vim.fn.filereadable(dir .. '/Kconfig') == 1 then
      return true
    end
  end

  -- Slow path: find the git root and look for canonical kernel-tree markers.
  local out = vim.fn.systemlist({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == '' then
    return false
  end
  local root = out[1]
  return vim.fn.filereadable(root .. '/MAINTAINERS') == 1
    and vim.fn.filereadable(root .. '/COPYING') == 1
    and vim.fn.isdirectory(root .. '/Documentation') == 1
end

return M
