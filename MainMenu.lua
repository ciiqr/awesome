local powerMenu =
{
	-- {"Sleep",  putToSleep},
	{"Hybrid", "systemctl hybrid-sleep"},
	{"Hibernate", "sudo systemctl hibernate"},
	{"Logout", awesome.quit},
	{"Restart", "systemctl reboot"},
	{"Shutdown", "systemctl poweroff"}
}

-- TODO: Change to dynamic? Would be awesome but what about the ordering?....
local mountMenu =
{
	{"Personal",	PERSONAL_BIN.."mount-toggle/personal"},
	{"Media",		PERSONAL_BIN.."mount-toggle/media"},
	{"Desktop",		PERSONAL_BIN.."mount-toggle/desktop"},
	{"iPad",		PERSONAL_BIN.."mount-toggle/ipad"},
	-- {"Open-Tech",		PERSONAL_BIN.."mount-toggle/open-tech"},
	{"Data-Server",		PERSONAL_BIN.."mount-toggle/data-server"}
	-- TODO: The Rest
}
-- TODO: ? Change to generated, function which takes the display-name & ssh-args
local sshMenu = {
	{"Data-Server",	TERMINAL.." -e ".."ssh root@data-server -p 57251"},
	{"iPad" ,		TERMINAL.." -e ".."ssh root@iPad"},
	{"Router" ,		TERMINAL.." -e ".."ssh root@router"},
	{"Pi" ,			TERMINAL.." -e ".."ssh pi@192.168.1.100"},
	{"Desktop", 	TERMINAL.." -e ".."ssh desktop -p 57251"}
}
local vncMenu =
{
	{"Desktop", function() awful.util.spawn_with_shell("vncviewer -passwd ~/.vnc/desktop") end}
}
local hardwareMenu = 
{
	-- TODO: Could Generate all of these simply by using the display name appended to \PERSONAL_BIN.."toggle"\, should remove .py though
	{"Screen",		PERSONAL_BIN.."toggleDisplayBlanking.py"},
	{"Wifi",		PERSONAL_BIN.."toggleWifi.py"},
	{"Graphics",	PERSONAL_BIN.."toggleGraphics.py"},
	{"Bluetooth",	PERSONAL_BIN.."toggleBluetooth.py"},
	{"Mouse Keys",	PERSONAL_BIN.."toggleMouseKeys.py"},
	{"Notifications",	toggleNaughtyNotifications},
}
local mainMenu = awful.menu(
{
	items =
	{
		{"Power", powerMenu, beautiful.exit_icon},
		{"Mount", mountMenu},
		{"SSH", sshMenu},
		{"VNC", vncMenu},
		{"Hardware", hardwareMenu}
	},
	theme = 
	{
		width = 112
	}
})

return mainMenu