---@return table
local utils = require('utils')
local M = {}

local function week_header()
    local week = {
        ['Monday'] = {
            '',
            '███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗',
            '████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ',
            '██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ',
            '██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ',
            '╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Tuesday'] = {
            '',
            '████████╗██╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗',
            '╚══██╔══╝██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '   ██║   ██║   ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ',
            '   ██║   ██║   ██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ',
            '   ██║   ╚██████╔╝███████╗███████║██████╔╝██║  ██║   ██║   ',
            '   ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Wednesday'] = {
            '',
            '██╗    ██╗███████╗██████╗ ███╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗',
            '██║    ██║██╔════╝██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '██║ █╗ ██║█████╗  ██║  ██║██╔██╗ ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ',
            '██║███╗██║██╔══╝  ██║  ██║██║╚██╗██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ',
            '╚███╔███╔╝███████╗██████╔╝██║ ╚████║███████╗███████║██████╔╝██║  ██║   ██║   ',
            ' ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Thursday'] = {
            '',
            '████████╗██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ ██╗   ██╗',
            '╚══██╔══╝██║  ██║██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '   ██║   ███████║██║   ██║██████╔╝███████╗██║  ██║███████║ ╚████╔╝ ',
            '   ██║   ██╔══██║██║   ██║██╔══██╗╚════██║██║  ██║██╔══██║  ╚██╔╝  ',
            '   ██║   ██║  ██║╚██████╔╝██║  ██║███████║██████╔╝██║  ██║   ██║   ',
            '   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Friday'] = {
            '',
            '███████╗██████╗ ██╗██████╗  █████╗ ██╗   ██╗',
            '██╔════╝██╔══██╗██║██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '█████╗  ██████╔╝██║██║  ██║███████║ ╚████╔╝ ',
            '██╔══╝  ██╔══██╗██║██║  ██║██╔══██║  ╚██╔╝  ',
            '██║     ██║  ██║██║██████╔╝██║  ██║   ██║   ',
            '╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Saturday'] = {
            '',
            '███████╗ █████╗ ████████╗██╗   ██╗██████╗ ██████╗  █████╗ ██╗   ██╗',
            '██╔════╝██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '███████╗███████║   ██║   ██║   ██║██████╔╝██║  ██║███████║ ╚████╔╝ ',
            '╚════██║██╔══██║   ██║   ██║   ██║██╔══██╗██║  ██║██╔══██║  ╚██╔╝  ',
            '███████║██║  ██║   ██║   ╚██████╔╝██║  ██║██████╔╝██║  ██║   ██║   ',
            '╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
        ['Sunday'] = {
            '',
            '███████╗██╗   ██╗███╗   ██╗██████╗  █████╗ ██╗   ██╗',
            '██╔════╝██║   ██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝',
            '███████╗██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ',
            '╚════██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ',
            '███████║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ',
            '╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ',
            '',
        },
    }
    local daysoftheweek = { 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' }
    local day = daysoftheweek[os.date('*t').wday]
    return week[day]
end

local function layout()
    ---@param sc string
    ---@param txt string
    ---@param keybind_opts table?
    ---@param opts table?
    ---@return table
    local function button(sc, txt, keybind, keybind_opts, opts)
        local def_opts = {
            cursor = 3,
            align_shortcut = "right",
            hl_shortcut = "AlphaButtonShortcut",
            hl = "AlphaButton",
            width = 35,
            position = "center",
        }
        opts = opts and vim.tbl_extend("force", def_opts, opts) or def_opts
        opts.shortcut = sc
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<Leader>")
        local on_press = function()
            local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
            vim.api.nvim_feedkeys(key, "t", false)
        end
        if keybind then
            keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
            opts.keymap = { "n", sc_, keybind, keybind_opts }
        end
        return { type = "button", val = txt, on_press = on_press, opts = opts }
    end

    -- https://github.com/goolord/alpha-nvim/issues/105
    local lazycache = setmetatable({}, {
        __newindex = function(table, index, fn)
            assert(type(fn) == "function")
            getmetatable(table)[index] = fn
        end,
        __call = function(table, index)
            return function()
                return table[index]
            end
        end,
        __index = function(table, index)
            local fn = getmetatable(table)[index]
            if fn then
                local value = fn()
                rawset(table, index, value)
                return value
            end
        end,
    })

    ---@return string
    lazycache.info = function()
        local plugins = #vim.tbl_keys(require("lazy").plugins())
        local v = vim.version()
        local datetime = os.date "  %d-%m-%Y   🕑 %H:%M:%S"
        local platform = vim.fn.has "win32" == 1 and "" or ""
        return string.format(" %d's   %s v%d.%d.%d   ⎸ %s", plugins, platform, v.major, v.minor, v.patch, datetime)
    end

    ---@return table
    lazycache.menu = function()
        local hl = "AlphaIconColor"
        return {
            button("N", "  New file", "<cmd>enew<cr>", nil, { hl = { { hl, 0, 3 } } }),
            button("R", "󱋢  Recently files", "<cmd>Telescope oldfiles<cr>", nil, { hl = { { hl, 0, 3 } } }),
            button("F", "󰮗  Find file",
                [[<cmd>lua require("utils").smart_find_file({})<cr>]]
                , nil,
                { hl = { { hl, 0, 3 } } }),
            button("E", "  File explorer",
                [[<cmd>lua require("yazi").yazi(nil, vim.fn.getcwd())<cr>]]
                , nil,
                { hl = { { hl, 0, 3 } } }),
            button("L", "  Last session",
                [[<cmd>lua require('persistence').load({ last = true })<cr>]]
                , nil,
                { hl = { { hl, 0, 3 } } }),
            button("T", "  LeetCode", "<cmd>Leet<cr>", nil, { hl = { { hl, 0, 3 } } }),
            button("P", "  Projects",
                [[<cmd>lua require'telescope'.extensions.project.project { display_type = 'full' }<cr>]]
                , nil,
                { hl = { { hl, 0, 3 } } }),
            button("G", "  NeoGit", "<cmd>Neogit<cr>", nil, { hl = { { hl, 0, 3 } } }),
            button("C", "  Configs",
                [[<cmd>lua require'telescope.builtin'.find_files({ find_command = { 'fd', '-H', '-E', '.git', '.', vim.fn.expand("$HOME/AppData/Local/nvim") } })<cr>]]
                , nil,
                { hl = { { hl, 0, 3 } } }
            ),
            -- button("Q", "󰿅  Quit", "<Cmd>q<CR>", nil, { hl = { { hl, 0, 3 } } }),
        }
    end

    ---@return table
    lazycache.mru = function()
        local result = {}
        for _, filename in ipairs(vim.v.oldfiles) do
            if vim.loop.fs_stat(filename) ~= nil then
                local icon, hl = require("nvim-web-devicons").get_icon(filename, vim.fn.fnamemodify(filename, ":e"))
                if not icon then icon = '󱀶' end
                if not hl then hl = "AlphaHeaderColor" end
                local filename_short = string.sub(vim.fn.fnamemodify(filename, ":t"), 1, 30)
                table.insert(
                    result,
                    button(
                        tostring(#result + 1),
                        string.format("%s  %s", icon, filename_short),
                        string.format("<Cmd>e %s<CR>", filename),
                        nil,
                        { hl = { { hl, 0, 3 }, { "Normal", 5, #filename_short + 5 } } }
                    )
                )
                if #result == 9 then
                    break
                end
            end
        end
        return result
    end

    ---@return table
    lazycache.fortune = function()
        return require "alpha.fortune" ()
    end

    math.randomseed(os.time())
    -- local AlphaHeaderColor = "AlphaCol" .. math.random(11)

    M.sections = {
        -- {
        --     type = "text",
        --     val = {
        --         "                                                     ",
        --         "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        --         "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        --         "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        --         "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        --         "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        --         "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        --         "                                                     ",
        --     },
        --     opts = { hl = "AlphaHeaderColor", position = "center" },
        -- },
        {
            type = "text",
            val = week_header(),
            opts = { hl = "AlphaHeaderColor", position = "center" },
        },
        -- { type = "padding", val = 1 },
        {
            type = "text",
            val = lazycache "info",
            opts = { hl = "AlphaInfoColor", position = "center" },
        },
        { type = "padding", val = 2 },
        {
            type = "group",
            val = lazycache "menu",
            opts = { spacing = 0 },
        },
        { type = "padding", val = 1 },
        -- {
        --     type = "text",
        --     val = "-----------------------------------------------",
        --     opts = { hl = "AlphaHeaderColor", position = "center" },
        -- },
        -- { type = "padding", val = 1 },
        {
            type = "group",
            val = lazycache "mru",
            opts = { spacing = 0 },
        },
        { type = "padding", val = 1 },
        {
            type = "text",
            val = lazycache "fortune",
            opts = { hl = "AlphaQuote", position = "center" },
        },
        { type = "padding", val = 1 },
    }
    return M.sections
end

require("alpha").setup {
    layout = layout(),
    opts = {
        setup = function()
            local line_hilight = require('colors').line_hilight
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                desc = "Disable status and tabline for alpha",
                callback = function()
                    vim.go.laststatus = 0
                    vim.opt.showtabline = 0
                    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = nil })
                    vim.api.nvim_set_hl(0, "StatusLine", { bg = nil })
                    vim.api.nvim_set_hl(0, "TabLineFill", { bg = nil })
                    vim.b.miniindentscope_disable = true
                    vim.b.minitabline_disable = true
                    vim.b.ministatusline_disable = true
                end,
            })
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                desc = "Enable status and tabline after alpha",
                callback = function()
                    vim.go.laststatus = 3
                    vim.opt.showtabline = 2
                    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = line_hilight, fg = "#aeafb0", blend = 0 })
                    vim.api.nvim_set_hl(0, "StatusLine", { bg = line_hilight, fg = "#71839b", blend = 0 })
                    vim.api.nvim_set_hl(0, "TabLineFill", { bg = line_hilight })
                end,
            })
        end,
        margin = 5,
    },
}

local get_lazy_stats = function()
    local stats = require('lazy').stats()
    return string.format("󱐌 Started in %dms", stats.startuptime)
end

vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
        local top_padding = {
            type = "padding",
            val = function()
                return math.floor(vim.o.lines * 0.15)
            end
        }
        local startuptimeSections = {
            type = "text",
            val = get_lazy_stats(),
            opts = { hl = "AlphaButtonShortcut", position = "center" },
        }
        table.insert(M.sections, 0, top_padding)
        table.insert(M.sections, startuptimeSections)
        vim.cmd("AlphaRedraw")
    end,
})


vim.api.nvim_set_hl(0, "AlphaButtonShortcut", { fg = "#e95d5d", bold = true })
vim.api.nvim_set_hl(0, "AlphaHeaderColor", { fg = "#006782", bold = true })
vim.api.nvim_set_hl(0, "AlphaIconColor", { fg = "#dbc074", bold = true })
vim.api.nvim_set_hl(0, "AlphaInfoColor", { fg = "#a5a6aa", bold = true })
