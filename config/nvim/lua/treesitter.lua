require'nvim-treesitter.configs'.setup{
    ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "go",
        "graphql",
        "html",
        "javascript",
        "java",
        "jsdoc",
        "json",
        "julia",
        "kotlin",
        "lua",
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
