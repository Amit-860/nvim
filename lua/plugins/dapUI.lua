return {
    {
        "miroshQa/debugmaster.nvim",
        enabled = false,
        ft = { "python", "java" },
        cond = not vim.g.vscode,
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy", cond = not vim.g.vscode, opts = {} },
        },
        config = function()
            local dm = require("debugmaster")
            vim.keymap.set({ "n", "v" }, "<leader>dt", dm.mode.toggle, { nowait = true })

            -- Auto-open/close
            local dap = require("dap")
            local auto_open = true
            if auto_open then
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    require("debugmaster.state")
                    require("debugmaster.plugins")
                    require("debugmaster.debug.mode").enable()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    require("debugmaster.state")
                    require("debugmaster.plugins")
                    require("debugmaster.debug.mode").disable()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    require("debugmaster.state")
                    require("debugmaster.plugins")
                    require("debugmaster.debug.mode").disable()
                end
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        ft = { "python", "java" },
        cond = not vim.g.vscode,
        dependencies = {
            { "nvim-neotest/nvim-nio", event = "VeryLazy", cond = not vim.g.vscode },
            { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy", cond = not vim.g.vscode, opts = {} },
        },
        keys = {
            vim.keymap.set("n", "<leader>dt", function()
                require("dapui").toggle()
            end, { desc = "DapUI toggle", noremap = true, silent = true }),
        },
        opts = function()
            local ui_opts = {
                auto_open = true,
                notify = {
                    threshold = vim.log.levels.INFO,
                },
                config = {
                    icons = { expanded = "", collapsed = "", circular = "" },
                    mappings = {
                        -- Use a table to apply multiple mappings
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        edit = "e",
                        repl = "r",
                        toggle = "t",
                    },
                    -- Use this to override mappings for specific elements
                    element_mappings = {},
                    expand_lines = true,
                    layouts = {
                        {
                            elements = {
                                { id = "scopes", size = 0.40 },
                                { id = "watches", size = 0.20 },
                                { id = "stacks", size = 0.20 },
                                { id = "console", size = 0.20 },
                                -- { id = "breakpoints", size = 0.10 },
                                -- { id = "repl", size = 0.15 },
                            },
                            size = 0.33,
                            position = "right",
                        },
                        {
                            elements = {
                                -- { id = "repl", size = 0.45 },
                                -- { id = "console", size = 0.55 },
                            },
                            size = 0.25,
                            position = "bottom",
                        },
                    },
                    controls = {
                        enabled = true,
                        -- Display controls in this element
                        element = "repl",
                        icons = {
                            pause = "",
                            play = "",
                            step_into = "",
                            step_over = "",
                            step_out = "",
                            step_back = "",
                            run_last = "",
                            terminate = "",
                        },
                    },
                    floating = {
                        max_height = 0.9,
                        max_width = 0.5, -- Floats will be treated as percentage of your screen.
                        border = "rounded",
                        mappings = {
                            close = { "q", "<Esc>" },
                        },
                    },
                    windows = { indent = 1 },
                    render = {
                        max_type_length = nil, -- Can be integer or nil.
                        max_value_lines = 100, -- Can be integer or nil.
                    },
                },
            }

            return ui_opts
        end,
        config = function(_, opts)
            local dapui = require("dapui")
            dapui.setup(opts.config)
            local dap = require("dap")
            if opts.auto_open then
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end
        end,
    },
}
