local icons = require("icons")
local dap = require('dap')

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

vim.fn.sign_define("DapBreakpoint", dap_opts.breakpoint)
vim.fn.sign_define("DapBreakpointRejected", dap_opts.breakpoint_rejected)
vim.fn.sign_define("DapStopped", dap_opts.stopped)

dap.set_log_level(dap_opts.log.level)
