local utils = require("utils")
local telescope_builtins = require("telescope.builtin")
local telescope_extensinos = require("telescope").extensions

-- explorer
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true, desc = "NvimTree" })

-- list buffers
vim.keymap.set(
    "n",
    "<leader><leader>",
    "<cmd>Telescope buffers theme=dropdown<cr>",
    { noremap = true, silent = true, desc = "which_key_ignore" }
)

-- find
vim.keymap.set("n", "<leader>ff", function()
    utils.smart_find_file({
        initial_mode = "insert",
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.5 },
    })
end, { noremap = true, silent = true, desc = "Find Git Files" })
vim.keymap.set("n", "<c-f>", function()
    telescope_builtins.current_buffer_fuzzy_find({
        initial_mode = "insert",
        bufnr = 0,
        theme = "dropdown",
        layout_strategy = "vertical",
        layout_config = { preview_height = 0.6 },
    })
end, { noremap = true, silent = true, desc = "Find Git Files" })
vim.keymap.set(
    "n",
    "<leader>fF",
    function()
        telescope_builtins.find_files({
            initial_mode = "insert",
            layout_strategy = "horizontal",
            layout_config = { preview_width = 0.5 },
        })
    end,
    -- "<cmd>Telescope find_files initial_mode=insert layout_strategy=horizontal layout_config={preview_width=0.5}<cr>",
    { noremap = true, silent = true, desc = "All File" }
)
vim.keymap.set(
    "n",
    "<leader>fs",
    function()
        telescope_builtins.live_grep({
            initial_mode = "insert",
            layout_strategy = "horizontal",
            layout_config = { preview_width = 0.5 },
        })
    end,
    -- "<cmd>Telescope live_grep layout_strategy=horizontal layout_config={preview_width=0.5}<cr>",
    { noremap = true, silent = true, desc = "String" }
)
vim.keymap.set(
    "n",
    "<leader>fr",
    "<cmd>Telescope oldfiles layout_strategy=horizontal layout_config={preview_width=0.5}<cr>",
    { noremap = true, silent = true, desc = "Recent Files" }
)
vim.keymap.set(
    "n",
    "<leader>fn",
    function()
        telescope_builtins.find_files({
            find_command = { "fd", "-tf", "-H", "-E", ".git", ".", "D:/notes" },
            initial_mode = "insert",
            layout_strategy = "horizontal",
            layout_config = { preview_width = 0.5 },
        })
    end,
    -- [[<cmd>Telescope find_files find_command={'fd','-tf','-H','-E','.git','.','D:/notes'} layout_strategy=horizontal layout_config={preview_width=0.5}<cr>]]
    { noremap = true, silent = true, desc = "find notes" }
)
vim.keymap.set(
    "n",
    "<leader>fc",
    function()
        telescope_builtins.find_files({
            find_command = { "fd", "-tf", "-H", "-E", ".git", ".", vim.fn.expand("$HOME/AppData/Local/nvim") },
            initial_mode = "insert",
            layout_strategy = "horizontal",
            layout_config = { preview_width = 0.5 },
        })
    end,
    -- [[<cmd>lua require'telescope.builtin'.find_files({ find_command = { 'fd','-tf', '-H', '-E', '.git', '.', vim.fn.expand("$HOME/AppData/Local/nvim") } }) layout_strategy=horizontal layout_config={preview_width=0.5}<cr>]]
    { noremap = true, silent = true, desc = "find config_files" }
)

