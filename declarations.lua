-- Directories
HOME_DIR = os.getenv("HOME")
-- USER = os.getenv("USER")
CONFIG_DIR = HOME_DIR.."/.config/awesome/"
-- PERSONAL_BIN = HOME_DIR.."/.local/bin/"

-- Theme
THEME_NAME = "theme"
THEME_PATH = CONFIG_DIR..THEME_NAME.."/"
THEME_FILE_PATH = THEME_PATH.."theme.lua"
PANEL_HEIGHT = 15
SPACER_SIZE = 14

-- Mode
DEBUG = true

-- Adjustment Values
-- TODO: Could list all devices in /sys/class/backlight/, maybe device/type can be used to exclude the improper one
-- TODO: When adjusting, if it would add up to over max or less than 0, adjust to those values
-- TODO: Only do this is there is a backlight (and only setup keybindings if these exist...)
BRIGHTNESS_MAX = tonumber(readFile("/sys/class/backlight/intel_backlight/max_brightness"))
BRIGHTNESS_CHANGE_NORMAL = roundi(BRIGHTNESS_MAX/10)
BRIGHTNESS_CHANGE_SMALL = roundi(BRIGHTNESS_MAX/100)
VOLUME_CHANGE_NORMAL = 10
VOLUME_CHANGE_SMALL = 1

-- Temperature Display
TEMPERATURE_UPDATE_INTERVAL = 10

-- Battery
BATTERY_PERCENT_LOW = 10
BATTERY_PERCENT_CRITICAL = 5

-- Programs
TERMINAL = "rxvt-unicode"
TERMINAL_EXEC = TERMINAL.." -e "
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
COMMAND_SCREEN_SHOT_SELECT = "gm import ~/documents/Screens/%Y-%m-%d-%T-screen.png"
COMMAND_SCREEN_INVERT = "xcalib -i -a"
COMMAND_FILE_OPENER = "xdg-open \"$(locate \"\" | dmenu -y %s -i -p Open -l 20 -fn \"Nimbus Sans L-10\" -dim 0.75)\"" -- MUST Replace %s using string.format, with y Height -- -x 480 -w 960 -f
COMMAND_WINDOW_SWITCHER = "DMENU_OPTIONS='-y %s -i -p Open -l 20 -dim 0.75' FONT=\"Nimbus Sans L-10\" wmgo"
COMMAND_TASK_MANAGER_MEM = "sudo htop --delay 5 -s PERCENT_MEM"
COMMAND_TASK_MANAGER_CPU = "sudo htop --delay 5 -s PERCENT_CPU"
-- COMMAND_LAUNCHER = "quick-launch-py -y %s" -- TODO: Remove when I'm happy
COMMAND_LAUNCHER = "quick-launch --plugins=Applications -y %s 2>/dev/null"
-- TODO: These things should be based on the screen size...
COMMAND_LAUNCHER_ALTERNATE = "quick-launch --plugins=Applications -y %s -x 760 -w 400 -h 540 --orientation=v 2>/dev/null"
COMMAND_LAUNCHER_MENU = "quick-launch --plugins=Commands -y %s -x 1520 -w 800 -h 1080 --orientation=v 2>/dev/null"
COMMAND_IS_RUNNING = "is-running"

-- Startup
STARTUP_PROGRAMS = {
	-- Awesome
	-- ,"wmname Sawfish"			-- wmname LG3D|Sawfish: Fix Java Issues, HOWEVER it causes issues with chrome/chromium, and chrome will always be more important so until I have a good alternative it is being disabled, (NOTE: I Can probably just change what WM it imitates)
	-- ,"xcompmgr"				-- Composition Manager (Transparency)
	"pa-server.py" -- Updates volume widget when volume changes
	,"compton" -- Composition Manager (Transparency, Inactive Window Dimming, Visual Glitch Fix)
	,"feh --randomize --bg-fill "..THEME_PATH.."backgrounds/*" -- Random Background
	,"sudo bash ~/documents/Commands/appleKeyboard" -- TODO: This should be moved...
	
	-- System
	-- ,"sudo seaf-cli start"		-- Seafile Files Syncer (Root)

	-- Daemons
	-- ,"synergyc 192.168.1.102"-- Share Mouse & Keyboard with Desktop
	,FILE_MANAGER.." -d"

	-- Tray's
	,"redshift-gtk"
	,"nm-applet"
	,"dropbox start -i"
	-- ,"keepass"
	-- ,"seafile-applet"
	-- ,"system-config-printer-applet"

}

sublime_window_rules = {
	["awesome, lib"] = 7,
	["machines"] = 7,
}
