-- disabling some featrues for big files
-- faster
return {
    "pteroctopus/faster.nvim",
    event = "VeryLazy",
    init = function()
        vim.api.nvim_create_autocmd("BufReadPost", {
            group = vim.api.nvim_create_augroup("Faster_ag", { clear = true }),
            pattern = "*",
            callback = function(event)
                local max_filesize = 1020 * 1024 * 2 -- 2MB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(event.buf))
                if ok and stats and stats.size > max_filesize then
                    vim.cmd("FasterDisableAllFeatures")

                    local nonels_status, nonels = pcall(require, "null-ls")
                    if nonels_status then
                        nonels.disable({ "ts_node_action", "gitsigns", "dictionary" })
                    end
                end
            end,
        })
    end,
    opts = {
        -- Behaviour table contains configuration for behaviours faster.nvim uses
        behaviours = {
            -- Bigfile configuration controls disabling and enabling of features when
            -- big file is opened
            bigfile = {
                -- Behaviour can be turned on or off. To turn on set to true, otherwise
                -- set to false
                on = true,
                -- Table which contains names of features that will be disabled when
                -- bigfile is opened. Feature names can be seen in features table below.
                -- features_disabled can also be set to "all" and then all features that
                -- are on (on=true) are going to be disabled for this behaviour
                features_disabled = {
                    "illuminate",
                    "matchparen",
                    "lsp",
                    "nvim-lspconfig",
                    "mason-lspconfig",
                    "treesitter",
                    "indent_blankline",
                    "vimopts",
                    "syntax",
                    "filetype",
                    "luminate",
                    "outline",
                    "vim-matchup",
                    "hlchunk",
                    "neoscroll",
                },
                -- Files larger than `filesize` are considered big files. Value is in MB.
                filesize = 2,
                -- Autocmd pattern that controls on which files behaviour will be applied.
                -- `*` means any file.
                pattern = "*",
                -- Optional extra patterns and sizes for which bigfile behaviour will apply.
                -- Note! that when multiple patterns (including the main one) and filesizes
                -- are defined: bigfile behaviour will be applied for minimum filesize of
                -- those defined in all applicable patterns for that file.
                -- extra_pattern example in multi line comment is bellow:
                --[[
      extra_patterns = {
        -- If this is used than bigfile behaviour for *.md files will be
        -- triggered for filesize of 1.1MiB
        { filesize = 1.1, pattern = "*.md" },
        -- If this is used than bigfile behaviour for *.log file will be
        -- triggered for the value in `behaviours.bigfile.filesize`
        { pattern  = "*.log" },
        -- Next line is invalid without the pattern and will be ignored
        { filesize = 3 },
      },
      ]]
                -- By default `extra_patterns` is an empty table: {}.
                extra_patterns = {},
            },
            -- Fast macro configuration controls disabling and enabling features when
            -- macro is executed
            fastmacro = {
                -- Behaviour can be turned on or off. To turn on set to true, otherwise
                -- set to false
                on = true,
                -- Table which contains names of features that will be disabled when
                -- macro is executed. Feature names can be seen in features table below.
                -- features_disabled can also be set to "all" and then all features that
                -- are on (on=true) are going to be disabled for this behaviour.
                -- Specificaly: lualine plugin is disabled when macros are executed because
                -- if a recursive macro opens a buffer on every iteration this error will
                -- happen after 300-400 hundred iterations:
                -- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
                features_disabled = { "lualine" },
            },
        },
        -- Feature table contains configuration for features faster.nvim will disable
        -- and enable according to rules defined in behaviours.
        -- Defined feature will be used by faster.nvim only if it is on (`on=true`).
        -- Defer will be used if some features need to be disabled after others.
        -- defer=false features will be disabled first and defer=true features last.
        features = {
            -- Neovim filetype plugin
            -- https://neovim.io/doc/user/filetype.html
            filetype = {
                on = false,
                defer = true,
            },
            -- Illuminate plugin
            -- https://github.com/RRethy/vim-illuminate
            illuminate = {
                on = true,
                defer = false,
            },
            -- Indent Blankline
            -- https://github.com/lukas-reineke/indent-blankline.nvim
            indent_blankline = {
                on = true,
                defer = false,
            },
            -- Neovim LSP
            -- https://neovim.io/doc/user/lsp.html
            lsp = {
                on = true,
                defer = false,
            },
            -- Lualine
            -- https://github.com/nvim-lualine/lualine.nvim
            lualine = {
                on = true,
                defer = false,
            },
            -- Neovim Pi_paren plugin
            -- https://neovim.io/doc/user/pi_paren.html
            matchparen = {
                on = true,
                defer = false,
            },
            -- Neovim syntax
            -- https://neovim.io/doc/user/syntax.html
            syntax = {
                on = false,
                defer = true,
            },
            -- Neovim treesitter
            -- https://neovim.io/doc/user/treesitter.html
            treesitter = {
                on = true,
                defer = false,
            },
            ts_context = {
                on = true,
                defer = true,
                enable = function()
                    pcall(vim.cmd, "TSContextEnable")
                end,
                disable = function()
                    pcall(vim.cmd, "TSContextDisable")
                end,
                commands = function()
                    vim.api.nvim_create_user_command("FasterEnableTSContext", function()
                        pcall(vim.cmd, "TSContextEnable")
                        vim.notify("TSContext enabled", 1)
                    end, {})
                    vim.api.nvim_create_user_command("FasterDisableTSContext", function()
                        pcall(vim.cmd, "TSContextDisable")
                        vim.notify("TScontext disabled", 1)
                    end, {})
                end,
            },
            minimap = {
                on = true,
                defer = true,
                enable = function()
                    require("codewindow").open_minimap()
                end,
                disable = function()
                    require("codewindow").close_minimap()
                end,
                commands = function()
                    local codewindow = require("codewindow")
                    vim.api.nvim_create_user_command("FasterEnableMinimap", function()
                        codewindow.open_minimap()
                        vim.notify("codewindow enabled", 1)
                    end, {})
                    vim.api.nvim_create_user_command("FasterDisableTSContext", function()
                        codewindow.close_minimap()
                        vim.notify("codewindow disabled", 1)
                    end, {})
                end,
            },
            -- Neovim options that affect speed when big file is opened:
            -- swapfile, foldmethod, undolevels, undoreload, list
            vimopts = {
                on = true,
                defer = false,
            },
        },
    },
}
