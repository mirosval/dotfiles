local nvim_lsp = require'nvim_lsp'

-- attach completion and diag on setup
local on_attach = function(client) 
    require'completion'.on_attach(client)
    require'diagnostic'.on_attach(client)
end

-- :LspInstall cssls
nvim_lsp.cssls.setup({ on_attach=on_attach })

-- LspInstall diagnosticls
nvim_lsp.diagnosticls.setup({ 
    on_attach=on_attach,
    filetypes = { "javascript", "javascript.jsx", "sh" },
    init_options = {
        filetypes = {
            javascript = "eslint",
            ["javascript.jsx"] = "eslint",
            javascriptreact = "eslint",
            typescriptreact = "eslint",
            sh = "shellcheck"
        },
        linters = {
            eslint = {
                sourceName = "eslint",
                command = "./node_modules/.bin/eslint",
                rootPatterns = { ".eslintrc", ".eslintrc.json", ".eslintrc.cjs", ".eslintrc.js", ".eslintrc.yml", ".eslintrc.yaml", "package.json" },
                debounce = 100,
                args = {
                    "--stdin",
                    "--stdin-filename",
                    "%filepath",
                    "--format",
                    "json",
                },
                parseJson = {
                    errorsRoot = "[0].messages",
                    line = "line",
                    column = "column",
                    endLine = "endLine",
                    endColumn = "endColumn",
                    message = "${message} [${ruleId}]",
                    security = "severity",
                },
                securities = {
                    [2] = "error",
                    [1] = "warning"
                }
            },
            shellcheck = {
                sourceName = "shellcheck",
                command = "shellcheck",
                debounce = 100,
                args = { "--format=gcc", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    {
                        line = 1,
                        column = 2,
                        message = 4,
                        security = 3
                    };
                },
                securities = {
                    error = "error",
                    warning = "warning",
                    note = "info"
                };
            }
        }
    }
})

-- LspInstall gopls
nvim_lsp.gopls.setup({ on_attach=on_attach })

-- LspInstall html
nvim_lsp.html.setup({ on_attach=on_attach })

-- LspInstall jsonls
nvim_lsp.jsonls.setup({ on_attach=on_attach })

-- LspInstall julials
nvim_lsp.julials.setup({ on_attach=on_attach })

-- LspInstall kotlin_language_server
nvim_lsp.kotlin_language_server.setup({ on_attach=on_attach })

-- LspInstall metals
nvim_lsp.metals.setup({ on_attach=on_attach })

-- LspInstall pyls
nvim_lsp.pyls.setup({ on_attach=on_attach })

-- LspInstall rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

-- LspInstall terraformls
nvim_lsp.terraformls.setup({ on_attach=on_attach })

-- LspInstall tsserver
nvim_lsp.tsserver.setup({ on_attach=on_attach })

-- LspInstall vimls
nvim_lsp.vimls.setup({ on_attach=on_attach })

