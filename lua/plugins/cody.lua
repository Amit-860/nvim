return {}
--[[ local function cody_ask()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
    local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]

    if line1 and line2 then
        vim.ui.input({
            prompt = "Ask : ",
        }, function(input)
            if not input then
                return
            end
            vim.cmd(":" .. line1 .. "," .. line2 .. "CodyAsk " .. input)
        end)
    else
        return
    end
end

if not vim.g.vscode then
    return {
        {
            "sourcegraph/sg.nvim",
            event = "LspAttach",
            dependencies = { "nvim-lua/plenary.nvim" },
            cmd = { "CodyAsk", "SourcegraphLogin ", "CodyToggle", "CodyChat", "CodyTask", "CodyRestart" },
            keys = {
                vim.keymap.set({ "n", "v" }, "<F13>aa", function()
                    cody_ask()
                end, { noremap = true, silent = true, desc = "Cody Ask" }),
                vim.keymap.set(
                    { "n" },
                    "<F13>ac",
                    ":CodyChat<cr>",
                    { noremap = true, silent = true, desc = "Cody Chat" }
                ),
                vim.keymap.set(
                    { "n" },
                    "<F13>at",
                    ":CodyTask<cr>",
                    { noremap = true, silent = true, desc = "Cody Task" }
                ),
                vim.keymap.set(
                    { "n" },
                    "<F13>f",
                    "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>",
                    { noremap = true, silent = true, desc = "Cody Find" }
                ),
            },
            config = function()
                require("sg").setup({})
            end,
        },
    }
else
    return {}
end ]]
