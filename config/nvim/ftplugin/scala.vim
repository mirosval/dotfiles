autocmd BufWritePre *.scala :call LanguageClient#textDocument_formatting_sync()
