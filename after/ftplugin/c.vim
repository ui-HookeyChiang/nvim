" Detect if we're in a Linux kernel source tree
function! s:DetectKernelSource()
    " Check for kernel-specific files in the git root or current path
    let l:path = expand('%:p')
    let l:dir = expand('%:p:h')

    " Check if path contains typical kernel directories
    if l:path =~? '\v(linux|kernel)' && (filereadable(l:dir . '/Kbuild') || filereadable(l:dir . '/Kconfig'))
        return 1
    endif

    " Try to find git root and check for kernel markers
    let l:git_root = system('git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel 2>/dev/null')
    if v:shell_error == 0
        let l:git_root = substitute(l:git_root, '\n', '', '')
        if filereadable(l:git_root . '/MAINTAINERS') && filereadable(l:git_root . '/COPYING') && isdirectory(l:git_root . '/Documentation')
            return 1
        endif
    endif

    return 0
endfunction

" Apply Linux kernel coding style or default style
if s:DetectKernelSource()
    " Linux kernel coding style: tabs with width 8
    setl noexpandtab
    setl shiftwidth=8
    setl softtabstop=8
    setl tabstop=8
else
    " Default C style
    setl expandtab
    setl shiftwidth=4
    setl softtabstop=4
    setl tabstop=4
endif

inoreabbrev <buffer> #i #include
inoreabbrev <buffer> s struct
inoreabbrev <buffer> t typdef
