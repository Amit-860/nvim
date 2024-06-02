local utils = require('utils')
require('mini.ai').setup()
require('mini.align').setup()
require('mini.comment').setup({
    mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = 'gc',

        -- Toggle comment on current line
        comment_line = '<leader>/',

        -- Toggle comment on visual selection
        comment_visual = '<leader>/',

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
        -- new_section("Git", "LazyGit", "Git"),
        new_section("NeoGit", "Neogit", "Git"),
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

require('mini.statusline').setup({
    content = {
        active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                 strings = { mode } },
                { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = "CmpItemKindFunction",    strings = { search } },
                { hl = mode_hl,                  strings = { location } },
            })
        end,
    },
    use_icons = true,
    set_vim_settings = true,
})
require('mini.tabline').setup()
require('mini.basics').setup({
    options = { extra_ui = true, win_borders = 'double', },
    mappings = { windows = true, }
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'CmpItemKindClass' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'CmpItemKindValue' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'CmpItemKindMethod' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'CmpItemKindText' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})
