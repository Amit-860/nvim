M = {}

local prompt_input_cursor_pos = function(opts, width, on_submit)
    local Input = require("nui.input")
    local popup = {
        relative = "cursor",
        position = {
            row = 1,
            col = 0,
        },
        size = {
            min_width = 18,
            width = width,
        },
        border = {
            style = "single",
            highlight = "FloatBorder",
            padding = { 0, 1 },
        },
        win_options = {
            winhighlight = "NormalFloat:NormalFloat",
        },
    }
    local input = Input(popup, {
        prompt = opts.prompt,
        default_value = opts.default_value,
        on_submit = on_submit,
    })

    input:mount()
    input:map("i", "<Esc>", input.input_props.on_close, { noremap = true })
    input:map("i", "<C-c>", input.input_props.on_close, { noremap = true })
end
M.prompt_input_cursor_pos = prompt_input_cursor_pos

local window_matches = {}
local highlight = function(word, only_current)
    local win_id = vim.api.nvim_get_current_win()
    if not vim.api.nvim_win_is_valid(win_id) then
        return
    end

    window_matches[win_id] = window_matches[win_id] or {}

    -- Add match highlight for current word under cursor
    local current_word_pattern = [[\k*\%#\k*]]
    local match_id_current = vim.fn.matchadd("MiniCursorwordCurrent", current_word_pattern, -1)
    window_matches[win_id].id_current = match_id_current

    -- Don't add main match id if not needed or if one is already present
    if only_current or window_matches[win_id].id ~= nil then
        return
    end

    -- Add match highlight for non-current word under cursor. NOTEs:
    local curword = word
    local pattern = string.format([[\(%s\)\@!\&\V\<%s\>]], current_word_pattern, curword)

    -- highlight for word which will be replaced
    local match_id = vim.fn.matchadd("FindAndReplace", pattern, -1)

    -- Store information about highlight
    window_matches[win_id].id = match_id
    window_matches[win_id].word = curword
end
M.highlight = highlight

local unhighlight = function(only_current)
    -- Don't do anything if there is no valid information to act upon
    local win_id = vim.api.nvim_get_current_win()
    local win_match = window_matches[win_id]
    if not vim.api.nvim_win_is_valid(win_id) or win_match == nil then
        return
    end

    -- Use `pcall` because there is an error if match id is not present. It can
    -- happen if something else called `clearmatches`.
    pcall(vim.fn.matchdelete, win_match.id_current)
    window_matches[win_id].id_current = nil

    if not only_current then
        pcall(vim.fn.matchdelete, win_match.id)
        window_matches[win_id] = nil
    end
end
M.unhighlight = unhighlight

M.smart_find_file = function(opts)
    if not opts.find_command then
        opts.find_command = { "fd", "-H", "-E", ".git" }
    end
    local builtin = require("telescope.builtin")
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

M.zoxide = function()
    vim.ui.input({ prompt = "Pattern : " }, function(input)
        if input then
            vim.cmd("Z " .. input)
        else
            return
        end
    end)
end

M.find_and_replace = function()
    local word = nil
    vim.ui.input({
        prompt = "Find : ",
        completion = "buffer",
    }, function(input)
        word = input
    end)
    if word then
        highlight(word)
        vim.ui.input({
            prompt = "Replace : ",
            completion = "buffer",
        }, function(input)
            if not input then
                return
            end
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
    unhighlight()
    vim.cmd("noh")
end

M.find_and_replace_in_selection = function()
    local word = nil
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) -- changing to normal mode
    local line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
    local line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
    vim.ui.input({
        prompt = "Find : ",
        completion = "buffer",
    }, function(input)
        word = input
    end)
    if word then
        vim.ui.input({
            prompt = "Replace : ",
            completion = "buffer",
        }, function(input)
            if not input then
                return
            end
            vim.cmd(":" .. line1 .. "," .. line2 .. "s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
    vim.cmd("noh")
end

local get_visual_selection = function()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end
M.get_visual_selection = get_visual_selection

M.replace_selected = function()
    local word = nil
    word = get_visual_selection()
    if word then
        vim.ui.input({
            prompt = "Replace : ",
            completion = "buffer",
        }, function(input)
            if not input then
                return
            end
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
end

M.lsp_rename = function()
    local cursor_word = vim.fn.expand("<cword>")
    if not cursor_word then
        return
    end
    prompt_input_cursor_pos(
        { prompt = cursor_word .. " ⇉ ", default_value = cursor_word },
        math.max(52, math.floor((#cursor_word * 2.5) + 3)),
        function(input)
            if not input then
                return
            end
            vim.lsp.buf.rename(input)
        end
    )
end

M.save_as = function()
    vim.ui.input({ prompt = "Save as : " }, function(input)
        if not input then
            return
        end
        vim.cmd("w " .. input)
    end)
end

M.contains = function(list, val)
    for _, v in ipairs(list) do
        if v == val then
            return true
        end
    end
    return false
end

M.lazygit_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float_opts = {
        border = "none",
        height = math.floor(vim.o.lines * 1),
        width = math.floor(vim.o.columns * 1),
    }
    local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(_)
            vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
    })
    -- condition for neovide
    if vim.g.neovide then
        float_opts.height = math.floor(vim.o.lines * 0.98)
        float_opts.width = math.floor(vim.o.columns * 0.98)
    end
    lazygit:toggle()
end

M.jj_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float_opts = {
        border = "none",
        height = math.floor(vim.o.lines * 1),
        width = math.floor(vim.o.columns * 1),
    }
    local lazygit = Terminal:new({
        cmd = "lazyjj",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(_)
            vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
    })
    -- condition for neovide
    if vim.g.neovide then
        float_opts.height = math.floor(vim.o.lines * 0.98)
        float_opts.width = math.floor(vim.o.columns * 0.98)
    end
    lazygit:toggle()
end

M.broot_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local float_opts = {
        -- height = math.floor(vim.o.lines * 1),
        -- width = math.floor(vim.o.columns * 1),
    }
    local broot = Terminal:new({
        cmd = "broot",
        hidden = true,
        direction = "float",
        float_opts = float_opts,
        on_open = function(_)
            vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
    })
    -- condition for neovide
    if vim.g.neovide then
        -- float_opts.height = math.floor(vim.o.lines * 1.0)
        -- float_opts.width = math.floor(vim.o.columns * 1.0)
    end
    broot:toggle()
end

M.code_runner = function(run_cmd, direction)
    local Terminal = require("toggleterm.terminal").Terminal
    local file_name = vim.api.nvim_buf_get_name(0)
    local py_runner = Terminal:new({
        cmd = run_cmd .. " " .. file_name,
        hidden = true,
        direction = direction,
        close_on_exit = false, -- close the terminal window when the process exits
        -- float_opts = {},
        on_open = function(_)
            vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
    })
    py_runner:toggle()
end

local function is_loaded(name)
    local Config = require("lazy.core.config")
    return Config.plugins[name] and Config.plugins[name]._.loaded
end

function M.on_load(name, fn)
    if is_loaded(name) then
        fn(name)
    else
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyLoad",
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

return M
