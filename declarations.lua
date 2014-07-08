-- User
HOME_DIR = os.getenv("HOME")
CONFIG_DIR = HOME_DIR.."/.config/awesome/"

THEME_NAME = "theme"
THEME_PATH = CONFIG_DIR..THEME_NAME.."/theme.lua"

-- Device
IS_LAPTOP = true

-- Programs
TERMINAL="xterm -rv"
TERMINAL_EXEC=TERMINAL.." -e "
FILE_MANAGER="spacefm"
EDITOR="subl3"
EDITOR_CMD=TERMINAL_EXEC..EDITOR

--Keys
SUPER="Mod4"
ALT="Mod1"
CONTROL="Control"
SHIFT="Shift"
--Widget
local PROMPT_BASE = "| %s: "
LUA_PROMPT = string.format(PROMPT_BASE, "Lua")
RUN_PROMPT = string.format(PROMPT_BASE, "Run")

-- Commands
COMMAND_SLEEP = "systemctl suspend"
COMMAND_SCREEN_SHOT = "scrot ~/Random/Screens/%Y-%m-%d-%T-screen.png"
COMMAND_SCREEN_SHOT_SELECT = "import ~/Random/Screens/%Y-%m-%d-%T-screen.png"
COMMAND_SCREEN_INVERT = "xcalib -i -a"
-- MUST Replace %s using string.format, with y Height -- -x 480 -w 960 -f
COMMAND_FILE_OPENER = "xdg-open \"$(locate \"\" | dmenu -y %s -i -p Open -l 20 -fn \"Nimbus Sans L-10\" -dim 0.75)\""
-- COMMAND_LAUNCHER_ALTERNATIVE  = "j4-dmenu-desktop --dmenu=\"dmenu -fn 'DejaVu Sans-10' -y 22 -i\"" -- -l 20
COMMAND_TASK_MANAGER_MEM = "sudo htop -s PERCENT_MEM"
COMMAND_TASK_MANAGER_CPU = "sudo htop -s PERCENT_CPU"
PERSONAL_BIN = HOME_DIR.."/.local/bin/"
COMMAND_LAUNCHER = "/home/william/Programming/Python/Projects/QuickLaunch/".."QuickLaunch.py" -- TODO: Change back COMMAND_LAUNCHER = PERSONAL_BIN.."quick-launch"

STARTUP_PROGRAMS = {
	"sudo seaf-cli start",		-- Seafile Files Syncer (Root)
	-- "wmname LG3D",			-- wmname LG3D: Fix Java Issues, HOWEVER it causes issues with chrome/chromium, and chrome will always be more important so untill I have a good alternative it is being disabled, (NOTE: I Can probably just change what WM it immitates)
	-- "xcompmgr",				-- Composition Manager (Transparency)
	"compton --config ~/.compton.conf", -- Composition Manager (Transparency, Inactive Window Dimming, Visual Glitch Fix)
	"feh --randomize --bg-fill "..CONFIG_DIR..THEME_NAME.."/backgrounds/*", -- Random Background

	-- VMWare (Systemd Doesnt seem to like these guys, at least some of them are not running automatically
	"sudo systemctl start vmware-usb vmware-vmci vmware-vmnet vmware-vmsock vmware-vmmon vmware-usbarbitrator",

	-- "synergyc 192.168.1.102",-- Share Mouse & Keyboard with Desktop
	-- "xkbset m",				-- Mouse Keys
	FILE_MANAGER.." -d",	-- File Manager

	"skype",
	"dropboxd",

	-- "system-config-printer-applet", -- Printer Applet
	
	-- "seafile-applet",		-- Seafile Files Syncer
	"redshiftgui --min",	-- Orange Screen at Night
	"nm-applet"				-- Wireless

	-- Issues with run once
	-- awful.util.spawn_with_shell("(ksuperkey -e 'Super_L=Alt_L|F1;Super_R=Alt_L|F1' &)")
	-- "ksuperkey -e 'Super_L=Alt_L|F1;Super_R=Alt_L|F1'" -- Release Mod Keys to open application menu
}
