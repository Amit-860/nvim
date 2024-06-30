require("neo-tree").setup({
    close_if_last_window = false,
    popup_border_style = "single",
    window = {
        width = "20%",
        position = "right",
    },
    buffers = {
        follow_current_file = {
            enabled = true
        },
    },
    filesystem = {
        follow_current_file = {
            enabled = true
        },
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
                "node_modules"
            },
            never_show = {
                ".DS_Store",
                "thumbs.db"
            },
        },
    },
})
