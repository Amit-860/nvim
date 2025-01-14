local ignore_for_vscode = { "normal_mode", "insert_mode", "term_mode", "command_mode" }
local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
    insert_mode = generic_opts_any,
    normal_mode = generic_opts_any,
    visual_mode = generic_opts_any,
    visual_block_mode = generic_opts_any,
    command_mode = generic_opts_any,
    operator_pending_mode = generic_opts_any,
    term_mode = { silent = true },
}

local mode_adapters = {
    insert_mode = "i",
    normal_mode = "n",
    term_mode = "t",
    visual_mode = "v",
    visual_block_mode = "x",
    command_mode = "c",
    operator_pending_mode = "o",
}

---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table
---@field operator_pending_mode table

local defaults = {
    insert_mode = {
        -- Move current line / block with Alt-j/k ala vscode.
        ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
        -- Move current line / block with Alt-j/k ala vscode.
        ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
        -- navigation
        ["<A-Up>"] = "<C-\\><C-N><C-w>k",
        ["<A-Down>"] = "<C-\\><C-N><C-w>j",
        ["<A-Left>"] = "<C-\\><C-N><C-w>h",
        ["<A-Right>"] = "<C-\\><C-N><C-w>l",
    },

    normal_mode = {
        -- Buffers
        ["L"] = ":bnext<CR>",
        ["H"] = ":bprevious<CR>",

        -- Better window movement
        ["<C-h>"] = "<C-w>h",
        ["<C-j>"] = "<C-w>j",
        ["<C-k>"] = "<C-w>k",
        ["<C-l>"] = "<C-w>l",

        -- Resize with arrows
        ["<C-Up>"] = ":resize -2<CR>",
        ["<C-Down>"] = ":resize +2<CR>",
        ["<C-Left>"] = ":vertical resize -2<CR>",
        ["<C-Right>"] = ":vertical resize +2<CR>",

        -- Move current line / block with Alt-j/k a la vscode.
        ["<A-j>"] = ":m .+1<CR>==",
        ["<A-k>"] = ":m .-2<CR>==",

        -- QuickFix
        ["]q"] = ":cnext<CR>",
        ["[q"] = ":cprev<CR>",
    },

    term_mode = {
        -- Terminal window navigation
        ["<C-h>"] = "<C-\\><C-N><C-w>h",
        ["<C-j>"] = "<C-\\><C-N><C-w>j",
        ["<C-k>"] = "<C-\\><C-N><C-w>k",
        ["<C-l>"] = "<C-\\><C-N><C-w>l",
    },

    visual_mode = {
        -- Better indenting
        ["<"] = "<gv",
        [">"] = ">gv",

        -- ["p"] = '"0p',
        -- ["P"] = '"0P',
    },

    visual_block_mode = {
        -- Move current line / block with Alt-j/k ala vscode.
        ["<A-j>"] = ":m '>+1<CR>gv-gv",
        ["<A-k>"] = ":m '<-2<CR>gv-gv",
    },

    command_mode = {
        -- navigate tab completion with <c-j> and <c-k>
        -- runs conditionally
        ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
        ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
    },
}

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
local function set_keymaps(mode, key, val)
    local opt = generic_opts[mode] or generic_opts_any
    if type(val) == "table" then
        opt = val[2]
        val = val[1]
    end
    if val then
        vim.keymap.set(mode, key, val, opt)
    else
        pcall(vim.api.nvim_del_keymap, mode, key)
    end
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
local function load_mode(mode, keymaps)
    mode = mode_adapters[mode] or mode
    for k, v in pairs(keymaps) do
        set_keymaps(mode, k, v)
    end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
local function load(keymaps)
    keymaps = keymaps or {}
    for mode, mapping in pairs(keymaps) do
        if vim.g.vscode then
            if not vim.tbl_contains(ignore_for_vscode, mode) then
                load_mode(mode, mapping)
            end
        else
            load_mode(mode, mapping)
        end
    end
end

load(defaults)
