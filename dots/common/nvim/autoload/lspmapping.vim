function! lspmapping#on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=auto
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    nmap <buffer> <leader>en <plug>(lsp-next-error)
    nmap <buffer> <leader>ep <plug>(lsp-previous-error)

    " format on save
    " autocmd! BufWritePre *.rs call execute('LspDocumentFormatSync')
    " autocmd BufWritePre <buffer> call execute('LspCodeActionSync source.organizeImports')

    " refer to doc to add more commands
endfunction
