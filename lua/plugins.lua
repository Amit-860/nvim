return {
    -- theme
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Mason
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "stylua",
                "shfmt",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")

            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
    },

    -- keymappings
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        keymaps = { "<C-g>s", "<C-g>S", "ys", "yc", "S", "gs", "ds", "cs" },
        opts = {
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yc",
                visual = "S",
                visual_line = "gs",
                delete = "ds",
                change = "cs",
                change_line = "cS",
            },
        },
    },

    -- LSP
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
            enabled = function(root_dir)
                if vim.fn.expand(root_dir) == vim.fn.expand("$HOME/AppData/Local/nvim") then
                    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
                end
                return true
            end,
        },
    },
    {
        "folke/persistence.nvim",
        event = { "BufReadPre" },
        opts = {},
    },
    {
        "pmizio/typescript-tools.nvim",
        cond = false,
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                tsserver_file_preferences = {
                    quotePreference = "single",
                },
                tsserver_format_options = {
                    semicolons = "insert",
                },
            },
        },
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "hedyhli/outline.nvim",
        event = "LspAttach",
        cmd = { "Outline", "OutlineOpen" },
        opts = {},
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "VeryLazy" },
        config = function()
            require("rainbow-delimiters.setup").setup({
                strategy = {
                    [""] = function(bufnr)
                        local line_count = vim.api.nvim_buf_line_count(bufnr)
                        if line_count > 1000 then
                            return nil
                        end
                        return require("rainbow-delimiters").strategy["global"]
                    end,
                },
                query = {},
                highlight = {},
            })
        end,
    },
    {
        "andymass/vim-matchup",
        event = { "BufNewFile", "BufReadPost" },
        init = function()
            -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
            vim.g.matchup_matchparen_offscreen = {}
        end,
    },

    -- motion
    { "tpope/vim-repeat" },
    {
        "folke/flash.nvim",
        event = { "VeryLazy" },
        -- cond = not vim.g.vscode,
        opts = {
            modes = { char = { jump_labels = true }, search = { enabled = false } },
            exclude = {
                "notify",
                "cmp_menu",
                "noice",
                "flash_prompt",
                "neogit",
                "NeogitStatus",
                function(win)
                    return not vim.api.nvim_win_get_config(win).focusable
                end,
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump({})
                end,
                desc = "Flash",
            },
            {
                "<M-t>",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "S",
                mode = { "n" },
                function()
                    require("flash").jump({ pattern = vim.fn.expand("<cword>") })
                end,
                desc = "Flash Treesitter",
            },
            {
                "<M-/>",
                mode = { "n" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
    {
        "chrisgrieser/nvim-spider",
        event = { "VeryLazy" },
        lazy = true,
        opts = {
            skipInsignificantPunctuation = true,
            consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
            subwordMovement = true,
        },
    },
    {
        "monaqa/dial.nvim",
        keys = {
            { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" }, remap = true },
            { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                    augend.constant.alias.bool, -- boolean value (true <-> false)
                    augend.date.alias["%Y/%m/%d"], -- date (2022/02/18, etc.)
                    augend.date.alias["%m/%d/%Y"], -- date (02/19/2022)
                    augend.date.new({ pattern = "%m-%d-%Y", default_kind = "day", only_valid = true, word = false }), -- date (02-19-2022)
                    augend.date.new({ pattern = "%Y-%m-%d", default_kind = "day", only_valid = true, word = false }), -- date (02-19-2022)
                    augend.date.new({ pattern = "%m.%d.%Y", default_kind = "day", only_valid = true, word = false }),
                    augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { ">", "<" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "===", "!==" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "True", "False" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "and", "or", "not" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "+", "-" }, word = false, cyclic = true }),
                    augend.constant.new({ elements = { "*", "/", "//", "%" }, word = false, cyclic = true }),
                },
            })
        end,
    },
    {
        "max397574/better-escape.nvim",
        event = "VeryLazy",
        cond = not vim.g.vscode,
        config = function()
            require("better_escape").setup({
                timeout = vim.o.timeoutlen,
                mappings = {
                    i = { j = { k = "<esc>", j = false } },
                    c = { j = { k = "<esc>", j = false } },
                    t = { j = { k = false, j = false } },
                    v = { j = { k = false, j = false } },
                    s = { j = { k = "<esc>", j = false } },
                },
            })
        end,
    },

    -- mini
    {
        "shellRaining/hlchunk.nvim",
        cond = not vim.g.vscode,
        event = { "BufNewFile", "BufReadPost" },
        config = function()
            local opts = {
                chunk = {
                    enable = true,
                    duration = 50,
                    delay = 80,
                    exclude_filetypes = {
                        alpha = true,
                        TelescopePrompt = true,
                        Outline = true,
                        ["neo-tree"] = true,
                        ["neo-tree-popup"] = true,
                    },
                },
                line_num = { enable = false },
                blank = { enable = false },
                indent = {
                    enable = true,
                    chars = {
                        "",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                        "│",
                    },
                    exclude_filetypes = {
                        alpha = true,
                        TelescopePrompt = true,
                        Outline = true,
                        ["neo-tree"] = true,
                        ["neo-tree-popup"] = true,
                    },
                },
            }
            require("hlchunk").setup(opts)
        end,
    },

    -- leetcode
    {
        "kawre/leetcode.nvim",
        cmd = { "Leet" },
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- optional
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            -- configuration goes here
            lang = "python3",
            storage = {
                home = "D:/neetcode/leetcode",
                cache = vim.fn.stdpath("cache") .. "/leetcode",
            },
        },
    },

    -- completion
    {
        "onsails/lspkind.nvim",
        event = "VeryLazy",
    },

    -- filtesystem
    {
        "nanotee/zoxide.vim",
        cmd = { "Z" },
    },

    -- git
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    },

    -- file browsers
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>fB",
                function()
                    require("yazi").yazi()
                end,
                desc = "File Browser",
            },
            {
                "<leader>fb",
                function()
                    require("yazi").yazi(nil, vim.fn.getcwd())
                end,
                desc = "File Browser .",
            },
        },
        config = function()
            local yazi_opts = {
                open_for_directories = true,
                floating_window_scaling_factor = 0.85,
                yazi_floating_window_border = "rounded",
            }
            if vim.g.neovide then
                yazi_opts.yazi_floating_window_winblend = 50
            end
            require("yazi").setup(yazi_opts)
        end,
    },
    {
        "NeogitOrg/neogit",
        cmd = { "Neogit" },
        opts = {
            graph_style = "unicode",
            telescope_sorter = function()
                return require("telescope").extensions.fzy_native.native_fzy_sorter()
            end,
            integrations = { telescope = true, diffview = true },
            disable_line_numbers = true,
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",
        },
        config = true,
    },

    -- marks/bookmarks
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            scope = "git_branch",
            icons = true,
            quick_select = "123456789",
            scopes = {},
            win_opts = {
                border = "rounded",
            },
        },
        keys = {
            {
                "ma",
                function()
                    require("grapple").tag({ scope = "git_branch" })
                end,
                desc = "Toggle tag",
            },
            {
                "<leader>fm",
                "<cmd>Telescope grapple tags scope=git_branch theme=get_ivy<cr>",
                desc = "Telescope marks",
            },
            {
                "<M-m>",
                function()
                    require("grapple").toggle_tags({ scope = "git_branch" })
                end,
                desc = "Grapple mark",
            },
            {
                "mm",
                function()
                    require("grapple").toggle_tags({ scope = "git_branch" })
                end,
                desc = "Grapple mark",
            },
        },
    },

    -- Find and Replace
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        keys = {
            vim.keymap.set("n", "<leader>rs", function()
                require("spectre").toggle()
            end, { desc = "Toggle Spectre" }),
            vim.keymap.set("n", "<F13>ss", function()
                require("spectre").toggle()
            end, { desc = "Toggle Spectre" }),
            vim.keymap.set("n", "<F13>sw", function()
                require("spectre").open_visual({ select_word = true })
            end, { desc = "Search current word" }),
            vim.keymap.set("v", "<F13>sw", function()
                require("spectre").open_visual()
            end, { desc = "Search current word" }),
            vim.keymap.set("n", "<F13>sf", function()
                require("spectre").open_file_search({ select_word = true })
            end, { desc = "Search on current file" }),
        },
        config = function()
            require("spectre").setup({})
        end,
    },

    -- Code-Snapshot
    {
        "SergioRibera/codeshot.nvim",
        cmd = { "SSSelected", "SSFocused" },
        keys = {
            vim.keymap.set("v", "<Leader>s", "<nop>", { desc = "Codeshot", noremap = true, silent = true }),
            vim.keymap.set("v", "<Leader>ss", ":SSSelected<cr>", { desc = "Selected", noremap = true, silent = true }),
            vim.keymap.set(
                "n",
                "<Leader>os",
                ":SSFocused<cr>",
                { desc = "Codeshot focused", noremap = true, silent = true }
            ),
        },
        config = function()
            require("codeshot").setup({
                use_current_theme = false,
                output = vim.fn.expand("$HOME") .. "/codeshot/CodeShot_${year}-${month}-${date}_${time}.png",
            })
        end,
    },

    -- hover
    {
        "lewis6991/hover.nvim",
        event = "VeryLazy",
        keys = function()
            local hover = require("hover")
            return {
                -- Setup keymaps
                vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" }),
                vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" }),
                vim.keymap.set("n", "<tab>", function()
                    hover.hover_switch("previous")
                end, { desc = "hover.nvim (previous source)" }),
                vim.keymap.set("n", "<S-tab>", function()
                    hover.hover_switch("next")
                end, { desc = "hover.nvim (next source)" }),

                -- Mouse support
                -- vim.o.mousemoveevent = true
                -- vim.keymap.set("n", "<MouseMove>", hover.hover_mouse, { desc = "hover.nvim (mouse)" })
            }
        end,
        config = function()
            local hover = require("hover")
            local hover_opts = {
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    require("hover.providers.gh")
                    require("hover.providers.gh_user")
                    require("hover.providers.dap")
                    require("hover.providers.fold_preview")
                    require("hover.providers.diagnostic")
                    require("hover.providers.man")
                    -- require("hover.providers.dictionary")
                end,
                preview_opts = {
                    border = "single",
                },
                -- Whether the contents of a currently open hover window should be moved
                -- to a :h preview-window when pressing the hover keymap.
                preview_window = true,
                title = true,
                mouse_providers = {
                    "LSP",
                },
                mouse_delay = 2000,
            }

            hover.setup(hover_opts)
        end,
    },
}
