local utils = require('utils')
local starter = require("mini.starter")
local pad = string.rep(" ", 0)
local new_section = function(name, action, section)
    return { name = name, action = action, section = pad .. section }
end
starter.setup({
    evaluate_single = false,
    header =
    "███╗  ██╗██╗   ██╗██╗███╗   ███╗\n████╗ ██║██║   ██║██║████╗ ████║\n██╔██╗██║██║   ██║██║██╔████╔██║\n██║╚████║╚██╗ ██╔╝██║██║╚██╔╝██║\n██║ ╚███║ ╚████╔╝ ██║██║ ╚═╝ ██║\n╚═╝   ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝\n                                ",
    items = {
        -- sessions
        new_section("Dir session", "lua require('persistence').load()", "Session"),
        new_section("Last session", "lua require('persistence').load({last=true})", "Session"),
        new_section("Ignore current session", "lua require('persistence').stop()", "Session"),

        -- Files
        new_section("New file", "ene | startinsert", "Files"),
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
        new_section("Init", [[edit ~/AppData/Local/nvim/init.lua]], "Nvim"),
        new_section("Plugins", [[edit ~/AppData/Local/nvim/lua/plugins.lua]], "Nvim"),
        new_section("Config Files", function()
            utils.smart_find_file({ find_command = { 'fd', '-H', '-E', '.git', '.', vim.fn.expand("$HOME/AppData/Local/nvim/") } })
        end, "Nvim")
        -- new_section("Keybinds", [[edit ~/AppData/Local/nvim/lua/keybinds.lua]], "Nvim"),

        -- Built-ins
        -- new_section("New file", "ene | startinsert", "Built-in"),
        -- new_section("Quit", "qa", "Built-in"),
    },
    content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning("center", "center"),
        starter.gen_hook.padding(3, 2),
    },
})
