return {
    -- theme
    {
        "nvim-tree/nvim-web-devicons",
        cond = not vim.g.vscode,
        lazy = true,
    },

    -- Mason
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        cond = not vim.g.vscode,
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
        cond = not vim.g.vscode,
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
        cond = not vim.g.vscode,
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
        "pmizio/typescript-tools.nvim",
        ft = { "javascriptreact", "typescriptreact" },
        cond = not vim.g.vscode,
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                format = { enable = false },
                tsserver_format_options = {
                    semicolons = "insert",
                },
                separate_diagnostic_server = true,
                expose_as_code_action = "all",
                -- tsserver_plugins = {},
                tsserver_max_memory = "auto",
                complete_function_calls = true,
                include_completions_with_insert_text = true,
                tsserver_file_preferences = {
                    quotePreference = "single", -- auto | double | single
                    includeInlayParameterNameHints = "all", -- "none" | "literals" | "all";
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                    includeCompletionsForModuleExports = true,
                    autoImportFileExcludePatterns = { "node_modules/*", ".git/*" },
                },
            },
        },
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        cond = not vim.g.vscode,
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "hedyhli/outline.nvim",
        event = "LspAttach",
        cond = not vim.g.vscode,
        cmd = { "Outline", "OutlineOpen" },
        opts = {},
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "VeryLazy" },
        cond = not vim.g.vscode,
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
        cond = not vim.g.vscode,
        init = function()
            -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
            vim.g.matchup_matchparen_offscreen = {}
        end,
        config = function()
            vim.api.nvim_set_hl(0, "MatchParen", { bg = nil, fg = "#dbc074", underline = true, bold = true })
            -- vim.api.nvim_set_hl(0, "MatchParen", { bg = "222b39", fg = "#ffffff", underline = false, bold = true })
        end,
    },

    -- motion
    { "tpope/vim-repeat" },
    {
        "folke/flash.nvim",
        event = { "VeryLazy" },
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
        cond = not vim.g.vscode,
        event = "VeryLazy",
        config = function()
            require("better_escape").setup({
                timeout = vim.o.timeoutlen,
                mappings = {
                    i = { j = { k = "<esc>", j = false } },
                    t = { j = { k = "<C-\\><C-n>", j = false } },
                    v = { j = { k = false, j = false } },
                    c = { j = { k = false, j = false } },
                    s = { j = { k = false, j = false } },
                },
            })
        end,
    },

    -- leetcode
    {
        "kawre/leetcode.nvim",
        cmd = { "Leet" },
        cond = not vim.g.vscode,
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
        cond = not vim.g.vscode,
    },

    -- filtesystem
    {
        "nanotee/zoxide.vim",
        cmd = { "Z" },
        cond = not vim.g.vscode,
    },

    -- git
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        cond = not vim.g.vscode,
    },

    -- file browsers
    {
        "mikavilpas/yazi.nvim",
        cond = not vim.g.vscode,
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
                yazi_floating_window_border = "single",
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
        cond = not vim.g.vscode,
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

    -- Find and Replace
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        cond = not vim.g.vscode,
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
    -- {
    --     "SergioRibera/codeshot.nvim",
    --     cmd = { "SSSelected", "SSFocused" },
    --     opts = {
    --         use_current_theme = false,
    --         -- theme = "DarkNeon",
    --         -- theme = "gruvbox-dark",
    --         theme = "Dracula",
    --         output = vim.fn.expand("$HOME") .. "/codeshot/CodeShot_${year}-${month}-${date}_${time}.png",
    --     },
    --     keys = {
    --         vim.keymap.set("v", "<Leader>s", "<nop>", { desc = "Codeshot", noremap = true, silent = true }),
    --         vim.keymap.set("v", "<Leader>ss", ":SSSelected<cr>", { desc = "Selected", noremap = true, silent = true }),
    --         vim.keymap.set(
    --             "n",
    --             "<Leader>os",
    --             ":SSFocused<cr>",
    --             { desc = "Codeshot focused", noremap = true, silent = true }
    --         ),
    --     },
    --     config = function(_, opts)
    --         require("codeshot").setup(opts)
    --     end,
    -- },
}
