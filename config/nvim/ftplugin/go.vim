autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
