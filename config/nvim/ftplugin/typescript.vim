autocmd BufWritePre *.ts :call LanguageClient#textDocument_formatting_sync()
