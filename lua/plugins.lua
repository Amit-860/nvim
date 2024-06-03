M = {}
M.plugin_list = {
    -- theme
    {
        "xiyaowong/transparent.nvim",
        cond = not vim.g.neovide,
        config = function()
            require("transparent").setup({
                groups = { "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
                    "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
                    "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText", "SignColumn",
                    "CursorLineNr", "EndOfBuffer", },
                extra_groups = { "FloatBorder", --[["NvimTreeWinSeparator",]] "NvimTreeNormal",
                    "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "TroubleNormal", "TelescopeNormal",
                    "TelescopeBorder", "WhichKeyFloat", },
            })
            vim.g.transparent_enabled = true
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        cond = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        -- config = function()
        --     if not vim.g.neovide then
        --         require('nightfox').setup({
        --             options = {
        --                 transparent = true,     -- Disable setting background
        --                 terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        --                 dim_inactive = false,   -- Non focused panes set to alternative background
        --                 module_default = true
        --             }
        --         })
        --     end
        -- end
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    -- faster
    {
        'pteroctopus/faster.nvim',
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
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy", -- keep for lazy loading
        opts = {},
        init = function()
            vim.g.loaded_matchparen = 1
        end,
    },

    -- LSP
    {
        "folke/neodev.nvim",
        lazy = true,
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
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true },
            codelens = { enabled = true },
            document_highlight = { enabled = true }
        },
        config = function()
            require('pluginSetups.lspConfig')
        end
    },
    {
        "nvim-telescope/telescope.nvim",
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

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        event = "LspAttach",
        dependencies = { "rcarriga/nvim-dap-ui", },
        config = function()
            require('pluginSetups.dapConfig')
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = 'python',
        event = "LspAttach",
        config = function()
            require("dap-python").setup("~/scoop/apps/python/current/python")
        end,
    },

    -- Debugger user interface
    {
        "rcarriga/nvim-dap-ui",
        evert = "VeryLazy",
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
        event = "User FileOpened",
        config = function()
            local ts_opts = require('pluginSetups.treeSitterConfig')
            require 'nvim-treesitter.configs'.setup(ts_opts)
        end
    },
    {
        "romgrk/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { default = { "class", "function", "method" } },
            })
        end,
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        config = function()
            require("various-textobjs").setup({ useDefaultKeymaps = true })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "ckolkey/ts-node-action",
        dependencies = { "nvim-treesitter" },
        Lazy = 'VeryLazy',
        opts = {},
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        event = "BufReadPre",
        config = function()
            require('rainbow-delimiters.setup').setup {
                strategy = {},
                query = {},
                highlight = {},
            }
        end
    },

    -- motion
    -- { "wellle/targets.vim" },
    {
        "AgusDOLARD/backout.nvim",
        event = "User FileOpened",
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
        event = "User FileOpened",
        cond = not vim.g.vscode,
        opts = {
            modes = {
                char = { jump_labels = true },
                search = { enabled = false }
            },

        },
        keys = {
            {
                "s", mode = { "n", "x", "o" }, function() require("flash").jump({}) end, desc = "Flash"
            },
            {
                "<M-s>",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter"
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end,
                desc = "Flash Treesitter"
            },
            {
                "<M-/>", mode = { "n" }, function() require("flash").toggle() end, desc = "Toggle Flash Search"
            },
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
            lang = "python3"
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
        event = "LspAttach"
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        event = "UIEnter"
    },
    {
        "debugloop/telescope-undo.nvim",
        event = "BufReadPre"
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
    -- {
    --     "kdheepak/lazygit.nvim",
    --     cmd = {
    --         "LazyGit",
    --         "LazyGitConfig",
    --         "LazyGitCurrentFile",
    --         "LazyGitFilter",
    --         "LazyGitFilterCurrentFile",
    --     },
    --     -- optional for floating window border decoration
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    --     config = function()
    --      require("telescope").load_extension("lazygit")
    --     end
    -- },
    {
        "NeogitOrg/neogit",
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
}

M.opts = { checker = { frequency = 604800, } }

return M
