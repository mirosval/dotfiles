local lsp_status = require'lsp-status'

local kind_labels_mt = {__index = function(_, k) return k end}
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

lsp_status.register_progress()
lsp_status.config({
  kind_labels = kind_labels,
  indicator_errors = "?",
  indicator_warnings = "!",
  indicator_info = "i",
  indicator_hint = "Ý",
  -- the default is a wide codepoint which breaks absolute and relative
  -- line counts if placed before airline's Z section
  status_symbol = "",
})

local nvim_lsp = require'nvim_lsp'
local completion = require'completion'
local diagnostic = require'diagnostic'

-- attach completion and diag on setup
local on_attach = function(client) 
    lsp_status.on_attach(client)
    completion.on_attach(client)
    diagnostic.on_attach(client)
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
nvim_lsp.rust_analyzer.setup({ 
    on_attach=on_attach,
    capabilities = lsp_status.capabilities
})

-- LspInstall terraformls
nvim_lsp.terraformls.setup({ on_attach=on_attach })

-- LspInstall tsserver
nvim_lsp.tsserver.setup({ on_attach=on_attach })

-- LspInstall vimls
nvim_lsp.vimls.setup({ on_attach=on_attach })

