return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.g.vscode,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {},
    config = function(_, opts)
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}
