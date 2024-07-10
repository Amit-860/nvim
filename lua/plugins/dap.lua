return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui" },
        event = "LspAttach",
        opts = function()
            local icons = require("icons")
            local dap_opts = {
                breakpoint = {
                    text = icons.ui.Bug,
                    texthl = "DiagnosticSignError",
                    linehl = "",
                    numhl = "",
                },
                breakpoint_rejected = {
                    text = icons.ui.Bug,
                    texthl = "DiagnosticSignError",
                    linehl = "",
                    numhl = "",
                },
                stopped = {
                    text = icons.ui.BoldArrowRight,
                    texthl = "DiagnosticSignWarn",
                    linehl = "Visual",
                    numhl = "DiagnosticSignWarn",
                },
                log = {
                    level = "info",
                },
            }

            return dap_opts
        end,
        config = function(_, dap_opts)
            local dap = require('dap')

            vim.fn.sign_define("DapBreakpoint", dap_opts.breakpoint)
            vim.fn.sign_define("DapBreakpointRejected", dap_opts.breakpoint_rejected)
            vim.fn.sign_define("DapStopped", dap_opts.stopped)

            dap.set_log_level(dap_opts.log.level)
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = 'python',
        config = function()
            require("dap-python").setup("~/scoop/apps/python/current/python")
        end,
    }
}
