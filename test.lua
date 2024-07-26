-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.default_prog = { 'C:\\Tweeks\\nu\\nu.exe' }
config.default_cwd = "~"
config.color_scheme = 'nightfox'
config.adjust_window_size_when_changing_font_size = true
config.allow_square_glyphs_to_overflow_width = "Never"
config.animation_fps = 165
config.max_fps = 165
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.anti_alias_custom_block_glyphs = true
config.automatically_reload_config = true
config.font = wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Medium' })
config.font_size = 10
config.win32_system_backdrop = 'Tabbed'
-- config.win32_acrylic_accent_color = '#0000ff'
-- config.text_background_opacity = 0.1
config.window_background_opacity = 0
config.force_reverse_video_cursor = true
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.cursor_blink_rate = 800
config.cursor_thickness = 2
config.window_decorations = "RESIZE"
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = true
config.window_frame = {
    inactive_titlebar_bg = '#353535',
    active_titlebar_bg = '#2b2042',
    inactive_titlebar_fg = '#cccccc',
    active_titlebar_fg = '#ffffff',
    inactive_titlebar_border_bottom = '#2b2042',
    active_titlebar_border_bottom = '#2b2042',
    button_fg = '#cccccc',
    button_bg = '#2b2042',
    button_hover_fg = '#ffffff',
    button_hover_bg = '#3b3052',
}
config.colors = {
    tab_bar = {
        background = "rgba(0,0,0,0)",
        inactive_tab_edge = '#575757',
    },
}
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.tab_bar_at_bottom = false

config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

config.tab_bar_style = {
    -- active_tab_left = wezterm.format {
    --   { Background = { Color = '#0b0022' } },
    --   { Foreground = { Color = '#2b2042' } },
    --   { Text = SOLID_LEFT_ARROW },
    -- },

    -- active_tab_left = wezterm.format {
    --   { Background = { Color = '#0b0022' } },
    --   { Foreground = { Color = '#2b2042' } },
    --   { Text = SOLID_LEFT_ARROW },
    -- },
    -- active_tab_right = wezterm.format {
    --   { Background = { Color = '#0b0022' } },
    --   { Foreground = { Color = '#2b2042' } },
    --   { Text = SOLID_RIGHT_ARROW },
    -- },
    -- inactive_tab_left = wezterm.format {
    --   { Background = { Color = '#0b0022' } },
    --   { Foreground = { Color = '#1b1032' } },
    --   { Text = SOLID_LEFT_ARROW },
    -- },
    -- inactive_tab_right = wezterm.format {
    --   { Background = { Color = '#0b0022' } },
    --   { Foreground = { Color = '#1b1032' } },
    --   { Text = SOLID_RIGHT_ARROW },
    -- },
}

return config
