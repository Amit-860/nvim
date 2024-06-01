local utils = require('utils')
require('mini.ai').setup()
require('mini.align').setup()
require('mini.comment').setup({
    mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = 'gc',

        -- Toggle comment on current line
        comment_line = 'gc',

        -- Toggle comment on visual selection
        comment_visual = 'gc',

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = 'gc',
    },
})
require('mini.cursorword').setup()
require('mini.files').setup()
require('mini.indentscope').setup()


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

        -- Files
        new_section("Find file", utils.smart_find_file, "Files"),
        new_section("Recent files", "Telescope oldfiles", "Files"),

        -- Projects
        new_section("Project",
            function()
                require 'telescope'.extensions.project.project { display_type = 'full' }
            end,
            "Projects"
        ),

        -- git
        new_section("Neogit", "Neogit", "Git"),
        new_section("Status", "Telescope git_status", "Git"),
        new_section("Branches", "Telescope git_branches", "Git"),

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

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})
