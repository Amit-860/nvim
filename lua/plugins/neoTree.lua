return {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "mrbjarksen/neo-tree-diagnostics.nvim",
    },
    config = function()
        local icons = require("icons")

        local git_available = vim.fn.executable "git" == 1
        local sources = {
            { source = "filesystem", display_name = " " .. icons.astro.FolderClosed .. " " .. "File" },
        }

        if git_available then
            table.insert(sources, 2, { source = "git_status", display_name = " " .. icons.astro.Git .. " " .. "Git" })
        end

        require("neo-tree").setup({
            close_if_last_window = false,
            popup_border_style = "single",
            enable_diagnostics = false,
            sources = { "filesystem", git_available and "git_status" or nil, "diagnostics", "document_symbols" },
            source_selector = {
                winbar = false,
                content_layout = "center",
                sources = sources,
            },
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
            default_component_configs = {
                indent = {
                    padding = 0,
                    expander_collapsed = icons.astro.FoldClosed,
                    expander_expanded = icons.astro.FoldOpened,
                },
                icon = {
                    folder_closed = icons.astro.FolderClosed,
                    folder_open = icons.astro.FolderOpen,
                    folder_empty = icons.astro.FolderEmpty,
                    folder_empty_open = icons.astro.FolderEmpty,
                    default = icons.astro.DefaultFile,
                },
                modified = { symbol = icons.astro.FileModified },
                git_status = {
                    symbols = {
                        added = icons.astro.GitAdd,
                        deleted = icons.astro.GitDelete,
                        modified = icons.astro.GitChange,
                        renamed = icons.astro.GitRenamed,
                        untracked = icons.astro.GitUntracked,
                        ignored = icons.astro.GitIgnored,
                        unstaged = icons.astro.GitUnstaged,
                        staged = icons.astro.GitStaged,
                        conflict = icons.astro.GitConflict,
                    },
                },
            },
            -- These are the defaults
            diagnostics = {
                window = {
                    relative = "win",
                    position = "bottom",
                    height = "30%",
                    mappings = {
                        ["<space>"] = "none",
                        ["<2-LeftMouse>"] = "open",
                        ["<cr>"] = "open",
                        ["<esc>"] = "cancel", -- close preview or floating neo-tree window
                        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                        ["l"] = "focus_preview",
                        ["S"] = "open_split",
                        ["s"] = "open_vsplit",
                        ["T"] = "open_tabnew",
                        ["w"] = "open_with_window_picker",
                        ["t"] = "toggle_node",
                        ['z'] = 'close_all_subnodes',
                        ["Z"] = "close_all_nodes",
                        ["a"] = "none",
                        ["r"] = "none",
                        ["y"] = "none",
                        ["x"] = "none",
                        ["p"] = "none",
                        ["c"] = "none", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                        ["m"] = "none", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                        ["q"] = "close_window",
                        ["R"] = "refresh",
                        ["?"] = "show_help",
                        ["<"] = "prev_source",
                        [">"] = "next_source",
                        ["i"] = "show_file_details",
                    }
                },
                auto_preview = {             -- May also be set to `true` or `false`
                    enabled = false,         -- Whether to automatically enable preview mode
                    preview_config = {},     -- Config table to pass to auto preview (for example `{ use_float = true }`)
                    event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
                },
                bind_to_cwd = true,
                diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
                -- "position" means diagnostic items are sorted strictly by their positions.
                -- May also be a function.
                follow_current_file = {       -- May also be set to `true` or `false`
                    enabled = true,           -- This will find and focus the file in the active buffer every time
                    always_focus_file = false, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
                    expand_followed = true,   -- Ensure the node of the followed file is expanded
                    leave_dirs_open = false,  -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                    leave_files_open = false, -- `false` closes auto expanded files, such as with `:Neotree reveal`
                },
                group_dirs_and_files = true,  -- when true, empty folders and files will be grouped together
                group_empty_dirs = true,      -- when true, empty directories will be grouped together
                show_unloaded = false,        -- show diagnostics from unloaded buffers
                refresh = {
                    delay = vim.o.timeoutlen, -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
                    event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
                    -- Set to `false` or `"none"` to disable automatic refreshing
                    max_items = 100,          -- The maximum number of diagnostic items to attempt processing
                    -- Set to `false` for no maximum
                },
                components = {
                    linenr = function(config, node)
                        local lnum = tostring(node.extra.diag_struct.lnum + 1)
                        local pad = string.rep(" ", 4 - #lnum)
                        return {
                            {
                                text = pad .. lnum,
                                highlight = "LineNr",
                            },
                            {
                                text = "▕ ",
                                highlight = "NeoTreeDimText",
                            },
                        }
                    end,
                },
                renderers = {
                    file = {
                        { "indent" },
                        { "icon" },
                        { "grouped_path" },
                        { "name",             highlight = "NeoTreeFileNameOpened" },
                        --{ "diagnostic_count", show_when_none = true },
                        { "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Error", right_padding = 0 },
                        { "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Warn",  right_padding = 0 },
                        { "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Info",  right_padding = 0 },
                        { "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Hint",  right_padding = 0 },
                        { "clipboard" },
                    },
                    diagnostic = {
                        { "indent" },
                        { "icon" },
                        { "linenr" },
                        { "name" },
                        { "source" },
                        --{ "code" },
                    },
                },
            },
            document_symbols = {
                follow_cursor = true,
            },

        })


        vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "Normal" })
    end
}
