-- Enable powershell as your default shell
vim.loader.enabled = true
vim.opt.shell = "pwsh.exe -NoLogo"
vim.opt.shellcmdflag =
"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.cmd([[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
       let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  ]])

-- Set a compatible clipboard manager
vim.g.clipboard = {
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
    },
}
-- NOTE: Neovim Options
local default_options = {
    backup         = false,         -- creates a backup file
    clipboard      = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight      = 1,             -- more space in the neovim command line for displaying messages
    cmdwinheight   = 1,
    completeopt    = { "menuone", "noselect" },
    conceallevel   = 0,        -- so that `` is visible in markdown files
    fileencoding   = "utf-8",  -- the encoding written to a file
    foldmethod     = "manual", -- folding, set to "expr" for treesitter based folding
    foldexpr       = "",       -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    hidden         = true,     -- required to keep multiple buffers and open multiple buffers
    hlsearch       = true,     -- highlight all matches on previous search pattern
    ignorecase     = true,     -- ignore case in search patterns
    mouse          = "a",      -- allow the mouse to be used in neovim
    showmode       = false,    -- we don't need to see things like -- INSERT -- anymore
    smartcase      = true,     -- smart case
    splitbelow     = true,     -- force all horizontal splits to go below current window
    splitright     = true,     -- force all vertical splits to go to the right of current window
    swapfile       = false,    -- creates a swapfile
    termguicolors  = true,     -- set term gui colors (most terminals support this)
    timeout        = true,
    timeoutlen     = 300,      -- time to wait for a mapped sequence to complete (in milliseconds)
    title          = true,     -- set the title of window to the value of the titlestring
    -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
    undofile       = true,     -- enable persistent undo
    updatetime     = 100,      -- faster completion
    writebackup    = false,    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab      = true,     -- convert tabs to spaces
    shiftwidth     = 4,        -- the number of spaces inserted for each indentation
    tabstop        = 4,        -- insert 2 spaces for a tab
    number         = true,     -- set numbered lines
    numberwidth    = 4,        -- set number column width to 2 {default 4}
    relativenumber = true,
    signcolumn     = "yes",    -- always show the sign column, otherwise it would shift the text each time
    scrolloff      = 8,        -- minimal number of screen lines to keep above and below the cursor.
    sidescrolloff  = 8,        -- minimal number of screen lines to keep left and right of the cursor.
    showcmd        = false,
    ruler          = false,
    laststatus     = 3,
    pumblend       = 10, -- Make builtin completion menus slightly transparent
    pumheight      = 10, -- Make popup menu smaller
    winblend       = 10, -- Make floating windows slightly transparent
    listchars      = 'tab:> ,extends:…,precedes:…,nbsp:␣', -- Define which helper symbols to show
    list           = true, -- Show some helper symbols
    cursorcolumn   = false,
    cursorline     = true,

    spell          = false,
    wrap           = true, -- display lines as one long line
}

for k, v in pairs(default_options) do
    vim.opt[k] = v
end

vim.g.mapleader = " "

---  SETTINGS  ---
vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append "c"   -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append "I"   -- don't show the default intro message
vim.opt.whichwrap:append "<,>,[,],h,l"

vim.filetype.add {
    extension = { tex = "tex", zir = "zir", cr = "crystal", },
    pattern = { ["[jt]sconfig.*.json"] = "jsonc", },
}

local icons = require('icons')
local default_diagnostic_config = {
    signs = {
        active = true,
        values = {
            { name = "DiagnosticSignError", text = icons.diagnostics.Error },
            { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
            { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
            { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
        },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(default_diagnostic_config)

-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(require("plugins").plugin_list)

-- adding lvim default keybinds
require('lvimKeyBinds')

-- Keybinding /lua/keybinds.lua
require('keybinds')

-- hilighters
require('colors')

-- vscode specific opts
if vim.g.vscode then
end


-- setting specific to NEOVIDE
if vim.g.neovide then
    vim.cmd(
        [[set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait1000-blinkoff500-blinkon500-Cursor/lCursor]]
    )
    -- vim.o.guifont = "JetBrainsMono Nerd Font Mono:h10.4"
    vim.o.guifont = "Iosevka Nerd Font Mono:h11"
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 4
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_vfx_mode = "wireframe"
    -- vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_particle_density = 10
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_underline_automatic_scaling = true
    vim.g.neovide_no_idle = false
    vim.g.neovide_cursor_unfocused_outline_width = 0.05
    vim.g.neovide_confirm_quit = true

    vim.g.neovide_transparency = 0.75
    vim.g.neovide_fullscreen = false

    vim.o.winblend = 50
    vim.o.pumblend = 20
end
