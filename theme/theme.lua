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
-- theme.taglist_bg_focus = "#CC9393"f


-- To TRY
-- 6E533F

-- TODO: Is there a way we can set theme settings like this per-screen and update them as appropriate (when windows change screen for example, blah...)
-- TODO: Also have a function for this, and also use it in rc.lua
xresources  = require("beautiful.xresources");
local dpi = xresources.apply_dpi
local scale_factor = dpi(1)
local scale_factor_path = ""
if scale_factor ~= 1 then
    scale_factor_path = "@"..scale_factor.."x"
end

-- Variables --
--===========--
local theme = {}
-- theme.wallpaper = THEME_PATH .. "/Background.jpg"
-- BAR_TRANSPARENCY = true

-- Styles --
--========--
theme.font      = "DejaVu Sans Book 9" -- Roboto 9
-- theme.font_bold = "sans bold 10"


-- Colors --
--========--
-- TODO: Clean this up so we can define entire colour schemes at a time instead of having to manually select the light and dark colour separately... We should just have it be something that overrides the current settings in the theme variable, so we can override whatever...
local currentScheme = "blue, yellow highlights"
local colourSchemes = {
    ["red"] = {
        lightColour = "#97281C",
        darkColour = "#581109",
    },
    ["orange"] = {
        lightColour = "#DE7712",
        darkColour = "#C96508",
    },
    ["yellow"] = {
        lightColour = "#F4E210",
        darkColour = "#bf7900",
    },
    ["green"] = {
        lightColour = "#3F923A",
        darkColour = "#22511F",
    },
    ["blue"] = {
        lightColour = "#218fbd",
        darkColour = "#005577",
    },
    ["purple"] = {
        lightColour = "#8512DE",
        darkColour = "#3F175E",
    },
    ["natural"] = {
        lightColour = "#92803A",
        darkColour = "#453D1C",
    },
    ["sea"] = {
        lightColour = "#23CDC0",
        darkColour = "#EDC9AF",
    },
    ["calm"] = {
        lightColour = "#f08080",
        darkColour = "#68838b",
    },
    ["red, yellow highlights"] = {
        lightColour = "#FFC629",
        darkColour = "#5A0000",
    },
    ["blue, yellow highlights"] = {
        lightColour = "#FFC629",
        darkColour = "#68838b",
    },
}
local scheme = colourSchemes[currentScheme] or {}
local lightColour = scheme.lightColour or "#97281C"
local darkColour = scheme.darkColour or "#581109"
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
theme.border_width  = dpi(2)
theme.border_normal = darkGrey
theme.border_focus  = darkColour
theme.border_marked = lightRed

-- Tasklist
-- theme.tasklist_font = theme.font
theme.tasklist_bg_focus = darkColour
theme.tasklist_fg_normal = white
theme.tasklist_fg_focus = black

-- TagList
theme.taglist_fg_focus = lightColour
-- TODO: If I ever switch to a 1..2 px high bar, use this to show a colour on the selected tag even if there arn't any windows: theme.taglist_bg_focus = "#888888"

-- System Tray
theme.bg_systray = ternary(BAR_TRANSPARENCY, "#2b2726", black) -- bg_normal


-- Icons --
--=======--
-- Taglist
theme.taglist_squares_sel   = THEME_PATH .. "/taglist/squarefz-double-height"..scale_factor_path..".png"
theme.taglist_squares_unsel = THEME_PATH .. "/taglist/squarez"..scale_factor_path..".png"
theme.taglist_squares_resize = "true"

-- Layout
local themePathLayouts  = THEME_PATH .. "/layouts/"
theme.layout_tile       = themePathLayouts .. "tile.png"
theme.layout_fairv      = themePathLayouts .. "fairv.png"
theme.layout_fairh      = themePathLayouts .. "fairh.png"
theme.layout_max        = themePathLayouts .. "max.png"
theme.layout_floating   = themePathLayouts .. "floating.png"
theme.layout_thrizen    = themePathLayouts .. "thrizen.png"

-- Exit & Return Module
return theme

-- Old Awesome Button icon was from "arch start buttons by gabriela2400"
