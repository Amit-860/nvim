return {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
        vim.api.nvim_set_hl(0, "DashboardButtonShortcut", { fg = "#e95d5d", bold = true })
        vim.api.nvim_set_hl(0, "DashboardHeaderColor", { fg = "#006782", bold = true })
        vim.api.nvim_set_hl(0, "DashboardIconColor", { link = "@constant" })
        vim.api.nvim_set_hl(0, "DashboardInfoColor", { fg = "#a5a6aa", bold = true })
        vim.api.nvim_set_hl(0, "DashboardDescColor", { link = "@lsp.type.variable" })

        local function week_header()
            local week = {
                ["Monday"] = {
                    "",
                    "███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗",
                    "████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ",
                    "██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ",
                    "╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Tuesday"] = {
                    "",
                    "████████╗██╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗",
                    "╚══██╔══╝██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "   ██║   ██║   ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ",
                    "   ██║   ██║   ██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "   ██║   ╚██████╔╝███████╗███████║██████╔╝██║  ██║   ██║   ",
                    "   ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Wednesday"] = {
                    "",
                    "██╗    ██╗███████╗██████╗ ███╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗",
                    "██║    ██║██╔════╝██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "██║ █╗ ██║█████╗  ██║  ██║██╔██╗ ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ",
                    "██║███╗██║██╔══╝  ██║  ██║██║╚██╗██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "╚███╔███╔╝███████╗██████╔╝██║ ╚████║███████╗███████║██████╔╝██║  ██║   ██║   ",
                    " ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Thursday"] = {
                    "",
                    "████████╗██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ ██╗   ██╗",
                    "╚══██╔══╝██║  ██║██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "   ██║   ███████║██║   ██║██████╔╝███████╗██║  ██║███████║ ╚████╔╝ ",
                    "   ██║   ██╔══██║██║   ██║██╔══██╗╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "   ██║   ██║  ██║╚██████╔╝██║  ██║███████║██████╔╝██║  ██║   ██║   ",
                    "   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Friday"] = {
                    "",
                    "███████╗██████╗ ██╗██████╗  █████╗ ██╗   ██╗",
                    "██╔════╝██╔══██╗██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "█████╗  ██████╔╝██║██║  ██║███████║ ╚████╔╝ ",
                    "██╔══╝  ██╔══██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "██║     ██║  ██║██║██████╔╝██║  ██║   ██║   ",
                    "╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Saturday"] = {
                    "",
                    "███████╗ █████╗ ████████╗██╗   ██╗██████╗ ██████╗  █████╗ ██╗   ██╗",
                    "██╔════╝██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "███████╗███████║   ██║   ██║   ██║██████╔╝██║  ██║███████║ ╚████╔╝ ",
                    "╚════██║██╔══██║   ██║   ██║   ██║██╔══██╗██║  ██║██╔══██║  ╚██╔╝  ",
                    "███████║██║  ██║   ██║   ╚██████╔╝██║  ██║██████╔╝██║  ██║   ██║   ",
                    "╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
                ["Sunday"] = {
                    "",
                    "███████╗██╗   ██╗███╗   ██╗██████╗  █████╗ ██╗   ██╗",
                    "██╔════╝██║   ██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
                    "███████╗██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ",
                    "╚════██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
                    "███████║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ",
                    "╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
                    "",
                },
            }
            local daysoftheweek = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
            local day = daysoftheweek[os.date("*t").wday]
            return week[day]
        end

        local padding = string.rep(" ", 14)

        local function split(s, sep)
            local fields = {}

            local sep = sep or " "
            local pattern = string.format("([^%s]+)", sep)
            string.gsub(s, pattern, function(c)
                fields[#fields + 1] = c
            end)

            return fields
        end

        -- local header = week_header()
        local calendar = require("local.calendar")
        local header = split(calendar.createOutput() .. " \n \n", "\n")

        -- adding padding on top of header
        for _ = 1, math.floor(vim.o.lines * 0.2) do
            table.insert(header, 1, "")
        end

        -- adding date and time to header
        local datetime = function()
            local stats = require("lazy").stats()
            local plugins = #vim.tbl_keys(require("lazy").plugins())
            local date = calendar.date
            -- local datetime = os.date("  %d-%m-%Y    %H:%M:%S")
            local time = os.date("  %H hrs : %M mins & %S secs")
            -- local datetime = "  " .. date.day .. " " .. date.monthName .. " " .. date.year .. ", " .. date.dayName
            -- local v = vim.version()
            -- local platform = vim.fn.has "win32" == 1 and "" or ""
            -- return string.format(" %d's  %s v%d.%d.%d   ⎸ %s", plugins, platform, v.major, v.minor, v.patch, datetime)
            -- return string.format(" %d's plugins installed   ⎸ %s", plugins, datetime)
            return string.format(" %d's plugins installed   ⎸ %s", plugins, time)
        end
        vim.list_extend(header, { datetime(), "", "", "" })

        -- adding startuptime in footer
        local footer = function()
            -- we need to call lazy stats again otherwise reopening dashboard will throw error
            local stats = require("lazy").stats()
            local v = vim.version()
            local platform = vim.fn.has("win32") == 1 and "" or ""
            return {
                "",
                "",
                string.format("󱐌 Started in %.2fms & 󰐧 %d plugins loaded ", stats.startuptime, stats.loaded),
                "",
                string.format("%s v%d.%d.%d", platform, v.major, v.minor, v.patch),
            }
        end

        local dashboard_opts = {
            theme = "doom",
            config = {
                header = header,
                center = {
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "New File" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "N",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            vim.cmd("enew")
                        end,
                    },
                    {
                        icon = "󱋢  ",
                        icon_hl = "DashboardIconColor",
                        desc = "Recent Files" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "R",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            vim.cmd("Telescope oldfiles layout_strategy=horizontal layout_config={preview_width=0.5}")
                        end,
                    },
                    -- {
                    --     icon = '󰮗  ',
                    --     icon_hl = 'DashboardIconColor',
                    --     desc = 'Find file' .. padding,
                    --     desc_hl = 'DashboardDescColor',
                    --     key = 'F',
                    --     keymap = '',
                    --     key_hl = 'DashboardButtonShortcut',
                    --     key_format = ' %s',
                    --     action = function() require("utils").smart_find_file({}) end
                    -- },
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "File explorer" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "E",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            require("yazi").yazi(nil, vim.fn.getcwd())
                        end,
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "Last session" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "L",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            require("persistence").load({ last = true })
                        end,
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "LeetCode" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "T",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            vim.cmd("Leet")
                        end,
                    },
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "Projects" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "P",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            require("telescope").extensions.project.project({ display_type = "full" })
                        end,
                    },
                    -- {
                    --     icon = '  ',
                    --     icon_hl = 'DashboardIconColor',
                    --     desc = 'NeoGit' .. padding,
                    --     desc_hl = 'DashboardDescColor',
                    --     key = 'G',
                    --     keymap = '',
                    --     key_hl = 'DashboardButtonShortcut',
                    --     key_format = ' %s',
                    --     action = function() vim.cmd("Neogit") end
                    -- },
                    {
                        icon = "  ",
                        icon_hl = "DashboardIconColor",
                        desc = "Configs" .. padding,
                        desc_hl = "DashboardDescColor",
                        key = "C",
                        keymap = "",
                        key_hl = "DashboardButtonShortcut",
                        key_format = " %s",
                        action = function()
                            require("telescope.builtin").find_files({
                                find_command = {
                                    "fd",
                                    "-tf",
                                    "-H",
                                    "-E",
                                    ".git",
                                    ".",
                                    vim.fn.expand("$HOME/AppData/Local/nvim"),
                                },
                            })
                        end,
                    },
                    -- {
                    --     icon = '󰿅  ',
                    --     icon_hl = 'DashboardIconColor',
                    --     desc = 'Quit' .. padding,
                    --     desc_hl = 'DashboardDescColor',
                    --     key = 'Q',
                    --     keymap = '',
                    --     key_hl = 'DashboardButtonShortcut',
                    --     key_format = ' %s',
                    --     action = function() vim.cmd("q") end
                    -- }
                },
                footer = footer,
            },
        }

        -- open dashboard after closing lazy
        if vim.o.filetype == "lazy" then
            vim.api.nvim_create_autocmd("WinClosed", {
                pattern = tostring(vim.api.nvim_get_current_win()),
                once = true,
                callback = function()
                    vim.schedule(function()
                        vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
                    end)
                end,
            })
        end

        return dashboard_opts
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
