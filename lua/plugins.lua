require("lazy").setup({
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
      require('pluginSetups.lspConfig')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local ts_opts = require('pluginSetups.treeSitterConfig')
      require 'nvim-treesitter.configs'.setup(ts_opts)
    end
  },
  {
    "windwp/nvim-ts-autotag",
    cond = not vim.g.vscode,
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { default = { "class", "function", "method" } },
      })
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "wellle/targets.vim" },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    Lazy = 'VeryLazy',
    opts = {},
  },
  { "tpope/vim-repeat" },
  {
    "drybalka/tree-climber.nvim",
    event = "BufRead",
    config = function()
      vim.keymap.set({ "n", "v", "o" }, "r",
        require("tree-climber").goto_next,
        { noremap = true, silent = true, desc = "Next Block" }
      )
      vim.keymap.set({ "n", "v", "o" }, "R",
        require("tree-climber").goto_prev,
        { noremap = true, silent = true, desc = "Prev Block" }
      )
      vim.keymap.set({ "n", "v", "o" }, "]r",
        require("tree-climber").goto_child,
        { noremap = true, silent = true, desc = "Goto Child Block" }
      )
      vim.keymap.set({ "n", "v", "o" }, "[R",
        require("tree-climber").goto_parent,
        { noremap = true, silent = true, desc = "Goto Parent Block" }
      )
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    opts = {
      modes = {
        char = { jump_labels = true },
        search = { enabled = false }
      },

    },
    keys = {
      {
        "s", mode = { "n", "x", "o" }, function() require("flash").jump({}) end, desc = "Flash"
      },
      {
        "<M-s>",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end,
        desc = "Flash Treesitter"
      },
      {
        "<M-/>", mode = { "n" }, function() require("flash").toggle() end, desc = "Toggle Flash Search"
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    opts = { skipInsignificantPunctuation = true }
  },
  {
    "monaqa/dial.nvim",
    event = "BufRead",
    keys = {
      { "<C-a>",  "<Plug>(dial-increment)",  mode = { "n", "v" }, remap = true },
      { "<C-x>",  "<Plug>(dial-decrement)",  mode = { "n", "v" }, remap = true },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = { "n", "v" }, remap = true },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "n", "v" }, remap = true },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,                                                                    -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex,                                                                        -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.constant.alias.bool,                                                                      -- boolean value (true <-> false)
          augend.date.alias["%Y/%m/%d"],                                                                   -- date (2022/02/18, etc.)
          augend.date.alias["%m/%d/%Y"],                                                                   -- date (02/19/2022)
          augend.date.new { pattern = "%m-%d-%Y", default_kind = "day", only_valid = true, word = false }, -- date (02-19-2022)
          augend.date.new { pattern = "%Y-%m-%d", default_kind = "day", only_valid = true, word = false }, -- date (02-19-2022)
          augend.date.new({ pattern = "%m.%d.%Y", default_kind = "day", only_valid = true, word = false, }),
          augend.constant.new { elements = { "&&", "||" }, word = false, cyclic = true, },
          augend.constant.new { elements = { '>', '<' }, word = false, cyclic = true, },
          augend.constant.new { elements = { '==', '!=', }, word = false, cyclic = true, },
          augend.constant.new { elements = { '===', '!==' }, word = false, cyclic = true, },
          augend.constant.new { elements = { 'True', 'False' }, word = false, cyclic = true, },
          augend.constant.new { elements = { 'and', 'or', 'not' }, word = false, cyclic = true, },
        },
      })
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
  },
  {
    "max397574/better-escape.nvim",
    cond = not vim.g.vscode,
    config = function()
      require("better_escape").setup({
        mapping = { "jk" },        -- a table with mappings to use
        timeout = 500,             -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>",            -- keys used for escaping, if it is a function will use the result everytime
      })
    end,
  },
  {
    'echasnovski/mini.nvim',
    cond = not vim.g.vscode,
    config = function()
      require('pluginSetups.miniConfig')
    end
  },
  {
    "AgusDOLARD/backout.nvim",
    event = "BufRead",
    opts = {
      chars = "(){}[]`'\"<>" -- default chars
    },
    keys = {
      -- Define your keybinds
      { "<M-h>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "n" } },
      { "<M-l>", "<cmd>lua require('backout').out()<cr>",  mode = { "i", "n" } },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "LspAttach",
    config = function()
      local slow_format_filetypes = {}
      require("conform").setup({
        formatters_by_ft = {
          python = { "isort", "black", },
          scss = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          yaml = { "prettier" },
          json = { "prettier" },
          toml = { "prettier" },
          javascript = { "biome" },
          javascriptreact = { "biome" },
          typescript = { "biome" },
          typescriptreact = { "biome" },
          -- ["*"] = { "codespell" },
          ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end
          return { timeout_ms = 1000, lsp_fallback = true }, on_format
        end,
        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
      })
    end,
  },
  {
    "kawre/leetcode.nvim",
    lazy = true,
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      lang = "python3"
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "CRAG666/code_runner.nvim",
    cmd = { 'RunFile', 'RunCode', 'RunProject', 'RunClose' },
    config = true,
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    event = "LspAttach",
  },
  {
    'hrsh7th/cmp-buffer',
    event = "LspAttach",
  },
  {
    'hrsh7th/cmp-path',
    event = "LspAttach",
  },
  {
    'hrsh7th/cmp-cmdline',
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require('pluginSetups.cmpConfig')
    end
  },
  {
    "L3MON4D3/LuaSnip",

    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    event = "LspAttach",
    config = function()
      require("luasnip").setup()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  { "onsails/lspkind.nvim" },
  {
    "nanotee/zoxide.vim",
    cmd = { "Z" }
  },
  {
    "nvim-telescope/telescope.nvim",
  },
  {
    "gbrlsnchs/telescope-lsp-handlers.nvim",
    event = "LspAttach"
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "debugloop/telescope-undo.nvim",
  },
  {
    "vigoux/notifier.nvim",
    opts = {},
  },
  opts = { checker = { frequency = 604800, } }
})
