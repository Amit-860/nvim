-- Enable powershell as your default shell
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
  backup = false,            -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 1,             -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,          -- so that `` is visible in markdown files
  fileencoding = "utf-8",    -- the encoding written to a file
  foldmethod = "manual",     -- folding, set to "expr" for treesitter based folding
  foldexpr = "",             -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  hidden = true,             -- required to keep multiple buffers and open multiple buffers
  hlsearch = true,           -- highlight all matches on previous search pattern
  ignorecase = true,         -- ignore case in search patterns
  mouse = "a",               -- allow the mouse to be used in neovim
  pumheight = 10,            -- pop up menu height
  showmode = false,          -- we don't need to see things like -- INSERT -- anymore
  smartcase = true,          -- smart case
  splitbelow = true,         -- force all horizontal splits to go below current window
  splitright = true,         -- force all vertical splits to go to the right of current window
  swapfile = false,          -- creates a swapfile
  termguicolors = true,      -- set term gui colors (most terminals support this)
  timeoutlen = 1000,         -- time to wait for a mapped sequence to complete (in milliseconds)
  title = true,              -- set the title of window to the value of the titlestring
  -- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
  undofile = true,           -- enable persistent undo
  updatetime = 100,          -- faster completion
  writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,          -- convert tabs to spaces
  shiftwidth = 2,            -- the number of spaces inserted for each indentation
  tabstop = 2,               -- insert 2 spaces for a tab
  cursorline = true,         -- highlight the current line
  number = true,             -- set numbered lines
  numberwidth = 4,           -- set number column width to 2 {default 4}
  signcolumn = "yes",        -- always show the sign column, otherwise it would shift the text each time
  wrap = false,              -- display lines as one long line
  scrolloff = 8,             -- minimal number of screen lines to keep above and below the cursor.
  sidescrolloff = 8,         -- minimal number of screen lines to keep left and right of the cursor.
  showcmd = false,
  ruler = false,
  laststatus = 3,
}

vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.whichwrap:append "<,>,[,],h,l"

for k, v in pairs(default_options) do
  vim.opt[k] = v
end

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- plugins
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

-- plugins
require('plugins')

-- Keybinding /lua/keybinds.lua
require('keybinds')

if not vim.g.vscode then
  vim.cmd("colorscheme nightfox")
  vim.wo.relativenumber = true
  vim.o.cursorline = true
  vim.opt.cmdwinheight = 1
  vim.opt.cmdheight = 0
end
-- vim.cmd([[hi Pmenu gui=underline guifg=#bcbcbc guibg=#af5f5f ]])
vim.cmd([[hi Pmenu guibg=#131a25]])
