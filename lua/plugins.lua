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
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = {
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
        }
    },

    -- LSP
    {
        "folke/neodev.nvim",
        cond = false,
        event = "VeryLazy"
    },
    {
        "folke/persistence.nvim",
        event = { "BufReadPre" },
        opts = {}
    },
    {
        "pmizio/typescript-tools.nvim",
        cond = false,
        ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
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
        'HiPhish/rainbow-delimiters.nvim',
        event = { "BufNewFile", "BufReadPost" },
        config = function()
            require('rainbow-delimiters.setup').setup {
                strategy = {
                    [""] = function(bufnr)
                        local line_count = vim.api.nvim_buf_line_count(bufnr)
                        if line_count > 1000 then
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
            { "<M-t>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,                                 desc = "Flash Treesitter" },
            { "S",     mode = { "n", "o", "x" }, function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash Treesitter" },
            { "<M-/>", mode = { "n" },           function() require("flash").toggle() end,                                     desc = "Toggle Flash Search" },
        },
    },
    {
        "chrisgrieser/nvim-spider",
        event = { "BufNewFile", "BufReadPost" },
        lazy = true,
        opts = {
            skipInsignificantPunctuation = true,
            consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
            subwordMovement = true,
        }
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
                timeout = vim.o.timeoutlen,
                mappings = {
                    i = { j = { k = "<esc>", j = false } },
                    c = { j = { k = "<esc>", j = false }, },
                    t = { j = { k = false, j = false }, },
                    v = { j = { k = false, j = false } },
                    s = { j = { k = "<esc>", j = false }, },
                },
            })
        end,
    },

    -- mini
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufNewFile", "BufReadPost" },
        config = function()
            local opts = {
                chunk = {
                    enable = true,
                    duration = 50,
                    delay = 80,
                    exclude_filetypes = { alpha = true, TelescopePrompt = true, Outline = true, ['neo-tree'] = true, ['neo-tree-popup'] = true, },
                },
                line_num = { enable = false },
                blank = { enable = false },
                indent = {
                    enable = true,
                    chars = { "", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", "│", },
                    exclude_filetypes = { alpha = true, TelescopePrompt = true, Outline = true, ['neo-tree'] = true, ['neo-tree-popup'] = true, },
                }
            }
            require("hlchunk").setup(opts)
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

    -- completion
    {
        "onsails/lspkind.nvim",
        event = "VeryLazy"
    },

    -- filtesystem
    {
        "nanotee/zoxide.vim",
        cmd = { "Z" }
    },

    -- git
    {
        "sindrets/diffview.nvim",
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' }
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

    -- scrollings
    {
        "karb94/neoscroll.nvim",
        cond = not vim.g.neovide,
        event = { "BufReadPost", "BufNewFile" },
        mappings = { -- Keys to be mapped to their corresponding default scrolling animation
            '<C-u>', '<C-d>',
            '<C-b>', '<C-f>',
            '<C-y>', '<C-e>',
            'zt', 'zz', 'zb',
        },
        opts = function()
            return {
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
            }
        end
    },

    -- marks/bookmarks
    {
        "cbochs/grapple.nvim",
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

    -- Find and Replace
    {
        'MagicDuck/grug-far.nvim',
        -- event = "VeryLazy",
        keys = {
            vim.keymap.set({ 'n' }, "<leader>or",
                "<cmd>lua require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } })<cr>",
                { noremap = true, silent = true, desc = 'Grug FAR .' }),
            vim.keymap.set({ 'n' }, "<leader>rR",
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
            vim.keymap.set('n', '<Leader>os', ":SSFocused<cr>",
                { desc = "Codeshot focused", noremap = true, silent = true })
        },
        config = function()
            require('codeshot').setup({
                use_current_theme = false,
                output = vim.fn.expand("$HOME") .. "/codeshot/CodeShot_${year}-${month}-${date}_${time}.png",
            })
        end
    },

    -- highlight yank, undo, redo
    {
        'mei28/luminate.nvim',
        event = { 'VeryLazy' },
        config = function()
            require 'luminate'.setup({
                -- if you want to customize, see Usage!
            })
        end
    },
    {
        'VidocqH/lsp-lens.nvim',
        event = "LspAttach",
        opts = {},
        config = function(_, opts)
            require 'lsp-lens'.setup({
                sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
                    definition = true,
                    references = true,
                    implements = true,
                    git_authors = false,
                },
            })
            vim.api.nvim_set_hl(0, "LspLens", {
                -- bg = "#002f44",
                fg = "#51a0cf",
                bold = true
            })
        end
    },

}
