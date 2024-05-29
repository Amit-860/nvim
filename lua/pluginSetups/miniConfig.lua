require('mini.ai').setup()
require('mini.align').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.files').setup()
require('mini.indentscope').setup()
require('mini.map').setup()
require('mini.pairs').setup()
require('mini.splitjoin').setup()

local starter = require("mini.starter")
local pad = string.rep(" ", 0)
local new_section = function(name, action, section)
    return { name = name, action = action, section = pad .. section }
end
starter.setup({
    evaluate_single = true,
    header =
    "███╗   ███╗██╗   ██╗██╗███╗   ███╗\n████╗ ████║██║   ██║██║████╗ ████║\n██╔████╔██║██║   ██║██║██╔████╔██║\n██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║\n██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║\n╚═╝     ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝\n                                  ",
    items = {
        -- sessions
        new_section("Dir session", "lua require('persistence').load()", "Session"),
        new_section("Last session", "lua require('persistence').load({last=true})", "Session"),
        new_section("Ignore current session", "lua require('persistence').stop()", "Session"),

        -- telescope
        new_section("Find file", "Telescope git_files", "Telescope"),
        new_section("Recent files", "Telescope oldfiles", "Telescope"),
        new_section("Grep text", "Telescope live_grep", "Telescope"),

        -- leetcode
        new_section("Leet", "Leet", "LeetCode"),

        -- config
        new_section("Config", [[edit ~/AppData/Local/nvim/init.lua]], "Nvim"),
        new_section("Plugins", [[edit ~/AppData/Local/nvim/lua/plugins.lua]], "Nvim"),
        new_section("Keybinds", [[edit ~/AppData/Local/nvim/lua/keybinds.lua]], "Nvim"),

        -- Built-ins
        new_section("New file", "ene | startinsert", "Built-in"),
        new_section("Quit", "qa", "Built-in"),
    },
    content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning("center", "center"),
        starter.gen_hook.padding(3, 2),
    },
})

require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.basics').setup({
    options = { extra_ui = true, win_borders = 'double', },
    mappings = { windows = true, }
})

require('mini.surround').setup({
    mappings = {
        add = 'ys',
        delete = 'ds',
        find = 'yf',
        find_left = 'yF',
        highlight = 'yh',
        replace = 'cs',
        update_n_lines = '',

        -- Add this only if you don't want to use extended mappings
        suffix_last = '',
        suffix_next = '',
    },
    search_method = 'cover_or_next',
})
