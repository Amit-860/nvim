return {
	{
		"nvim-telescope/telescope-project.nvim",
		event = "VeryLazy",
	},
	{
		"debugloop/telescope-undo.nvim",
		cmd = { "Telescope undo" },
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		event = "VeryLazy",
	},

	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			-- "nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-fzy-native.nvim",
		},
		opts = function()
			local icons = require("icons")
			local actions = require("telescope.actions")

			local telescope_opts = {
				---@usage disable telescope completely [not recommended]
				active = true,
				on_config_done = nil,
				-- theme = "dropdown", ---@type telescope_themes
				defaults = {
					prompt_prefix = icons.ui.Telescope .. " ",
					selection_caret = icons.ui.RightTriangle .. " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = nil,
					layout_strategy = nil,
					layout_config = {},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!.git/",
					},
					---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
					mappings = {
						i = {
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<C-j>"] = actions.cycle_history_next,
							["<C-k>"] = actions.cycle_history_prev,
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
							["<CR>"] = actions.select_default,
						},
						n = {
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
							["q"] = actions.close,
						},
					},
					file_ignore_patterns = {},
					path_display = { "smart" },
					winblend = 0,
					-- border = {},
					-- borderchars = nil,
					borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
					color_devicons = true,
					set_env = {
						["COLORTERM"] = "truecolor",
					}, -- default = nil,
				},
				pickers = {
					find_files = {
						initial_mode = "insert",
						hidden = true,
						previewer = true,
					},
					live_grep = {
						-- @usage don't include the filename in the search results
						initial_mode = "insert",
						only_sort_text = true,
						previewer = true,
					},
					grep_string = {
						initial_mode = "insert",
						only_sort_text = true,
						previewer = true,
					},
					buffers = {
						initial_mode = "insert",
						theme = "dropdown",
						previewer = false,
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
							n = {
								["dd"] = actions.delete_buffer,
							},
						},
					},
					planets = {
						show_pluto = true,
						show_moon = true,
					},
					git_files = {
						hidden = true,
						show_untracked = true,
						previewer = true,
					},
					colorscheme = {
						enable_preview = true,
					},
					spell_suggest = {
						theme = "cursor",
						initial_mode = "normal",
					},
				},
				extensions = {
					["ui-select"] = {
						-- require("telescope.themes").get_dropdown { }
						require("telescope.themes").get_cursor({
							initial_mode = "normal",
						}),
					},
					undo = {
						use_delta = false,
						-- use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
						layout_strategy = "vertical",
						layout_config = {
							preview_height = 0.6,
						},
						vim_diff_opts = { ctxlen = 8 },
						entry_format = "state #$ID, $STAT, $TIME",
						time_format = "",
						initial_mode = "normal",
						mappings = {
							i = {
								["<c-Y>"] = require("telescope-undo.actions").yank_additions,
								["<c-y>"] = require("telescope-undo.actions").yank_deletions,
								["<c-cr>"] = require("telescope-undo.actions").restore,
							},
							n = {
								["Y"] = require("telescope-undo.actions").yank_additions,
								["y"] = require("telescope-undo.actions").yank_deletions,
								["<cr>"] = require("telescope-undo.actions").restore,
							},
						},
					},
					project = {
						base_dirs = {},
						hidden_files = true, -- default: false
						theme = "dropdown",
						order_by = "recent",
						search_by = { "title", "path" },
						initial_mode = "insert",
						sync_with_nvim_tree = false, -- default false
						-- default for on_project_selected = find project files
						on_project_selected = function(prompt_bufnr)
							-- Do anything you want in here. For example:
							local project_actions = require("telescope._extensions.project.actions")
							project_actions.change_working_directory(prompt_bufnr, false)
						end,
					},
					frecency = {
						matcher = "fuzzy",
						path_display = { "shorten" },
						ignore_patterns = { [[*.git\*]], [[*\tmp\*]], "term:*" },
						ignore_register = function(bufnr)
							return not vim.bo[bufnr].buflisted
						end,
					},
				},
			}

			if vim.g.neovide then
				telescope_opts.defaults.winblend = 75
			end

			return telescope_opts
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzy_native")
			-- telescope.load_extension("ui-select")
			telescope.load_extension("undo")
			telescope.load_extension("project")
			telescope.load_extension("noice")
			telescope.load_extension("grapple")
			telescope.load_extension("frecency")
		end,
	},
}
