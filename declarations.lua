-- Directories
HOME_DIR = os.getenv("HOME")
ROOT_DIR = HOME_DIR .. "/.config/awesome/"

-- Theme
THEME_PATH = ROOT_DIR .. "theme"
THEME_FILE_PATH = THEME_PATH .. "/theme.lua"
THEME_BACKGROUNDS_PATH = THEME_PATH .. "/backgrounds"
PANEL_HEIGHT = 15
SPACER_SIZE = 14

-- Mode
DEBUG = true

-- Adjustment Values
-- TODO: Could list all devices in /sys/class/backlight/, maybe device/type can be used to exclude the improper one
-- TODO: When adjusting, if it would add up to over max or less than 0, adjust to those values
BRIGHTNESS_MAX = tonumber(readFile("/sys/class/backlight/intel_backlight/max_brightness"))
if BRIGHTNESS_MAX then
	BRIGHTNESS_CHANGE_NORMAL = roundi(BRIGHTNESS_MAX/10)
	BRIGHTNESS_CHANGE_SMALL = roundi(BRIGHTNESS_MAX/100)
else
	BRIGHTNESS_CHANGE_NORMAL = 0
	BRIGHTNESS_CHANGE_SMALL = 0
end
VOLUME_CHANGE_NORMAL = 10
VOLUME_CHANGE_SMALL = 1

-- Temperature Display
TEMPERATURE_UPDATE_INTERVAL = 10

-- Battery
BATTERY_PERCENT_LOW = 10
BATTERY_PERCENT_CRITICAL = 5

-- Programs
TERMINAL = "urxvt"
TERMINAL_EXEC = TERMINAL .. " -e "
FILE_MANAGER = "spacefm"
EDITOR = "sublime"
GRAPHICAL_SUDO = "gksudo"

-- Keys
SUPER = "Mod4"
ALT = "Mod1"
CONTROL = "Control"
SHIFT = "Shift"

-- Mouse Buttons
MOUSE_LEFT = 1
MOUSE_RIGHT = 3
MOUSE_SCROLL_UP = 4
MOUSE_SCROLL_DOWN = 5

-- Direction
FORWARDS = 1
BACKWARDS = -1

-- Tags
SCREEN_TAGS = {"➊","➋","➌","➍","➎","➏","➐","➑","➒"}

-- Commands
COMMAND_SLEEP = "systemctl suspend"
COMMAND_SCREEN_SHOT = "scrot ~/documents/Screens/%Y-%m-%d-%T-screen.png"
COMMAND_SCREEN_SHOT_SELECT = "gm import ~/Dropbox/Screenshots/$(date '+%Y-%m-%d-%T')-$(lsb_release -sc).png"
COMMAND_SCREEN_INVERT = "xcalib -i -a"
COMMAND_FILE_OPENER = "xdg-open \"$(locate \"\" | dmenu -y %s -i -p Open -l 20 -fn \"Nimbus Sans L-10\" -dim 0.75)\"" -- MUST Replace %s using string.format, with y Height -- -x 480 -w 960 -f
COMMAND_WINDOW_SWITCHER = "DMENU_OPTIONS='-y %s -i -p Open -l 20 -dim 0.75' FONT=\"Nimbus Sans L-10\" wmgo"
COMMAND_TASK_MANAGER_MEM = "sudo htop --delay 5 --sort-key PERCENT_MEM"
COMMAND_TASK_MANAGER_CPU = "sudo htop --delay 5 --sort-key PERCENT_CPU"
COMMAND_IS_RUNNING = "is-running"

-- Startup
STARTUP_PROGRAMS = {
	-- Awesome
	"compton" -- Composition Manager (Transparency, Inactive Window Dimming, Visual Glitch Fix)
	,"feh --randomize --bg-fill " .. THEME_BACKGROUNDS_PATH .. "/*" -- Random Background

	-- Daemons
	,FILE_MANAGER .. " -d"

	-- Launchers
	,"albert"

	-- Tray's
	,"redshift-gtk"
	,"nm-applet"
	,"dropbox start -i"
}

sublime_window_rules = {
	["awesome, lib"] = 7,
	["machines"] = 7,
}
