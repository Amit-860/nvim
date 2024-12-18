return {
    "stevearc/conform.nvim",
    cond = not vim.g.vscode,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
        local slow_format_filetypes = { "json", "xml", "toml", "yml", "html" }
        local conform_opts = {
            format = {
                timeout_ms = 3000,
                async = false, -- not recommended to change
                quiet = false, -- not recommended to change
                lsp_format = "fallback", -- not recommended to change
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
                -- # Example of using dprint only when a dprint.json file is present
                -- dprint = {
                --   condition = function(ctx)
                --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                --   end,
                -- },
                --
                -- # Example of using shfmt with extra args
                -- shfmt = {
                --   prepend_args = { "-i", "2", "-ci" },
                -- },
                stylua = {
                    prepend_args = {
                        "--indent-type",
                        "Spaces",
                        "--line-endings",
                        "Windows",
                        -- '--quote-style',
                        -- 'AutoPreferSingle',
                    },
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                scss = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                yaml = { "prettier" },
                json = { "biome" },
                jsonc = { "biome" },
                javascript = { "biome" },
                javascriptreact = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                -- ["*"] = { "codespell" },
                -- ["_"] = { "trim_whitespace", "trim_newlines" },
                text = { "trim_newlines" },
                markdown = { "trim_newlines" },
                norg = { "trim_newlines" },
                org = { "trim_newlines" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                if slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                end
                local function on_format(err)
                    if err and err:match("timeout$") then
                        slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                end
                return { timeout_ms = 3000, lsp_fallback = true }, on_format
            end,
            format_after_save = function(bufnr)
                if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                end
                return { lsp_format = "fallback" }
            end,
        }
        return conform_opts
    end,
    keys = {
        vim.keymap.set({ "n" }, "<F13>ce", "<cmd>FormatEnable<cr>", { desc = "Format Enable" }),
        vim.keymap.set({ "n" }, "<F13>cd", "<cmd>FormatDisable!<cr>", { desc = "Format Buff Disable" }),
        vim.keymap.set({ "n" }, "<F13>cD", "<cmd>FormatDisable<cr>", { desc = "Format Disable" }),
        vim.keymap.set({ "n", "v" }, "<leader>lf", function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end, { desc = "Format", noremap = true }),
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
        require("conform").setup(opts)
    end,
}
