M = {}
M.plugin_list = {
    -- theme
    {
        "EdenEast/nightfox.nvim",
        cond = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        config = function()
            local opts = {
                options = {
                    styles = { comments = "italic", keywords = "bold", types = "italic,bold", },
                    transparent = true,
                },
                palettes = { terafox = { bg0 = "#021e34", bg1 = "#111c29", bg2 = "#192837" }, },
                groups = { terafox = { CursorLine = { bg = "#263749" }, } }
            }
            if vim.g.neovide then
                opts.options.transparent = false
            end
            require('nightfox').setup(opts)
            vim.cmd("colorscheme terafox")
        end
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "folke/noice.nvim",
        -- cond = function()
        --     if vim.g.neovide then return true end
        --     return false
        -- end,
        event = "UIEnter",
        opts = {},
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require('pluginSetups.noiceConfig')
        end,
    },

    -- faster
    {
        'pteroctopus/faster.nvim',
        event = "VeryLazy",
        opts = {}
    },

    -- notifier
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- keymappings
    {
        "folke/which-key.nvim",
        cmd = "WhichKey",
        event = "VeryLazy",
        config = function()
            require('pluginSetups.whichKeyConfig')
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('pluginSetups.autoPairConfig')
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "dS",
                    change = "cS",
                    change_line = "cS",
                },
            })
        end
    },

    -- LSP
    {
        "folke/neodev.nvim",
        event = "VeryLazy"
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        opts = {
            -- add any custom options here
        }
    },
    {
        "williamboman/mason.nvim",
        cmd = { "Mason" },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy"
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        opts = {
            setup = {
                codelens = { enabled = true },
                document_highlight = { enabled = true },
                jdtls = function() return true end,
            }
        },
        config = function()
            require('pluginSetups.lspConfig')
        end
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },
    {
        "stevearc/conform.nvim",
        event = "LspAttach",
        config = function()
            local slow_format_filetypes = {}
            require("conform").setup({
                formatters_by_ft = {
                    python = { "isort", "black", },
                    scss = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    yaml = { "prettier" },
                    json = { "prettier" },
                    toml = { "prettier" },
                    javascript = { "biome" },
                    javascriptreact = { "biome" },
                    typescript = { "biome" },
                    typescriptreact = { "biome" },
                    -- ["*"] = { "codespell" },
                    ["_"] = { "trim_whitespace", "trim_newlines" },
                },
                format_on_save = function(bufnr)
                    if slow_format_filetypes[vim.bo[bufnr].filetype] then
                        return
                    end
                    local function on_format(err)
                        if err and err:match("timeout$") then
                            slow_format_filetypes[vim.bo[bufnr].filetype] = true
                        end
                    end
                    return { timeout_ms = 1000, lsp_fallback = true }, on_format
                end,
                format_after_save = function(bufnr)
                    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                        return
                    end
                    return { lsp_fallback = true }
                end,
            })
        end,
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
        keys = {
            vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Outline<CR>",
                { desc = "Document Symbols", noremap = true, })
        },
        opts = {
            -- Your setup opts here
        },
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui" },
        event = "LspAttach",
        config = function() require('pluginSetups.dapConfig') end
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = { "nvim-neotest/nvim-nio", { "theHamsta/nvim-dap-virtual-text", opts = {} } },
        config = function() require('pluginSetups.dapUIConfig') end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = 'python',
        config = function()
            require("dap-python").setup("~/scoop/apps/python/current/python")
        end,
    },

    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope-ui-select.nvim",
            'nvim-telescope/telescope-fzy-native.nvim'
        },
        config = function()
            require('pluginSetups.telescopeConfig')
        end
    },
    {
        'nvim-telescope/telescope-project.nvim',
        event = "UIEnter"
    },
    {
        "debugloop/telescope-undo.nvim",
        cmd = { "Telescope undo" }
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        cmd = {
            "TSInstall",
            "TSUninstall",
            "TSUpdate",
            "TSUpdateSync",
            "TSInstallInfo",
            "TSInstallSync",
            "TSInstallFromGrammar",
        },
        event = "UIEnter",
        config = function()
            local ts_opts = require('pluginSetups.treeSitterConfig')
            require 'nvim-treesitter.configs'.setup(ts_opts)
        end
    },
    {
        "romgrk/nvim-treesitter-context",
        event = "BufReadPost",
        config = function()
            require("treesitter-context").setup({
                enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 4,   -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { default = { "class", "function", "method" } },
            })
        end,
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "BufReadPost",
        config = function()
            require("various-textobjs").setup({ useDefaultKeymaps = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufReadPost"
    },
    {
        "ckolkey/ts-node-action",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter" },
        lazy = true,
        opts = {},
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = "BufReadPost",
        config = function()
            require('rainbow-delimiters.setup').setup {
                strategy = {
                    [""] = function(bufnr)
                        local line_count = vim.api.nvim_buf_line_count(bufnr)
                        if vim.b.large_buf then
                            return nil
                        end
                        return require('rainbow-delimiters').strategy['global']
                    end
                },
                query = {},
                highlight = {},
            }
        end
    },
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },


    -- motion
    { "tpope/vim-repeat" },
    {
        "folke/flash.nvim",
        event = "BufReadPost",
        cond = not vim.g.vscode,
        opts = {
            modes = { char = { jump_labels = true }, search = { enabled = false } },
            exclude = {
                "notify", "cmp_menu", "noice", "flash_prompt", "neogit", "NeogitStatus",
                function(win) return not vim.api.nvim_win_get_config(win).focusable end,
            },
        },
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump({}) end,                                     desc = "Flash" },
            { "<M-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,                                 desc = "Flash Treesitter" },
            { "S",     mode = { "n", "o", "x" }, function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash Treesitter" },
            { "<M-/>", mode = { "n" },           function() require("flash").toggle() end,                                     desc = "Toggle Flash Search" },
        },
    },
    {
        "chrisgrieser/nvim-spider",
        event = "User FileOpened",
        lazy = true,
        opts = { skipInsignificantPunctuation = true }
    },
    {
        "monaqa/dial.nvim",
        event = "BufReadPost",
        keys = {
            { "<C-a>", "<Plug>(dial-increment)", mode = { "n", "v" }, remap = true },
            { "<C-x>", "<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal,                                                                    -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.integer.alias.hex,                                                                        -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                    augend.constant.alias.bool,                                                                      -- boolean value (true <-> false)
                    augend.date.alias["%Y/%m/%d"],                                                                   -- date (2022/02/18, etc.)
                    augend.date.alias["%m/%d/%Y"],                                                                   -- date (02/19/2022)
                    augend.date.new { pattern = "%m-%d-%Y", default_kind = "day", only_valid = true, word = false }, -- date (02-19-2022)
                    augend.date.new { pattern = "%Y-%m-%d", default_kind = "day", only_valid = true, word = false }, -- date (02-19-2022)
                    augend.date.new({ pattern = "%m.%d.%Y", default_kind = "day", only_valid = true, word = false, }),
                    augend.constant.new { elements = { "&&", "||" }, word = false, cyclic = true, },
                    augend.constant.new { elements = { '>', '<' }, word = false, cyclic = true, },
                    augend.constant.new { elements = { '==', '!=', }, word = false, cyclic = true, },
                    augend.constant.new { elements = { '===', '!==' }, word = false, cyclic = true, },
                    augend.constant.new { elements = { 'True', 'False' }, word = false, cyclic = true, },
                    augend.constant.new { elements = { 'and', 'or', 'not' }, word = false, cyclic = true, },
                    augend.constant.new { elements = { '+', '-' }, word = false, cyclic = true, },
                    augend.constant.new { elements = { '*', '/', '//', '%' }, word = false, cyclic = true, },
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
                mapping = { "jk" }, -- a table with mappings to use
                keys = "<Esc>",     -- keys used for escaping, if it is a function will use the result everytime
            })
        end,
    },

    -- mini
    { 'echasnovski/mini.ai',          event = { 'BufReadPost' }, version = '*', opts = {} },
    { 'echasnovski/mini.cursorword',  event = { 'BufReadPost' }, version = '*', opts = {} },
    { 'echasnovski/mini.files',       event = { 'UIEnter' },     version = '*', opts = {} },
    { 'echasnovski/mini.indentscope', event = { 'BufReadPost' }, version = '*', opts = {} },
    {
        'echasnovski/mini.hipatterns',
        event = { 'BufReadPost' },
        version = '*',
        config = function() require('pluginSetups.miniHipatternConfig') end
    },
    {
        'echasnovski/mini.statusline',
        event = { 'UIEnter' },
        version = '*',
        config = function() require('pluginSetups.miniStatuslineConfig') end
    },
    {
        'echasnovski/mini.tabline',
        event = { 'UIEnter' },
        version = '*',
        config = function() require('pluginSetups.miniTablineConfig') end
    },
    {
        'echasnovski/mini.comment',
        event = { 'UIEnter' },
        version = '*',
        config = function() require('pluginSetups.miniCommentConfig') end
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
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip'
        },
        config = function()
            require('pluginSetups.cmpConfig')
        end
    },
    { 'hrsh7th/cmp-nvim-lsp', lazy = true, },
    { 'hrsh7th/cmp-buffer',   lazy = true },
    { 'hrsh7th/cmp-path',     lazy = true },
    { 'hrsh7th/cmp-cmdline',  lazy = true },
    {
        "L3MON4D3/LuaSnip",
        version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = "make install_jsregexp",
        event = "BufReadPost",
        config = function()
            require("luasnip").setup()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    { "onsails/lspkind.nvim" },

    -- filtesystem
    {
        "nanotee/zoxide.vim",
        cmd = { "Z" }
    },

    -- git
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        cmd = "Gitsigns",
        config = function()
            require("pluginSetups.gitSignConfig")
        end
    },
    {
        "sindrets/diffview.nvim",
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' }
    },

    -- file browsers
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = { "Neotree" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require('pluginSetups.neoTreeConfig')
        end
    },
    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
        keys = {
            {
                "<leader>fB",
                function() require("yazi").yazi() end,
                desc = "File Broser",
            },
            {
                "<leader>fb",
                function() require("yazi").yazi(nil, vim.fn.getcwd()) end,
                desc = "File Broser .",
            },
        },
        config = function()
            local yazi_opts = {
                open_for_directories = true,
                floating_window_scaling_factor = 0.85,
                yazi_floating_window_border = 'rounded',
            }
            if vim.g.neovide then
                yazi_opts.yazi_floating_window_winblend = 50
            end
            require('yazi').setup(yazi_opts)
        end
    },
    {
        "NeogitOrg/neogit",
        cmd = { "Neogit" },
        opts = {
            graph_style = "unicode",
            telescope_sorter = function() return require("telescope").extensions.fzy_native.native_fzy_sorter() end,
            integrations = { telescope = true, diffview = true, },
            disable_line_numbers = true,
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",
        },
        config = true
    },
    {
        "luukvbaal/statuscol.nvim",
        event = "BufReadPre",
        dependencies = {
            "lewis6991/gitsigns.nvim",
        },
        config = function()
            require("pluginSetups.statusColConfig")
        end
    },

    -- scrollings
    {
        "karb94/neoscroll.nvim",
        cond = not vim.g.neovide,
        event = "VeryLazy",
        mappings = { -- Keys to be mapped to their corresponding default scrolling animation
            '<C-u>', '<C-d>',
            '<C-b>', '<C-f>',
            '<C-y>', '<C-e>',
            'zt', 'zz', 'zb',
        },
        config = function()
            require('neoscroll').setup({
                mappings = { -- Keys to be mapped to their corresponding default scrolling animation
                    '<C-u>', '<C-d>',
                    '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>',
                    'zt', 'zz', 'zb',
                },
                hide_cursor = true,          -- Hide cursor while scrolling
                stop_eof = true,             -- Stop at <EOF> when scrolling downwards
                respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing = 'linear',           -- Default easing function
                pre_hook = nil,              -- Function to run before the scrolling animation starts
                post_hook = nil,             -- Function to run after the scrolling animation ends
                performance_mode = false,    -- Disable "Performance Mode" on all buffers.
            })
        end
    },

    -- transparency

    -- clipboard
    {
        "gbprod/yanky.nvim",
        recommended = true,
        event = "BufReadPost",
        opts = {
            highlight = { timer = 500 },
        },
    },

    -- marks/bookmarks
    -- {
    --     "otavioschwanck/arrow.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         show_icons = true,
    --         leader_key = 'M',        -- Recommended to be a single key
    --         buffer_leader_key = 'm', -- Per Buffer Mappings
    --         window = {               -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
    --             border = "rounded",
    --         },
    --         global_bookmarks = false
    --     }
    -- },
    {
        "cbochs/grapple.nvim",
        event = "UIEnter",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" }
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
            { "ma",         function() require('grapple').tag({ scope = "git_branch" }) end,         desc = "Toggle tag" },
            { "<leader>fm", "<cmd>Telescope grapple tags scope=git_branch theme=get_ivy<cr>",        desc = "Telescope marks" },
            { "<M-m>",      function() require('grapple').toggle_tags({ scope = "git_branch" }) end, desc = "Grapple mark" },
            { "mm",         function() require('grapple').toggle_tags({ scope = "git_branch" }) end, desc = "Grapple mark" },
        },
    },

    -- terminal
    {
        'akinsho/toggleterm.nvim',
        event = "VeryLazy",
        version = "*",
        config = function()
            require('pluginSetups.toggleTermConfig')
        end
    },

    -- Find and Replace
    {
        'MagicDuck/grug-far.nvim',
        -- event = "VeryLazy",
        keys = {
            vim.keymap.set({ 'n' }, "<leader>xr",
                "<cmd>lua require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } })<cr>",
                { noremap = true, silent = true, desc = 'Grug FAR .' }),
            vim.keymap.set({ 'n' }, "<leader>xR",
                "lua require('grug-far').grug_far()<cr>",
                { noremap = true, silent = true, desc = 'Grug FAR' }),
        },
        config = function()
            require('grug-far').setup({});
        end
    },

    -- Code-Snapshot
    {
        "SergioRibera/codeshot.nvim",
        cmd = { "SSSelected", "SSFocused" },
        keys = {
            vim.keymap.set('v', '<Leader>s', "<nop>", { desc = "Codeshot", noremap = true, silent = true }),
            vim.keymap.set('v', '<Leader>ss', ":SSSelected<cr>", { desc = "Selected", noremap = true, silent = true }),
            vim.keymap.set('n', '<Leader>xs', ":SSFocused<cr>",
                { desc = "Codeshot focused", noremap = true, silent = true })
        },
        config = function()
            require('codeshot').setup({
                use_current_theme = false,
                output = vim.fn.expand("$HOME") .. "/codeshot/CodeShot_${year}-${month}-${date}_${time}.png",
            })
        end
    },

    -- notes
    {
        "nvim-neorg/neorg",
        ft = "norg",
        cmd = { "Neorg" },
        dependencies = {
            {
                -- Install lua from here first before install luarocksj.nvim and neorg
                -- https://github.com/rjpcomputing/luaforwindows
                "vhyrro/luarocks.nvim",
                priority = 1000,
                config = true,
            },
            "nvim-neorg/lua-utils.nvim"
        },
        version = "*",
        config = function()
            require('pluginSetups.neorgConfig')
        end
    },

    -- DataBase
    -- {
    --     "kndndrj/nvim-dbee",
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "MattiasMTS/cmp-dbee",
    --     },
    --     build = function()
    --         require("dbee").install()
    --     end,
    --     config = function()
    --         require("dbee").setup({
    --             sources = {
    --                 require("dbee.sources").MemorySource:new({
    --                     {
    --                         id = "large",
    --                         name = "large",
    --                         type = "jq",
    --                         url = vim.fn.expand("$HOME/Downloads/large-file.json")
    --                     }
    --                 }),
    --                 require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
    --                 require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
    --             }
    --         })
    --     end,
    -- },
    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DB", "DBUI", 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
        dependencies = { "kristijanhusak/vim-dadbod-completion", "tpope/vim-dadbod", },
        init = function()
            vim.g.dbs = { { name = "large", url = "jq:" .. vim.fn.expand("$HOME/Downloads/large-file.json") } }
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_use_nvim_notify = 1
        end
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('pluginSetups.dashboardConfig')
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    }

}

M.opts = { checker = { frequency = 604800, } }

return M
