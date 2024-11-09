return {
    "nvim-lualine/lualine.nvim",
    event = { "BufNewFile", "BufReadPost" },
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local icons = require("icons")
        local colors = {
            grey = "#a0a1a7",
            light_green = "#83a598",
            black = "#2F3239",
            red = "#e85c51",
            light_red = "#ff7059",
            green = "#688b89",
            yellow = "#fda47f",
            blue = "#5a93aa",
            magenta = "#ad5c7c",
            cyan = "#afd4de",
            white = "#ebebeb",
            orange = "#fda47f",
            pink = "#cb7985",

            bg0 = "#001925", -- Dark bg (status line and float)
            bg1 = "#002333", -- Default bg
            bg2 = "#002f44", -- Lighter bg (colorcolm folds)
            bg3 = "#00496a", -- Lighter bg (cursor line)
            bg4 = "#2d4f56", -- Conceal, border fg
            fg0 = "#eaeeee", -- Lighter fg
            fg1 = "#e6eaea", -- Default fg
            fg2 = "#cbd9d8", -- Darker fg (status line)
            fg3 = "#587b7b", -- Darker fg (line numbers, fold column)
            sel0 = "#293e40", -- Popup bg, visual selection bg
            sel1 = "#425e5e", -- Popup sel bg, search bg
        }

        local theme = {
            normal = {
                a = { fg = colors.white, bg = colors.bg1, gui = "bold" },
                b = { fg = colors.white, bg = colors.bg2 },
                c = { fg = colors.black, bg = colors.bg0 },
                x = { fg = colors.white, bg = colors.bg1 },
                z = { fg = colors.white, bg = colors.bg1 },
            },
            insert = { a = { fg = colors.black, bg = colors.light_green, gui = "bold" } },
            visual = { a = { fg = colors.black, bg = colors.yellow, gui = "bold" } },
            replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
            command = { a = { fg = colors.black, bg = colors.blue, gui = "bold" } },
        }

        local window_width_limit = 125
        local conditions = {
            buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            hide_in_width = function()
                return vim.o.columns > window_width_limit
            end,
            -- check_git_workspace = function()
            --   local filepath = vim.fn.expand "%:p:h"
            --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
            --   return gitdir and #gitdir > 0 and #gitdir < #filepath
            -- end,
        }

        local empty = require("lualine.component"):extend()
        function empty:draw(default_highlight)
            self.status = ""
            self.applied_separator = ""
            self:apply_highlights(default_highlight)
            self:apply_section_separators()
            return self.status
        end

        -- Put proper separators and gaps between components in sections
        local function process_sections(sections)
            for name, section in pairs(sections) do
                local left = name:sub(9, 10) < "x"
                for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
                    -- table.insert(section, pos * 2, { empty, color = { fg = colors.bg0, bg = colors.bg0 } }) -- uncomment to have custor color scheme on section sepeartor
                    table.insert(section, pos * 2, { empty })
                end
                for id, comp in ipairs(section) do
                    if type(comp) ~= "table" then
                        comp = { comp }
                        section[id] = comp
                    end
                    if vim.g.neovide then
                        comp.separator = left and { right = "" } or { left = "" }
                    else
                        comp.separator = left and { right = "" } or { left = "" }
                    end
                end
            end
            return sections
        end

        local function search_result()
            if vim.v.hlsearch == 0 then
                return ""
            end
            local last_search = vim.fn.getreg("/")
            if not last_search or last_search == "" then
                return ""
            end
            local searchcount = vim.fn.searchcount({ maxcount = 9999 })
            return last_search .. " [" .. searchcount.current .. "/" .. searchcount.total .. "]"
        end

        local macro = {
            function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                    return ""
                else
                    return "Recording @" .. recording_register
                end
            end,
            color = { bg = "#dbc874", fg = "#131a24", gui = "bold" },
        }

        local function get_attached_clients()
            local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
            local buf_ft = vim.bo.filetype
            local buf_client_names = {}
            local buf_lsps = {}
            local buf_linter = {}

            -- add client
            for _, client in pairs(buf_clients) do
                if client.name ~= "copilot" and client.name ~= "null-ls" then
                    table.insert(buf_lsps, client.name)
                end
            end

            vim.list_extend(buf_client_names, buf_lsps)

            -- Add sources (from null-ls)
            -- null-ls registers each source as a separate attached client, so we need to filter for unique names down below.
            local null_ls_s, null_ls = pcall(require, "null-ls")
            if null_ls_s then
                local sources = null_ls.get_sources()
                for _, source in ipairs(sources) do
                    if source._validated then
                        for ft_name, ft_active in pairs(source.filetypes) do
                            if ft_name == buf_ft and ft_active then
                                table.insert(buf_linter, source.name)
                            end
                        end
                    end
                end
            end

            -- Add linters (from nvim-lint)
            local lint_s, lint = pcall(require, "lint")
            if lint_s then
                for ft_k, ft_v in pairs(lint.linters_by_ft) do
                    if type(ft_v) == "table" then
                        for _, linter in ipairs(ft_v) do
                            if buf_ft == ft_k then
                                table.insert(buf_linter, linter)
                            end
                        end
                    elseif type(ft_v) == "string" then
                        if buf_ft == ft_k then
                            table.insert(buf_linter, ft_v)
                        end
                    end
                end
            end

            vim.list_extend(buf_client_names, buf_linter)

            -- This needs to be a string only table so we can use concat below
            local unique_client_names = {}
            for _, client_name_target in ipairs(buf_client_names) do
                local is_duplicate = false
                for _, client_name_compare in ipairs(unique_client_names) do
                    if client_name_target == client_name_compare then
                        is_duplicate = true
                    end
                end
                if not is_duplicate then
                    table.insert(unique_client_names, client_name_target)
                end
            end

            if #buf_lsps == 0 then
                table.insert(unique_client_names, 1, "No LSP")
            end
            if #buf_linter == 0 then
                table.insert(unique_client_names, "No Linter")
            end

            local client_names_str = table.concat(unique_client_names, ", ")
            local language_servers = string.format("[%s]", client_names_str)

            return language_servers
        end

        local page_status = {
            function()
                local line_digits = math.floor(math.log(vim.api.nvim_buf_line_count(0), 10) + 1)
                local col_digits = math.floor(math.log(vim.o.columns * 1.0, 10) + 0)
                -- return '[%' .. line_digits .. 'l/%-' .. col_digits .. 'c]'
                return "L:%-" .. line_digits .. "l C:%-" .. col_digits .. "c"
            end,
        }

        local telescope_builtins_status, telescope_builtins = pcall(require, "telescope.builtin")

        local git_on_click = function()
            if telescope_builtins_status then
                telescope_builtins.git_branches({
                    initial_mode = "normal",
                    bufnr = 0,
                    theme = "dropdown",
                    layout_strategy = "vertical",
                    layout_config = { preview_height = 0.6 },
                })
            end
        end

        local diagnostics_on_click = function()
            telescope_builtins.diagnostics({
                theme = "dropdown",
                layout_strategy = "vertical",
                layout_config = { preview_height = 0.6 },
            })
        end

        local gitdiff_on_click = function()
            if telescope_builtins_status then
                telescope_builtins.git_status({
                    initial_mode = "normal",
                    bufnr = 0,
                    theme = "dropdown",
                    layout_strategy = "vertical",
                    layout_config = { preview_height = 0.6 },
                })
            end
        end

        local attached_on_click = function()
            pcall(vim.cmd, "LspInfo")
        end

        local custom_color_section = {
            lualine_a = {
                {
                    "mode",
                    color = { gui = "bold" },
                },
                macro,
            },
            lualine_b = {
                {
                    "b:gitsigns_head",
                    icon = icons.git.Branch,
                    color = { gui = "bold", bg = colors.bg2 },
                    on_click = git_on_click,
                },
                {
                    "diff",
                    color = { gui = "bold", bg = colors.bg2 },
                    cond = conditions.hide_in_width,
                    on_click = gitdiff_on_click,
                },
                {
                    "diagnostics",
                    source = { "nvim" },
                    sections = { "error" },
                    diagnostics_color = { error = { bg = colors.red, fg = colors.black, gui = "bold" } },
                },
                {
                    "diagnostics",
                    source = { "nvim" },
                    sections = { "warn" },
                    diagnostics_color = { warn = { bg = colors.orange, fg = colors.black } },
                },
                {
                    "filename",
                    file_status = false,
                    path = 1, -- 0 shows noly fileaname, 1 shows relative filepath, 2 shows absolute filepath
                    color = { bg = colors.bg3 },
                    -- cond = conditions.hide_in_width,
                },
                {
                    function()
                        if vim.bo.modified then
                            return ""
                        end
                        return ""
                    end,
                    color = { bg = colors.light_green, fg = colors.black, gui = "bold" },
                },
                {
                    function()
                        if vim.bo.modifiable == false or vim.bo.readonly == true then
                            return ""
                        end
                        return ""
                    end,
                    color = { bg = colors.light_red, fg = colors.black, gui = "bold" },
                },
                {
                    "%w",
                    cond = function()
                        return vim.wo.previewwindow
                    end,
                },
                -- {
                --     '%r',
                --     cond = function()
                --         return vim.bo.readonly
                --     end,
                -- },
                {
                    "%q",
                    cond = function()
                        return vim.bo.buftype == "quickfix"
                    end,
                },
            },
            lualine_c = {},
            lualine_x = { search_result },
            lualine_y = {
                { "filetype", color = { bg = colors.bg3 }, on_click = diagnostics_on_click },
                { get_attached_clients, cond = conditions.hide_in_width, on_click = attached_on_click },
            },
            lualine_z = { page_status, "%2p%%/%L", "filesize" },
        }

        local no_color_section = {
            lualine_a = {
                {
                    "mode",
                    color = { gui = "bold" },
                },
                macro,
            },
            lualine_b = {
                {
                    "b:gitsigns_head",
                    icon = icons.git.Branch,
                    color = { gui = "bold" },
                    on_click = git_on_click,
                },
                {
                    "diff",
                    color = { gui = "bold" },
                    cond = conditions.hide_in_width,
                    on_click = gitdiff_on_click,
                },
                {
                    "diagnostics",
                    source = { "nvim" },
                    sections = { "error" },
                    diagnostics_color = { error = { bg = colors.red, fg = colors.black } },
                },
                {
                    "diagnostics",
                    source = { "nvim" },
                    sections = { "warn" },
                    diagnostics_color = { warn = { bg = colors.orange, fg = colors.black } },
                },
                {
                    "diagnostics",
                    source = { "nvim" },
                    sections = { "info" },
                    diagnostics_color = { info = { bg = colors.green, fg = colors.black } },
                },
                {
                    "filename",
                    file_status = false,
                    path = 1, -- 0 shows noly fileaname, 1 shows relative filepath, 2 shows absolute filepath,
                    -- cond = conditions.hide_in_width,
                },
                {
                    function()
                        if vim.bo.modified then
                            return ""
                        end
                        return ""
                    end,
                    color = { bg = colors.light_green, fg = colors.black, gui = "bold" },
                },
                {
                    function()
                        if vim.bo.modifiable == false or vim.bo.readonly == true then
                            return " "
                        end
                        return ""
                    end,
                    color = { bg = colors.light_red, fg = colors.black, gui = "bold" },
                },
                {
                    "%w",
                    cond = function()
                        return vim.wo.previewwindow
                    end,
                },
                -- {
                --     '%r',
                --     cond = function()
                --         return vim.bo.readonly
                --     end,
                -- },
                {
                    "%q",
                    cond = function()
                        return vim.bo.buftype == "quickfix"
                    end,
                },
            },
            lualine_c = {},
            lualine_x = { search_result },
            lualine_y = {
                { "filetype", on_click = diagnostics_on_click },
                { get_attached_clients, cond = conditions.hide_in_width, on_click = attached_on_click },
            },
            lualine_z = { page_status, "%2p%%/%L", "filesize" },
        }

        local lualine_opts = {
            options = {
                -- theme = theme,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { "dashboard" },
                refresh = { -- sets how often lualine should refresh it's contents (in ms)
                    statusline = 1500,
                    tabline = 30000, -- to maintain between refresh. It's not guarantied if situation
                    winbar = 30000, -- arises that lualine needs to refresh itself before this time
                },
            },
            sections = process_sections(no_color_section),
            inactive_sections = {
                lualine_c = { "%f %y %m" },
                lualine_x = {},
            },
        }
        if vim.g.neovide then
            lualine_opts.options.theme = theme
            lualine_opts.sections = process_sections(custom_color_section)
        end

        return lualine_opts
    end,
}
