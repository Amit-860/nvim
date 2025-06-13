return {
    {
        "mfussenegger/nvim-lint",
        cond = not vim.g.vscode,
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = { "Mason" },
            },
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- Event to trigger linters
            events = { "BufWritePost", "BufReadPost" },
            linters_by_ft = {
                python = {
                    -- "pylint",
                    "codespell",
                },
                lua = { "codespell" },
                java = { "codespell" },
                json = { "codespell" },
                toml = { "codespell" },
                go = { "codespell" },
                -- go = { "codespell", "golangcilint" },
                --------------------------------------------------------------------
                -- NOTE : vale setup
                -- create ~/.vale.ini file
                -- Put this in .vale.ini file
                -- -----------------------------------
                -- This is my .vale.ini:
                -- StylesPath = .
                -- MinAlertLevel = suggestion
                -- Packages = RedHat, alex
                -- [*]
                -- BasedOnStyles = Vale, RedHat, alex
                -- -----------------------------------
                -- Run .\AppData\Roaming\nvim-data\mason\packages\vale\vale.exe sync
                -- -----------------------------------------------------------------
                text = { "vale" },
                -- markdown = { "vale" },
                -- gitcommit = { "vale" },
                -- norg = { "vale" },
                NeogitCommitMessage = { "vale" },
                -- Use the "*" filetype to run linters on all filetypes.
                -- ['*'] = { 'global linter' },
                -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                -- ['_'] = { 'fallback linter' },
                -- ["*"] = { "typos" },
            },
            -- LazyVim extension to easily override linter options
            -- or add custom linters.
            ---@type table<string,table>
            linters = {
                -- -- Example of using selene only when a selene.toml file is present
                -- selene = {
                --   -- `condition` is another LazyVim extension that allows you to
                --   -- dynamically enable/disable linters based on the context.
                --   condition = function(ctx)
                --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
                --   end,
                -- },
                -- vale = {
                --     condition = function()
                --         return vim.bo.modifiable
                --     end,
                -- },
            },
        },
        config = function(_, opts)
            local M = {}

            local lint = require("lint")
            for name, linter_opts in pairs(opts.linters) do
                if type(linter_opts) == "table" and type(lint.linters[name]) == "table" then
                    lint.linters[name] = vim.tbl_deep_extend("force", linter_opts, lint.linters[name])
                    if type(linter_opts.prepend_args) == "table" then
                        lint.linters[name].args = lint.linters[name].args or {}
                        vim.list_extend(lint.linters[name].args, linter_opts.prepend_args)
                    end
                else
                    lint.linters[name] = linter_opts
                end
            end
            lint.linters_by_ft = opts.linters_by_ft

            function M.debounce(ms, fn)
                local timer = vim.uv.new_timer()
                return function(...)
                    local argv = { ... }
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            function M.lint()
                -- Use nvim-lint's logic first:
                -- * checks if linters exist for the full filetype first
                -- * otherwise will split filetype by "." and add all those linters
                -- * this differs from conform.nvim which only uses the first filetype that has a formatter
                local names = lint._resolve_linter_by_ft(vim.bo.filetype)

                -- Create a copy of the names table to avoid modifying the original.
                names = vim.list_extend({}, names)

                -- Add fallback linters.
                if #names == 0 then
                    vim.list_extend(names, lint.linters_by_ft["_"] or {})
                end

                -- Add global linters.
                vim.list_extend(names, lint.linters_by_ft["*"] or {})

                -- Filter out linters that don't exist or don't match the condition.
                local bigFileCond = function()
                    local max_filesize = vim.g.max_filesize
                    local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(0))
                    if (ok and stats and stats.size > max_filesize) or vim.g.vscode then
                        return false
                    end
                    return true
                end
                local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
                names = vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    if not linter then
                        vim.notify("Linter not found: " .. name, 2)
                    end
                    return linter
                        and bigFileCond()
                        and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
                end, names)

                -- Run linters.
                if #names > 0 then
                    lint.try_lint(names)
                end
            end

            vim.api.nvim_create_autocmd(opts.events, {
                group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                callback = M.debounce(100, M.lint),
            })
        end,
    },
}
