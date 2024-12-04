-- with lazy.nvim
return {
    "LintaoAmons/bookmarks.nvim",
    event = "VeryLazy",
    version = "v1.4.2",
    cond = not vim.g.vscode,
    opts = {},
    keys = {
        vim.keymap.set(
            { "n", "v" },
            "ma",
            "<cmd>BookmarksMark<cr>",
            { desc = "Mark current line into active BookmarkList.", silent = true }
        ),
        vim.keymap.set(
            { "n", "v" },
            "mm",
            "<cmd>BookmarksGoto<cr>",
            { desc = "Go to bookmark at current active BookmarkList", silent = true }
        ),
        vim.keymap.set(
            { "n", "v" },
            "ml",
            "<cmd>BookmarksCommands<cr>",
            { desc = "Find and trigger a bookmark command.", silent = true }
        ),
        vim.keymap.set(
            { "n", "v" },
            "mr",
            "<cmd>BookmarksGotoRecent<cr>",
            { desc = "Go to latest visited/created Bookmark", silent = true }
        ),
        vim.keymap.set(
            { "n" },
            "mt",
            "<cmd>BookmarksTree<cr>",
            { desc = "Go to Bookmarks Tree", noremap = true, silent = true }
        ),
    },
}
