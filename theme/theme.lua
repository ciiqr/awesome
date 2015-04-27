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
theme.font      = "DejaVu Sans Book 9"
-- theme.font_bold = "sans bold 10"


-- Colors --
--========--
local lightColour = "#FFC629"
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
local darkColour = "#5A0000"
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

-- Layout
local themePathLayouts	= themePath .. "layouts/"
theme.layout_tile       = themePathLayouts .. "tile.png"
theme.layout_fairv      = themePathLayouts .. "fairv.png"
theme.layout_fairh      = themePathLayouts .. "fairh.png"
theme.layout_max        = themePathLayouts .. "max.png"
theme.layout_floating   = themePathLayouts .. "floating.png"

-- Exit & Return Module
return theme

-- Old Awesome Button icon was from "arch start buttons by gabriela2400"
