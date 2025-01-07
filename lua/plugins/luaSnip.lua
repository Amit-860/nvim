return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = { "VeryLazy" },
    cond = not vim.g.vscode,
    dependencies = { { "rafamadriz/friendly-snippets", cond = not vim.g.vscode } },
    opts = {},
    config = function(_, opts)
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}
