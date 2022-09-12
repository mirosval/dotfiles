require'nvim-treesitter.configs'.setup{
    ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "go",
        "graphql",
        "haskell",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "julia",
        "kotlin",
        "latex",
        "lua",
        "make",
        "markdown",
        "python",
        "rust",
        "scala",
        "toml",
        "tsx",
        "typescript",
        "yaml"
    },
    autopairs = {
        enable = true
    },
    highlight = {
        enable = true
    },
    incremental_selection = {
        enable = true
    },
    indent = {
        enable = true
    },
}
