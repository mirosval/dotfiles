autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()
