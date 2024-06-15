M = {}
M.plugin_list = {
    -- theme
    {
        "EdenEast/nightfox.nvim",
        cond = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                    transparent = true,
                }
            })
            vim.cmd("colorscheme nightfox")
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
        event = "VeryLazy",
        opts = {},
        dependencies = { "MunifTanjim/nui.nvim" },
        config = function()
            require("noice").setup({
                lsp = {
                    progress = {
                        enabled = false,
                        format = "lsp_progress",
                        format_done = "lsp_progress_done",
                        throttle = 1000 / 30, -- frequency to update lsp progress message
                        view = "mini",
                    },
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    signature = { enabled = false, },
                    hover = { enabled = false, },
                },
                routes = {
                    enabled = true,
                    { view = "cmdline", filter = { event = "msg_showmode" } }
                },
                presets = {
                    bottom_search = false,        -- use a classic bottom cmdline for search
                    command_palette = false,      -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end,
    },

    -- faster
    {
        'pteroctopus/faster.nvim',
        event = "UIEnter",
        opts = {}
    },

    -- notifier
    {
        "j-hui/fidget.nvim",
        event = "UIEnter",
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
        lazy = true,
        cmd = { "Mason" },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true
    },
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        ft = { "lua", "python", "json" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
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
        event = "VeryLazy"
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        config = function()
            require('pluginSetups.telescopeConfig')
        end
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
        event = "VeryLazy",
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
        event = "User FileOpened",
        cmd = { "DapContinue" },
        dependencies = { "rcarriga/nvim-dap-ui", },
        config = function()
            require('pluginSetups.dapConfig')
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = 'python',
        config = function()
            require("dap-python").setup("~/scoop/apps/python/current/python")
        end,
    },

    -- Debugger user interface
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require('pluginSetups.dapUIConfig')
        end
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        event = "LspAttach",
        opts = {}
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
        event = "BufReadPre",
        config = function()
            local ts_opts = require('pluginSetups.treeSitterConfig')
            require 'nvim-treesitter.configs'.setup(ts_opts)
        end
    },
    {
        "romgrk/nvim-treesitter-context",
        event = "BufReadPre",
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
        event = "BufReadPre",
        config = function()
            require("various-textobjs").setup({ useDefaultKeymaps = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufReadPre"
    },
    {
        "ckolkey/ts-node-action",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter" },
        lazy = true,
        opts = {},
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = "BufReadPre",
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
        event = "BufReadPre",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },


    -- motion
    {
        "AgusDOLARD/backout.nvim",
        event = "BufReadPre",
        opts = {
            chars = "(){}[]`'\"<>" -- default chars
        },
        keys = {
            -- Define your keybinds
            { "<M-h>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "n" } },
            { "<M-l>", "<cmd>lua require('backout').out()<cr>",  mode = { "i", "n" } },
        },
    },
    { "tpope/vim-repeat" },
    {
        "drybalka/tree-climber.nvim",
        event = "BufReadPre",
        config = function()
            vim.keymap.set({ "n", "v", "o" }, "r",
                require("tree-climber").goto_next,
                { noremap = true, silent = true, desc = "Next Block" }
            )
            vim.keymap.set({ "n", "v", "o" }, "R",
                require("tree-climber").goto_prev,
                { noremap = true, silent = true, desc = "Prev Block" }
            )
            vim.keymap.set({ "n", "v", "o" }, "]r",
                require("tree-climber").goto_child,
                { noremap = true, silent = true, desc = "Goto Child Block" }
            )
            vim.keymap.set({ "n", "v", "o" }, "[R",
                require("tree-climber").goto_parent,
                { noremap = true, silent = true, desc = "Goto Parent Block" }
            )
        end,
    },
    {
        "folke/flash.nvim",
        event = "BufReadPre",
        cond = not vim.g.vscode,
        opts = {
            modes = {
                char = { jump_labels = true },
                search = { enabled = false }
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
        event = "BufRead",
        keys = {
            { "<C-a>",  "<Plug>(dial-increment)",  mode = { "n", "v" }, remap = true },
            { "<C-x>",  "<Plug>(dial-decrement)",  mode = { "n", "v" }, remap = true },
            { "g<C-a>", "g<Plug>(dial-increment)", mode = { "n", "v" }, remap = true },
            { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true },
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
        event = "UIEnter",
        cond = not vim.g.vscode,
        config = function()
            require("better_escape").setup({
                mapping = { "jk" },        -- a table with mappings to use
                timeout = 500,             -- the time in which the keys must be hit in ms. Use option timeoutlen by default
                clear_empty_lines = false, -- clear line after escaping if there is only whitespace
                keys = "<Esc>",            -- keys used for escaping, if it is a function will use the result everytime
            })
        end,
    },

    -- mini
    {
        'echasnovski/mini.nvim',
        cond = not vim.g.vscode,
        config = function()
            require('pluginSetups.miniConfig')
        end
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
    {
        "CRAG666/code_runner.nvim",
        cmd = { 'RunFile', 'RunCode', 'RunProject', 'RunClose' },
        config = true,
    },

    -- completion
    {
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            'hrsh7th/cmp-cmdline',
            'petertriho/cmp-git'
        },
        config = function()
            require('pluginSetups.cmpConfig')
        end
    },
    { 'petertriho/cmp-git',                   lazy = true },
    { 'hrsh7th/cmp-nvim-lsp',                 lazy = true, },
    { 'hrsh7th/cmp-buffer',                   lazy = true },
    { 'hrsh7th/cmp-path',                     lazy = true },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = true },
    { "hrsh7th/cmp-nvim-lsp-signature-help",  lazy = true },
    { 'hrsh7th/cmp-cmdline',                  lazy = true },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        build = "make install_jsregexp",
        event = "LspAttach",
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

    -- telescope
    {
        "gbrlsnchs/telescope-lsp-handlers.nvim",
        event = "VeryLazy"
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        event = "VeryLazy"
    },
    {
        "debugloop/telescope-undo.nvim",
        cmd = { "Telescope undo" }
    },
    {
        'nvim-telescope/telescope-project.nvim',
        event = "UIEnter"
    },

    -- git
    {
        "lewis6991/gitsigns.nvim",
        event = "User FileOpened",
        cmd = "Gitsigns",
        config = function()
            require("pluginSetups.gitSignConfig")
        end
    },
    {
        "sindrets/diffview.nvim",
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'FiffviewFileHistory' }
    },

    -- file browsers
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
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
        },
        config = true
    },
    {
        "luukvbaal/statuscol.nvim",
        event = "UIEnter",
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
        event = "VeryLazy",
        opts = {
            highlight = { timer = 300 },
        },
    },

    -- marks/bookmarks
    {
        "otavioschwanck/arrow.nvim",
        opts = {
            show_icons = true,
            leader_key = 'M',        -- Recommended to be a single key
            buffer_leader_key = 'm', -- Per Buffer Mappings
        }
    }
}

M.opts = { checker = { frequency = 604800, } }

return M
