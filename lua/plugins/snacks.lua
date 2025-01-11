local calendar = require("local.calendar")

-- INFO: Dashboard Keymaps
local dashboard_keys = {
    {
        icon = "  ",
        key = "n",
        desc = "New file",
        action = function()
            vim.cmd("enew")
        end,
    },
    {
        icon = "󱋢  ",
        desc = "Recent files",
        key = "r",
        -- action = function()
        --     vim.cmd("Telescope oldfiles layout_strategy=horizontal layout_config={preview_width=0.5}")
        -- end,
        action = function()
            -- require("telescope").extensions.frecency.frecency({
            --     initial_mode = "insert",
            --     layout_strategy = "horizontal",
            --     layout_config = { preview_width = 0.5 },
            --     path_display = { "shorten" },
            -- })
            require("fzf-lua").oldfiles()
        end,
    },
    {
        icon = "󰮗  ",
        desc = "Find file",
        key = "f",
        action = function()
            require("utils").smart_find_file({
                initial_mode = "insert",
                layout_strategy = "horizontal",
                layout_config = { preview_width = 0.5 },
            })
        end,
    },
    {
        icon = "  ",
        desc = "File explorer",
        key = "e",
        action = function()
            -- require("yazi").yazi(nil, vim.fn.getcwd())
            require("mini.files").open(vim.uv.cwd(), true)
        end,
    },
    {
        icon = "  ",
        desc = "Find session",
        key = "s",
        action = function()
            -- require("persistence").load({ last = true })
            vim.cmd("Telescope persisted theme=dropdown")
        end,
    },
    {
        icon = "  ",
        desc = "Last session",
        key = "l",
        action = function()
            -- require("persistence").load({ last = true })
            vim.cmd("SessionLoadLast")
        end,
    },
    {
        icon = "  ",
        desc = "LeetCode",
        key = "t",
        action = function()
            vim.cmd("Leet")
        end,
    },
    {
        icon = "  ",
        desc = "Projects",
        key = "p",
        action = function()
            require("telescope").extensions.project.project({ display_type = "full" })
        end,
    },
    {
        icon = "  ",
        desc = "NeoGit",
        key = "g",
        action = function()
            vim.cmd("Neogit")
        end,
    },
    {
        icon = "  ",
        desc = "Configs",
        key = "c",
        key_hl = "DashboardButtonShortcut",
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
    --     icon = "󰿅  ",
    --     desc = "Quit",
    --     key = "Q",
    --     action = function()
    --         vim.cmd("q")
    --     end,
    -- },
}

-- INFO: Dashboard Sections
local dashboard_sections = {
    --INFO : Pane -- 1 is Left
    --INFO : Pane -- 2 is Right
    {
        pane = 1,
        text = {
            { "  CWD: ", hl = "footer" },
            { vim.fn.getcwd(), hl = "special" },
        },
        indent = 0,
        padding = 1,
    },
    {
        pane = 1,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
            return require("snacks").git.get_root() ~= nil
        end,
        cmd = "git --no-pager diff --stat --stat-graph-width=28 -B -M -C",
        -- cmd = "git -c color.status=always status -sb --ignore-submodules=dirty && git diff --shortstat",
        key = "-",
        action = function()
            require("snacks").lazygit()
        end,
        height = 9,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
    },
    -- { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 2 },
    {
        pane = 1,
        icon = " ",
        title = "Sessions",
        section = "projects",
        indent = 3,
        padding = 3,
        limit = 8,
        height = 10,
    },
    { pane = 2, text = { calendar.createOutput(), hl = "SnacksDashboardDesc" }, padding = 0 },
    { pane = 2, section = "keys", gap = 0, padding = 1 },
    function()
        local lazy_stats = require("lazy.stats").stats()
        local ms = (math.floor(lazy_stats.startuptime * 100 + 0.5) / 100)
        return {
            pane = 2,
            align = "right",
            text = {
                { "⚡", hl = "DevIconPy" },
                { "Neovim loaded ", hl = "footer" },
                { lazy_stats.loaded .. "", hl = "String" },
                { "/", hl = "special" },
                { lazy_stats.count .. "", hl = "CmpItemAbbr" },
                { " plugins in ", hl = "footer" },
                { ms .. "ms", hl = "Error" },
            },
        }
    end,
}

-- INFO: Dashboard Setup
local dashboard_opts = {
    enabled = true,
    width = 64,
    pane_gap = 5,
    preset = {
        keys = dashboard_keys,
        header = calendar.createOutput(),
    },
    formats = {
        header = { "%s", align = "left" },
    },
    sections = dashboard_sections,
}

-- INFO: highlight for indent module
local function indent_highlight()
    if vim.g.is_night or vim.g.neovide then
        return { scope = "@keyword.return" }
    end
    return { scope = "@constructor" }
end

