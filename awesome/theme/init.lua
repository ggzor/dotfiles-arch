local colors = require('theme.colors')

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local theme = { colors = colors }

theme.wallpaper = "~/Pictures/wallpapers/solid.png"

-- Fonts
local base_font  = "JetBrainsMono Nerd Font"
theme.font       = base_font.." 10"
theme.font_large = base_font.." 16"

-- Special vars
theme.floating = {}
theme.floating.width_factor = 0.4
theme.floating.height_factor = 0.8
theme.floating.min_width = 800
theme.floating.min_height = 600

-- Borders
theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = colors.bg
theme.border_focus  = colors.blue
theme.border_marked = colors.red

-- Colors
theme.bg_normal   = colors.bg
theme.bg_focus    = colors.fg40
theme.bg_urgent   = colors.red40
theme.bg_systray  = colors.bg
theme.bg_minimize = colors.bg

theme.fg_normal   = colors.fg
theme.fg_focus    = colors.fg
theme.fg_urgent   = colors.fg
theme.fg_minimize = colors.fg

-- Hotkeys
theme.hotkeys_bg = colors.bg
theme.hotkeys_fg = colors.fg
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_border_color = colors.red
theme.hotkeys_modifiers_fg = colors.blue
theme.hotkeys_label_bg = colors.fg
theme.hotkeys_label_fg = colors.fg
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_group_margin = dpi(30)

-- Snap
theme.snap_bg = colors.red
theme.snap_shape = require('gears.shape').rectangle

-- Taglist squares
local theme_assets = beautiful.theme_assets
local taglist_square_size = dpi(3)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- Submenus
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
theme.menu_submenu_icon = themes_path.."default/submenu.png"

-- Layout icons
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

return theme

