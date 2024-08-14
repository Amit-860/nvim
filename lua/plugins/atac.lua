return {
    "NachoNievaG/atac.nvim",
    cmd = "Atac",
    dependencies = { "akinsho/toggleterm.nvim" },
    config = function()
        require("atac").setup({
            dir = vim.fn.expand("$HOME/.atac"),
        })
    end,
}
