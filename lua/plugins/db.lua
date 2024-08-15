--[[ return {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DB", "DBUI", 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    keys = {
        vim.keymap.set('n', '<Leader>oD', "<cmd>DBUIToggle<cr>", { desc = "DadBod", noremap = true, silent = true }),
    },
    dependencies = { "kristijanhusak/vim-dadbod-completion", "tpope/vim-dadbod", },
    init = function()
        vim.g.dbs = {
            { name = "large",      url = "jq:" .. vim.fn.expand("$HOME/Downloads/large-file.json") },
            { name = "sql_lite_1", url = "sqlite:" .. vim.fn.expand("$HOME/db/sakila-sqlite3/sakila_master.db") },

        }
        local data_path = vim.fn.stdpath("data")
        vim.g.db_ui_auto_execute_table_helpers = 1
        vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
        vim.g.db_ui_show_database_icon = true
        vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
        vim.g.db_ui_use_nerd_fonts = true
        vim.g.db_ui_use_nvim_notify = true
        vim.g.db_ui_win_position = 'right'

        -- NOTE: The default behavior of auto-execution of queries on save is disabled
        -- this is useful when you have a big query that you don't want to run every time
        -- you save the file running those queries can crash neovim to run use the
        -- default keymap: <leader>S
        vim.g.db_ui_execute_on_save = false
        vim.g.db_ui_disable_mappings = false

        local augroup = vim.api.nvim_create_augroup
        local au_dbui = augroup("dbui", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = au_dbui,
            pattern = { 'sql' },
            callback = function(event)
                local del = vim.keymap.del
                pcall(del, { "n" }, "<leader>E", { buffer = event.buf })
                pcall(del, { "n" }, "<leader>W", { buffer = event.buf })
                pcall(del, { "n", 'v' }, "<leader>S", { buffer = event.buf })
                vim.keymap.set({ 'n' }, "<leader>r", "<nop>",
                    { desc = "which_key_ignore", buffer = event.buf, noremap = false })
                vim.keymap.set({ 'n', 'v' }, "<leader>rc", "<Plug>(DBUI_ExecuteQuery)",
                    { desc = "Run Query", buffer = event.buf, noremap = false })
                vim.keymap.set({ 'n', 'v' }, "<leader>re", "<Plug>(DBUI_EditBindParameters)",
                    { desc = "Edit Query Params", buffer = event.buf, noremap = false })
            end,
        })
    end,
} ]]

return {
    {
        -- download Dbee binary from the release and add it to the path
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = "Dbee",
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install("curl")
        end,
        keys = {
            vim.keymap.set("n", "<F13>d", "<cmd>Dbee<cr>", { desc = "DBee", noremap = true, silent = true }),
        },
        config = function()
            require("dbee").setup({
                sources = {
                    require("dbee.sources").MemorySource:new({
                        {
                            name = "db",
                            id = "db",
                            type = "sqlite",
                            url = vim.fn.expand("$HOME/db/sakila-sqlite3/sakila_master.db"),
                        },
                        {
                            name = "jsq",
                            id = "jsqi",
                            type = "jq",
                            url = vim.fn.expand("$HOME/Downloads/large-file.json"),
                        },
                    }),
                    require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
                    require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
                },
            })
        end,
    },
}
