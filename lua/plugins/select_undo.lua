return {
    "SunnyTamang/select-undo.nvim",
    event = { "BufreadPost", "BufNewFile" },
    keys = {
        "<F13>u",
        "<F13>cu",
    },
    opts = {
        persistent_undo = true, -- Enables persistent undo history
        mapping = true, -- Enables default keybindings
        line_mapping = "<F13>u", -- Undo for entire lines
        partial_mapping = "<F13>cu", -- Undo for selected characters -- Note: dont use this line as gu can also handle partial undo
    },
}
