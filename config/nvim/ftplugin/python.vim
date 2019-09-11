autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()
