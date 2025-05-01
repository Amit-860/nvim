local default_options = {
    foldenable = true,
    -- foldmethod = "manual",
    foldmethod = "expr", -- folding, set to "expr" for treesitter based folding / "manual"
    foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    foldlevel = 99,
    foldlevelstart = 99,
    foldnestmax = 9,
    foldminlines = 1,
}

for k, v in pairs(default_options) do
    vim.opt[k] = v
end
