return
{
    "stevearc/conform.nvim",
    event = { "BufNewFile", "BufReadPost" },
    config = function()
        local slow_format_filetypes = { "json", "xml", "toml", 'yml', 'html' }
        require("conform").setup({
            formatters_by_ft = {
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
                text = { "trim_whitespace", "trim_newlines" },
                markdown = { "trim_whitespace", "trim_newlines" },
                norg = { "trim_whitespace", "trim_newlines" },
                org = { "trim_whitespace", "trim_newlines" },
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
}
