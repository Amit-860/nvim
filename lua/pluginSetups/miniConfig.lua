local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    -- { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- clues
    -- clues = {
    --   { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
    --   { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    -- },

  },
  clues = {
    function() miniclue.gen_clues.g() end,
    function() miniclue.gen_clues.builtin_completion() end,
    function() miniclue.gen_clues.marks() end,
    function() miniclue.gen_clues.registers() end,
    function() miniclue.gen_clues.windows() end,
    function() miniclue.gen_clues.z() end,
  },
  window = {
    delay = 0,
    config = { width = 'auto', border = 'single', },
  },
})

require('mini.ai').setup()
require('mini.align').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.files').setup()
require('mini.indentscope').setup()
require('mini.map').setup()
-- require('mini.move').setup()
require('mini.pairs').setup()
-- require('mini.pick').setup()
require('mini.sessions').setup({ directory = ('%s%ssession'):format(vim.fn.stdpath('data'), '/'), autowrite = true })
require('mini.splitjoin').setup()

local starter = require("mini.starter")
local pad = string.rep(" ", 0)
local new_section = function(name, action, section)
  return { name = name, action = action, section = pad .. section }
end
starter.setup({
  evaluate_single = true,
  header =
  "███╗   ███╗██╗   ██╗██╗███╗   ███╗\n████╗ ████║██║   ██║██║████╗ ████║\n██╔████╔██║██║   ██║██║██╔████╔██║\n██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║\n██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║\n╚═╝     ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝\n                                  ",
  items = {
    -- sessions
    starter.sections.sessions(5, true),

    -- telescope
    new_section("Find file", "Telescope find_files", "Telescope"),
    new_section("Recent files", "Telescope oldfiles", "Telescope"),
    new_section("Grep text", "Telescope live_grep", "Telescope"),

    -- leetcode
    new_section("Leet", "Leet", "LeetCode"),

    -- config
    new_section("Configs", [[edit ~/AppData/Local/nvim/init.lua]], "Nvim"),
    new_section("Plugins", [[edit ~/AppData/Local/nvim/lua/plugins.lua]], "Nvim"),
    new_section("Keybinds", [[edit ~/AppData/Local/nvim/lua/keybinds.lua]], "Nvim"),

    -- Built-ins
    new_section("New file", "ene | startinsert", "Built-in"),
    new_section("Quit", "qa", "Built-in"),
  },
  -- content_hooks = {
  --   starter.gen_hook.adding_bullet(pad .. "░ ", false),
  --   starter.gen_hook.aligning("center", "center"),
  -- },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    -- starter.gen_hook.indexing('all', { 'Builtin actions' }),
    starter.gen_hook.aligning("center", "center"),
    starter.gen_hook.padding(3, 2),
  },
})

require('mini.statusline').setup()
-- require('mini.surround').setup()
require('mini.tabline').setup()
-- require('mini.completion').setup()
require('mini.basics').setup({
  options = { extra_ui = true, win_borders = 'double', },
  mappings = { windows = true, }
})
-- require('mini.extra').setup()