-- close Buffer
vim.keymap.set("n", "<leader>x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    vim.cmd("confirm bd")
end, { noremap = true, silent = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>X", "<cmd>bd!<cr>", { noremap = true, silent = true, desc = "which_key_ignore" })

-- session
vim.keymap.set("n", "<leader>Sf", function()
    require("persistence").load()
end, { noremap = true, silent = true, desc = "Find Session" })
vim.keymap.set("n", "<leader>Sl", function()
    require("persistence").load({ last = true })
end, { noremap = true, silent = true, desc = "Last Session" })
vim.keymap.set("n", "<leader>Ss", function()
    require("persistence").stop()
end, { noremap = true, silent = true, desc = "Stop Session" })

-- Undo
vim.keymap.set(
    { "n" },
    "<leader>u",
    "<cmd>:lua require('telescope').extensions.undo.undo({ side_by_side = false })<CR>",
    { desc = "Undo", noremap = true }
)

-- Quit
vim.keymap.set("n", "<leader>qq", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    pcall(vim.cmd, "NvimTreeClose")
    vim.cmd("confirm qall")
end, { noremap = true, silent = true, desc = "Quit" })
vim.keymap.set("n", "<leader>qw", "<cmd>wq<cr>", { noremap = true, silent = true, desc = "Write & Exit" })
vim.keymap.set("n", "<leader>qQ", "<cmd>q!<cr>", { noremap = true, silent = true, desc = "Force Exit" })
vim.keymap.set({ "n", "i" }, "<C-q>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    local s1, _ = pcall(vim.cmd, "confirm close")
    -- if not s1 then
    -- local s2, _ = pcall(vim.cmd, "confirm bd")
    -- if not s2 then
    -- vim.cmd("confirm q")
    -- end
    -- end
end, { noremap = true, silent = true, desc = "Exit" })

-- tab
vim.keymap.set("n", "<M-x>", "<cmd>tabclose<cr>", { noremap = true, silent = true, desc = "Tab close" })
vim.keymap.set("n", "<M-n>", "<cmd>tabnew<cr>", { noremap = true, silent = true, desc = "Tab new" })
vim.keymap.set("n", "<M-l>", "<cmd>tabnext<cr>", { noremap = true, silent = true, desc = "Tab next" })
vim.keymap.set("n", "<M-h>", "<cmd>tabprevious<cr>", { noremap = true, silent = true, desc = "Tab prev" })

-- LeetCode
vim.keymap.set("n", "<leader>Lt", "<cmd>Leet test<cr>", { noremap = true, silent = true, desc = "Test" })
vim.keymap.set("n", "<leader>Ls", "<cmd>Leet submit<cr>", { noremap = true, silent = true, desc = "Submit" })

-- Neorg
vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<cr>", { noremap = true, silent = true, desc = "index" })
vim.keymap.set("n", "<leader>nj", "<cmd>Neorg journal<cr>", { noremap = true, silent = true, desc = "journal" })

-- Home
vim.keymap.set("n", "<leader>.", function()
    vim.cmd("Dashboard")
end, { noremap = true, silent = true, desc = "which_key_ignore" })

--lazy
vim.keymap.set("n", "<leader>Pc", "<cmd>Lazy clean<CR>", { noremap = true, silent = true, desc = "Clean" })
vim.keymap.set("n", "<leader>Ps", "<cmd>Lazy sync<CR>", { noremap = true, silent = true, desc = "Sync" })
vim.keymap.set("n", "<leader>Pm", "<cmd>Lazy<CR>", { noremap = true, silent = true, desc = "Manager" })
vim.keymap.set("n", "<leader>PP", "<cmd>Lazy profile<CR>", { noremap = true, silent = true, desc = "Profile" })

-- lsp keymap
-- are in ./pluginSetups/lspConfig.lua

-- DAP keymappings
-- vim.keymap.set("n", "<F5>", function() require('dap').continue() end,
--     { desc = "Continue", noremap = true, silent = true })

local function conditional_breakpoint()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    vim.ui.input({
        prompt = "condition : ",
        completion = "buffer",
    }, function(input)
        if not input then
            return
        end
        require("dap").toggle_breakpoint(input)
    end)
end

vim.keymap.set("n", "<Leader>DR", function()
    require("dap").repl.toggle()
end, { desc = "REPL", noremap = true, silent = true })
vim.keymap.set("n", "<F5>", "<CMD>DapContinue<CR>", { desc = "Continue", noremap = true, silent = true })
vim.keymap.set("n", "<F9>", "<CMD>DapToggleBreakpoint<CR>", { desc = "Breakpoints", noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<leader>Dbb",
    "<CMD>DapToggleBreakpoint<CR>",
    { desc = "Breakpoints", noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>Dbc",
    conditional_breakpoint,
    { desc = "Conditional Breakpoints", noremap = true, silent = true }
)
vim.keymap.set("n", "<F7>", function()
    require("dap").step_into()
end, { desc = "Step Into", noremap = true, silent = true })
vim.keymap.set("n", "<F8>", function()
    require("dap").step_out()
end, { desc = "Step Out", noremap = true, silent = true })
vim.keymap.set("n", "<F10>", function()
    require("dap").step_over()
end, { desc = "Step Over", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Dx", function()
    require("dap").terminate()
end, { desc = "Terminate", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Dr", function()
    require("dap").restart()
end, { desc = "Restart", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Dc", function()
    require("dap").clear_breakpoints()
end, { desc = "Clear Breakpoints", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Dl", function()
    require("dap").list_breakpoints()
    vim.cmd([[copen]])
end, { desc = "List Breakpoints", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Du", function()
    require("dap").up()
end, { desc = "Up", noremap = true, silent = true })
vim.keymap.set("n", "<leader>Dd", function()
    require("dap").down()
end, { desc = "Down", noremap = true, silent = true })

-- DAP UI
vim.keymap.set("n", "<leader>Dt", function()
    require("dapui").toggle()
end, { desc = "DapUI toggle", noremap = true, silent = true })

-- zoxide
vim.keymap.set("n", "<leader>z", utils.zoxide, { desc = "Zoxide", noremap = true, silent = true })

-- Find and Replace
vim.keymap.set(
    { "n" },
    "<leader>rr",
    utils.find_and_replace,
    { desc = "Find & Replace", noremap = true, silent = true }
)
vim.keymap.set(
    { "v" },
    "<leader>rr",
    utils.find_and_replace_in_selection,
    { desc = "Find & Replace in Selection", noremap = true, silent = true }
)
vim.keymap.set(
    { "v" },
    "<leader>X",
    utils.replace_selected,
    { desc = "Replace Selected", noremap = true, silent = true }
)

-- help
vim.keymap.set("n", "<leader>ok", ":Telescope keymaps<cr>", { desc = "Search Keymaps", noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<leader>oc",
    ":Telescope commands<cr>",
    { desc = "Search Commands", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>od", ":Telescope help_tags<cr>", { desc = "Search Docs", noremap = true, silent = true })
vim.keymap.set(
    "n",
    "<leader>oh",
    ":Telescope highlights<cr>",
    { desc = "Search Highlights", noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<leader>ot",
    ":Telescope colorscheme<cr>",
    { desc = "Preview Theme", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>oa", function()
    utils.atac_toggle()
end, { desc = "ATAC", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ob", function()
    utils.broot_toggle()
end, { desc = "Broot", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ol", function()
    utils.lazygit_toggle()
end, { desc = "Lazygit", noremap = true, silent = true })

-- Project
vim.keymap.set("n", "<leader>p", function()
    require("telescope").extensions.project.project({ display_type = "full" })
end, { desc = "Projects", noremap = true, silent = true })

-- Mason
vim.keymap.set("n", "<leader>lM", ":Mason<cr>", { desc = "Mason", noremap = true, silent = true })
vim.keymap.set("n", "<leader>l0", ":LspStop<cr>", { desc = "LSP Stop", noremap = true, silent = true })
vim.keymap.set("n", "<leader>l1", ":LspStart<cr>", { desc = "LSP Start", noremap = true, silent = true })
vim.keymap.set("n", "<leader>lI", "<cmd>LspInfo<CR>", { noremap = true, silent = true, desc = "LSP Info" })

-- Neogit
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gl", function()
    utils.lazygit_toggle()
end, { desc = "Lazygit", noremap = true, silent = true })

-- Jujutsu

vim.keymap.set("n", "<leader>gj", function()
    utils.jj_toggle()
end, { desc = "JJ", noremap = true, silent = true })

-- general
vim.keymap.set("v", "<BS>", '"_d', { noremap = true, silent = true })
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "which_key_ignore", noremap = true })
-- vim.keymap.set({ "n", "o", "x" }, "gs", '_', { noremap = true, silent = true, desc = "Goto first char" })
-- vim.keymap.set({ "n", "o", "x" }, "gh", '0', { noremap = true, silent = true, desc = "Goto BOL" })
-- vim.keymap.set({ "n", "o", "x" }, "gl", '$', { noremap = true, silent = true, desc = "Goto EOL" })
vim.keymap.set({ "n", "i" }, "<c-s>", "<esc>:w!<cr>", { noremap = false, silent = true, desc = "Save" })
vim.keymap.set({ "n", "i" }, "<M-s>", function()
    utils.save_as()
end, { noremap = false, silent = true, desc = "Save_as" })
vim.keymap.set({ "n", "i" }, "<M-o>", "<C-6>", { noremap = true, silent = true, desc = "Edit the alternate file" })
vim.keymap.set({ "n", "i" }, "<M-O>", "<C-^>", { noremap = true, silent = true, desc = "Edit the alternate file" })

-- Treesitter
vim.keymap.set({ "n", "x", "o" }, ";", function()
    require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_next()
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, ",", function()
    require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_previous()
end, { noremap = true, silent = true })
vim.keymap.set(
    { "n" },
    "<M-.>",
    "<cmd>lua require('ts-node-action').node_action()<cr>",
    { desc = "Trigger Node Action" }
)

-- Spider
local cusotm_patterns = {
    "[%(%[%{]",
}
vim.keymap.set({ "n", "o", "x" }, "w", function()
    require("spider").motion("w", { customPatterns = { patterns = cusotm_patterns, overrideDefault = false } })
end, { desc = "Spider-w", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "e", function()
    require("spider").motion("e", { customPatterns = { patterns = cusotm_patterns, overrideDefault = false } })
end, { desc = "Spider-e", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "b", function()
    require("spider").motion("b", { customPatterns = { patterns = cusotm_patterns, overrideDefault = false } })
end, { desc = "Spider-b", noremap = true })
vim.keymap.set({ "n", "o", "x" }, "ge", function()
    require("spider").motion("ge", { customPatterns = { patterns = cusotm_patterns, overrideDefault = false } })
end, { desc = "Spider-ge", noremap = true })

-- disabling key
