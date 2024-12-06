return {
    "olimorris/persisted.nvim",
    cond = not vim.g.vscode,
    opts = {
        autostart = true, -- Automatically start the plugin on load?

        -- Function to determine if a session should be saved
        ---@type fun(): boolean
        should_save = function()
            local bufs = vim.tbl_filter(function(b)
                if
                    vim.bo[b].buftype ~= ""
                    or vim.bo[b].filetype == "gitcommit"
                    or vim.bo[b].filetype == "gitrebase"
                then
                    return false
                end
                return vim.api.nvim_buf_get_name(b) ~= ""
            end, vim.api.nvim_list_bufs())
            if #bufs < 1 then
                return false
            end
            return true
        end,

        save_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- Directory where session files are saved

        follow_cwd = true, -- Change the session file to match any change in the cwd?
        use_git_branch = true, -- Include the git branch in the session file name?
        -- autoload = (not vim.g.neovide and not vim.g.vscode),

        -- Function to run when `autoload = true` but there is no session to load
        ---@type fun(): any
        on_autoload_no_session = function()
            if vim.g.neovide then
                vim.cmd("SessionLoadLast")
            else
                vim.notify("No existing session to load.")
            end
        end,

        allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
        ignored_dirs = {}, -- Table of dirs that are ignored for starting and autoloading

        telescope = {
            mappings = { -- Mappings for managing sessions in Telescope
                copy_session = "<C-c>",
                change_branch = "<C-b>",
                delete_session = "<C-d>",
            },
            icons = { -- icons displayed in the Telescope picker
                selected = " ",
                dir = "󰉖  ",
                branch = " ",
            },
        },
    },
    config = function(_, opts)
        local persisted = require("persisted")
        persisted.branch = function()
            local branch = vim.fn.systemlist("git branch --show-current")[1]
            return vim.v.shell_error == 0 and branch or nil
        end
        persisted.setup(opts)
    end,
}
