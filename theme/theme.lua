-------------------------------
-- Custom Theme for Awesome WM
--
-- William Villeneuve
--
-- Alternative icon sets and widget icons:
-- http://awesome.naquadah.org/wiki/Nice_Icons

-- Overriding the defaults:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- theme.taglist_bg_focus = "#CC9393"


-- To TRY
-- 6E533F


-- Variables --
--===========--
local theme = {}
local themePath = CONFIG_DIR..THEME_NAME.."/"

-- theme.wallpaper = themePath .. "Background.jpg"
-- BAR_TRANSPARENCY = true

-- Styles --
--========--
theme.font      = "sans 10"
-- theme.font_bold = "sans bold 10"


-- Colors --
--========--
local lightColour = "#DE7712"
	--97281C - Red
	--DE7712 - Orange
	--F4E210 - Yellow
	--3F923A - Green
	--218fbd - Blue
	--8512DE - Purple

	--92803A - Natural
	--23CDC0 - Sea
	--f08080 - Calm
	--FFC629 - Red, Yellow Highlights
local darkColour = "#C96508"
	--581109 - Red
	--C96508 - Orange
	--bf7900 - Yellow
	--22511F - Green
	--005577 - Blue
	--3F175E - Purple

	--453D1C - Natural
	--EDC9AF - Sea
	--68838b - Calm *
	--5A0000 - Red, Yellow Highlights
local white = "#FFFFFF"
local black = "#000000"
local paleYellow = "#DCDCCC" -- Almost White
local lightRed = "#CD2323"
local darkGrey = "#3F3F3F"
local slightlyLighterGrey = "#424242" -- Matches GTK Theme

-- Default
theme.fg_normal  = paleYellow -- Normal Text Colour
theme.fg_focus   = lightColour --"#F0DFAF"
theme.fg_urgent  = lightRed

theme.bg_normal  = black..ternary(BAR_TRANSPARENCY, "00", "7e")
theme.bg_focus   = "#222222"..ternary(BAR_TRANSPARENCY, "00", "FF") --222222ee--theme.bg_focus   = theme.bg_normal--"#66666677"
theme.bg_urgent  = darkGrey

-- Borders
theme.border_width  = 2
theme.border_normal = darkGrey
theme.border_focus  = darkColour
theme.border_marked = lightRed

-- Titlebars
theme.titlebar_bg_focus  = darkColour
theme.titlebar_fg_focus = white
-- theme.titlebar_bg_focus  = slightlyLighterGrey
-- theme.titlebar_bg_normal = darkGrey
-- theme.titlebar_fg_focus = lightColour

-- Tasklist
theme.tasklist_bg_focus = darkColour
theme.tasklist_fg_normal = white
theme.tasklist_fg_focus = white

-- TagList
theme.taglist_fg_focus = lightColour

-- System Tray
theme.bg_systray = ternary(BAR_TRANSPARENCY, "#2b2726", black) -- bg_normal

-- Mouse finder
-- mouse_finder_[timeout|animate_timeout|radius|factor]
theme.mouse_finder_color = lightRed


-- Menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_fg_focus = lightColour
theme.menu_bg_normal = black
theme.menu_bg_focus = black
theme.menu_border_color = darkColour
theme.menu_height = 15
theme.menu_width  = 500
theme.menu_border_width = 1

-- Awesompd
theme.awesompd_bg_normal = black


-- Icons --
--=======--
-- Taglist
theme.taglist_squares_sel   = themePath .. "taglist/squarefz.png"
theme.taglist_squares_unsel = themePath .. "taglist/squarez.png"
theme.taglist_squares_resize = "true"

-- Menu & Awesome Button
theme.awesome_icon = themePath .. "awesome-icon.png"
theme.arch_icon = themePath .. "arch-icon.png"--"/home/william/Downloads/arch start buttons by gabriela2400/start-here lp blue2.tif"
theme.exit_icon = themePath .. "exit.png"

theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"

-- Layout
theme.layout_tile       = themePath .. "layouts/tile.png"
theme.layout_tileleft   = themePath .. "layouts/tileleft.png"
theme.layout_tilebottom = themePath .. "layouts/tilebottom.png"
theme.layout_tiletop    = themePath .. "layouts/tiletop.png"
theme.layout_fairv      = themePath .. "layouts/fairv.png"
theme.layout_fairh      = themePath .. "layouts/fairh.png"
theme.layout_spiral     = themePath .. "layouts/spiral.png"
theme.layout_dwindle    = themePath .. "layouts/dwindle.png"
theme.layout_max        = themePath .. "layouts/max.png"
theme.layout_fullscreen = themePath .. "layouts/fullscreen.png"
theme.layout_magnifier  = themePath .. "layouts/magnifier.png"
theme.layout_floating   = themePath .. "layouts/floating.png"

-- Titlebar
theme.titlebar_close_button_focus  = themePath .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = themePath .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = themePath .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themePath .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themePath .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themePath .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themePath .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themePath .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themePath .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themePath .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themePath .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themePath .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themePath .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themePath .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themePath .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themePath .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themePath .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themePath .. "titlebar/maximized_normal_inactive.png"

-- Exit & Return Module
return theme
