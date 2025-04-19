-- Enable powershell as your default shellini
vim.loader.enable()
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
    backup = false, -- creates a backup file
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard
    cmdheight = 0, -- more space in the neovim command line for displaying messages
    cmdwinheight = math.floor(vim.o.lines * 0.2),
    completeopt = { "menuone", "noselect" },
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    foldcolumn = "auto:1",
    foldenable = true,
    -- foldmethod = "manual",
    foldmethod = "expr", -- folding, set to "expr" for treesitter based folding / "manual"
    foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    foldlevel = 99,
    foldlevelstart = 99,
    foldnestmax = 10,
    foldminlines = 5,
    hidden = true, -- required to keep multiple buffers and open multiple buffers
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    mouse = "a", -- allow the mouse to be used in neovim
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    smartcase = true, -- smart case
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    termguicolors = true, -- set term gui colors (most terminals support this)
    timeout = true,
    timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
    -- title          = true,                         -- set the title of window to the value of the titlestring
    -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
    undofile = true, -- enable persistent undo
    updatetime = 500, -- faster completion
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true, -- convert tabs to spaces
    shiftwidth = 4, -- the number of spaces inserted for each indentation
    tabstop = 4, -- insert 2 spaces for a tab
    number = true, -- set numbered lines
    numberwidth = 4, -- set number column width to 2 {default 4}
    relativenumber = true,
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
    sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.
    showcmd = false,
    ruler = false,
    laststatus = 3,
    pumblend = 10, -- Make builtin completion menus slightly transparent
    pumheight = 10, -- Make popup menu smaller
    winblend = 10, -- Make floating windows slightly transparent
    listchars = "tab:› ,extends:…,precedes:…,nbsp:␣,space:⋅", -- Define which helper symbols to show 󱞥
    -- listchars      = 'tab:> ,extends:…,precedes:…,nbsp:␣,space:⋅,eol:󱞥', -- Define which helper symbols to show 󱞥
    -- listchars      = 'tab:> ,extends:…,precedes:…,nbsp:␣', -- Define which helper symbols to show
    list = true, -- Show some helper symbols
    cursorcolumn = false,
    cursorline = true,

    spell = false,
    wrap = true, -- display lines as one long line
    spelllang = { "en_us" },
}

if vim.g.vscode then
    default_options.cmdheight = 1
end

local function is_night()
    local now = os.date("*t")
    return not (now.hour >= 7 and now.hour < 18)
end

vim.g.autoload = not (vim.g.neovide or vim.g.vscode)
-- vim.g.autoload = true

local set_theme = function()
    if is_night() then
        vim.g.is_night = true
        vim.g.transparent = true
        vim.g.neovide_custom_color = false
        vim.g.neovide_colorscheme = "rose-pine-main"
        vim.g.colorscheme = "catppuccin"
    else
        vim.g.is_night = false
        vim.g.transparent = true
        vim.g.neovide_custom_color = false
        vim.g.neovide_colorscheme = "rose-pine-main"
        vim.g.colorscheme = "nordfox"
    end

    if vim.g.neovide or vim.g.transparent then
        vim.g.win_border = "none"
    else
        vim.g.win_border = "single"
    end
end

set_theme()

local timer = (vim.uv or vim.loop).new_timer()
timer:start(
    0,
    3600 * 1000,
    vim.schedule_wrap(function()
        set_theme()
    end)
)
vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = set_theme,
})

-- NOTE: -------------------------------------------------------------------------------------------------------
local lazy_opts = {
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { missing = true, colorscheme = { vim.g.colorscheme } },
    -- automatically check for plugin updates
    checker = { enabled = false, frequency = 3600 * 24 * 7 },
    rocks = {
        enabled = true,
        hererocks = true,
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false, -- get a notification when changes are found
    },
    performance = {
        rtp = {
            reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
            paths = {}, -- add any custom paths here that you want to includes in the rtp
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
}

-- loading neovim options
vim.g.mapleader = " "
if not vim.g.vscode then
    for k, v in pairs(default_options) do
        vim.opt[k] = v
    end

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.python3_host_prog = vim.fn.expand("$HOME/scoop/apps/python/current/python.exe")
    vim.o.guifont = "JetBrainsMono Nerd Font:h10:l"
    -- vim.o.guifont = "JetBrainsMono Nerd Font Mono:h10:sb"
    -- vim.o.guifont = "Iosevka Nerd Font Mono:h10.3"

    ---  SETTINGS  ---
    vim.g.maplocalleader = "\\"
    vim.opt.spelllang:append("cjk") -- disable spellchecking for asian characters (VIM algorithm does not support it)
    vim.opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
    vim.opt.shortmess:append("I") -- don't show the default intro message
    vim.opt.whichwrap:append("<,>,[,],h,l")

    vim.filetype.add({
        extension = { tex = "tex", zir = "zir", cr = "crystal", http = "http" },
        pattern = { ["[jt]sconfig.*.json"] = "jsonc" },
    })
end

-- NOTE: Use vim.fn.expand($HOME/path/to/file.exe) for providing path

-- setting specific to NEOVIDE
if vim.g.neovide then
    vim.cmd([[set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait1000-blinkoff500-blinkon500-Cursor/lCursor]])
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
    vim.g.neovide_no_idle = true
    vim.g.neovide_cursor_unfocused_outline_width = 0.05
    vim.g.neovide_confirm_quit = false
    vim.g.neovide_floating_shadow = false

    -- vim.g.neovide_transparency = 0.85
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_fullscreen = false

    default_options.winblend = 50
    default_options.pumblend = 20
    lazy_opts.install.colorscheme = { vim.g.neovide_colorscheme }
end

-- bootstrapping lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- loading plugins
require("lazy").setup(lazy_opts)

-- loading keybinding
require("local.keybinds")
require("local.lvimKeyBinds")

-- autocmd
require("autocmd")

if not vim.g.vscode then
    -- loading proper colorscheme
    vim.cmd("colorscheme " .. (vim.g.neovide and vim.g.neovide_colorscheme or vim.g.colorscheme))

    -- loading jq
    require("local.jq")

    -- loading custom colors
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("colors_aug", { clear = true }),
        callback = function(_)
            Snacks.notify("Custom colors applied")
            require("local.colors")
        end,
    })
    require("local.colors")

    -- loading coderunner
    require("local.codeRunner").setup({
        output_window_type = "floating", -- floating, pane, tab, split
        output_window_configs = {
            width = math.floor(vim.o.columns * 0.35),
            height = math.floor(vim.o.lines * 0.35),
            float = {
                width = math.floor(vim.o.columns * 0.7),
                height = math.floor(vim.o.lines * 0.7),
            },
            position = "center", -- Position of the floating window ("center", "top", "bottom", "left", "right", "custom")
            custom_col = nil,
            custom_row = nil,
            transparent = false,
        },
    })
end