-- INFO: Snacks Modeules
local snacks_opts = {
    dashboard = dashboard_opts,
    notifier = {
        enabled = true,
    },
    quickfile = {
        enabled = true,
    },
    scratch = {
        enabled = true,
    },
    toggle = {
        enabled = true,
    },
    lazygit = {
        enabled = false,
    },
    statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "git", "fold" }, -- priority of signs on the right (high to low)
        folds = {
            open = true, -- show open fold icons
            git_hl = true, -- use Git Signs hl for fold icons
        },
        git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 100, -- refresh at most every 50ms
    },
    -- bigfile = {
    --     notify = true, -- show notification when big file detected
    --     size = 2 * 1024 * 1024,
    --     -- Enable or disable features when big file detected
    --     ---@param ctx {buf: number, ft:string}
    --     setup = function(ctx)
    --         vim.cmd([[NoMatchParen]])
    --         vim.cmd("IlluminatePauseBuf")
    --         vim.cmd("IBLDisable")
    --         pcall(function()
    --             require("lualine").hide()
    --         end)
    --         Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
    --         vim.b.minianimate_disable = true
    --         vim.schedule(function()
    --             vim.bo[ctx.buf].syntax = ctx.ft
    --         end)
    --     end,
    -- },
    dim = {
        enabled = true,
    },
    input = {
        enabled = false,
    },
    -- scroll = {
    --     enabled = not vim.g.neovide,
    -- },
    zen = {
        enabled = true,
        toggles = {
            dim = false,
            git_signs = false,
            mini_diff_signs = false,
            diagnostics = false,
            inlay_hints = false,
        },
    },
    indent = {
        enabled = true,
        indent = {
            hl = "NonText",
            -- can be a list of hl groups to cycle through
            -- hl = {
            --     "SnacksIndent1",
            --     "SnacksIndent2",
            --     "SnacksIndent3",
            --     "SnacksIndent4",
            --     "SnacksIndent5",
            --     "SnacksIndent6",
            --     "SnacksIndent7",
            --     "SnacksIndent8",
            -- },
        },
        animate = {
            enabled = true,
            style = "out", --  "out"|"up_down"|"down"|"up"
            easing = "linear",
            duration = {
                step = 100, -- ms per step
                total = 800, -- maximum duration
            },
        },
        scope = {
            enabled = true,
            -- char = "╽",
            char = "╎",
            -- char = "╏",
            -- char = "┇",
            -- char = "┋",
            hl = indent_highlight().scope,
            treesitter = {
                enabled = true,
                blocks = {
                    enabled = false, -- enable to use the following blocks
                    "function_declaration",
                    "function_definition",
                    "method_declaration",
                    "method_definition",
                    "class_declaration",
                    "class_definition",
                    "do_statement",
                    "while_statement",
                    "repeat_statement",
                    "if_statement",
                    "for_statement",
                },
                field_blocks = {
                    "local_declaration",
                },
            },
        },
        chunk = {
            enabled = false,
            only_current = true,
            hl = "@function.builtin",
            char = {
                -- corner_top = "┌",
                -- corner_bottom = "└",
                corner_top = "╭",
                corner_bottom = "╰",
                horizontal = "─",
                vertical = "│",
                arrow = "",
            },
        },
        blank = {
            enabled = true,
            char = "·",
        },
    },
    styles = {
        notification = {
            wo = { wrap = true }, -- Wrap notifications
        },
        scratch = {
            height = math.floor(vim.o.lines * 0.85),
            width = math.floor(vim.o.columns * 0.85),
            bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
            minimal = false,
            noautocmd = false,
            -- position = "right",
            zindex = 20,
            wo = { winhighlight = "NormalFloat:Normal" },
            border = "single",
            title_pos = "center",
            footer_pos = "center",
        },
        zen = {
            enter = true,
            fixbuf = false,
            minimal = false,
            width = 150,
            height = 0,
            backdrop = { transparent = true, blend = 40 },
            keys = { q = false },
            wo = {
                winhighlight = "NormalFloat:Normal",
            },
        },
    },
}

-- INFO: Snacks Keys
local snacks_keys = {
    {
        "<F13>.",
        function()
            require("snacks").scratch()
        end,
        desc = "Toggle Scratch Buffer",
    },
    {
        "<F13>?",
        function()
            require("snacks").scratch.select()
        end,
        desc = "Select Scratch Buffer",
    },
    {
        "<F13>n",
        function()
            require("snacks").notifier.show_history()
        end,
        desc = "Notification History",
    },
    {
        "<F13>gb",
        function()
            require("snacks").git.blame_line()
        end,
        desc = "Git Blame Line",
    },
    {
        "<F13>gl",
        function()
            require("snacks").lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
    },
    {
        "<F13>gg",
        function()
            require("snacks").lazygit()
        end,
        desc = "Lazygit",
    },
    {
        "<F13>gL",
        function()
            require("snacks").lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
    },
    {
        "<F13>N",
        function()
            require("snacks").notifier.hide()
        end,
        desc = "Dismiss All Notifications",
    },
    {
        "<F13>z",
        function()
            require("snacks").zen()
        end,
        desc = "Dismiss All Notifications",
    },
}

return {
    "folke/snacks.nvim",
    cond = not vim.g.vscode,
    event = "UIEnter",
    opts = snacks_opts,
    keys = snacks_keys,
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                local Snacks = require("snacks")

                -- Setup some globals for debugging (lazy-loaded)
                -- _G.dd = function(...)
                --     Snacks.debug.inspect(...)
                -- end
                -- _G.bt = function()
                --     Snacks.debug.backtrace()
                -- end
                -- vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<F13>ts")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<F13>tw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<F13>tL")
                Snacks.toggle.diagnostics():map("<F13>td")
                Snacks.toggle.dim():map("<F13>tD")
                Snacks.toggle.line_number():map("<F13>tl")
                Snacks.toggle.scroll():map("<F13>tS")
                Snacks.toggle.treesitter():map("<F13>tT")
                Snacks.toggle.inlay_hints():map("<F13>th")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<F13>tc")
            end,
        })
    end,
}
