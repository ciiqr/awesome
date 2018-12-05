local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local inspect = require("third-party.inspect") -- TODO: luarocks instead?
local popup = require("utils.popup")
local widgetManager = require("widgets.manager")

-- Client
-- TODO: Determine if I can make the window adjust when the screen's working area changes, add listener when fullscreen, remove when not
function toggleClientMultiFullscreen(c)
     c.floating = not c.floating
     if c.floating then
         local clientX = screen[1].workarea.x
         local clientY = screen[1].workarea.y
         local clientWidth = 0
         -- look at http://www.rpm.org/api/4.4.2.2/llimits_8h-source.html
         local clientHeight = 2147483640
         for s in screen do
             clientHeight = math.min(clientHeight, s.workarea.height)
             clientWidth = clientWidth + s.workarea.width
         end
         c.border_width = 0
         local t = c:geometry({x = clientX, y = clientY, width = clientWidth, height = clientHeight})
     else
        c.border_width = beautiful.border_width
        --apply the rules to this client so he can return to the right tag if there is a rule for that.
        awful.rules.apply(c)
     end
     -- focus our client
     client.focus = c
end

function debugClient(c)
    -- Window Info
    -- notify_send("size_hints: "..inspect(c.size_hints))

    debug_print("name: " .. (c.name or "null"))
    debug_print("class: " .. (c.class or "null"))
    debug_print("role: " .. (c.role or "null"))
    debug_print("type: " .. (c.type or "null"))
    if c.transient_for then
        name = c.transient_for.name or "null"
        debug_print("transient for: " .. inspect(name))
    end
    -- debug_print("type: " .. inspect(c.type))

    -- Object Info
    -- notify_send("InfoWibox:"..inspect(infoWibox[awful.screen.focused().index], 2))

    -- notify_send("InfoLayout:"..inspect(infoWibox[awful.screen.focused().index].drawin.height, 3))

    -- -- infoLayout:set_max_widget_size(100)
    -- notify_send("InfoLayout:"..inspect(infoLayout, 3))
    -- notify_send("Drawable:"..inspect(infoWibox[awful.screen.focused().index]._drawable, 2))
    -- notify_send("Drawable.Widget:"..inspect(infoWibox[awful.screen.focused().index]._drawable.widget, 2))

    -- Root Object Info
    -- notify_send(inspect(root, 4))
    -- for prop,val in pairs(root) do
    --  notify_send(prop .. inspect(val(), 4))
    -- end

    -- DBus

    -- dbus.connect_signal("org.freedesktop.NetworkManager.Device.Wireless.PropertiesChanged", function (body, bodyMarkup, iconStatic) notify_send("Got DBUS Notification!!!") end)
    -- dbus.request_name("session", "org.freedesktop.NetworkManager.Device.Wireless.PropertiesChanged")

    -- dbus.request_name("system", "org.freedesktop.NetworkManager.Device.Wireless")
    -- dbus.add_match("system", "interface='org.freedesktop.NetworkManager.Device.Wireless',member='PropertiesChanged'")
    -- dbus.connect_signal("org.freedesktop.NetworkManager.Device.Wireless", function(first, property, ...)
    --  ipAddress = property["Ip4Adress"]
    --  if ipAddress then
    --      notify_send(ipAddress)
    --  end
    --  -- notify_send(inspect(first, 3))
    --  -- notify_send(inspect(property, 3))
    -- end)

    -- dbus.request_name("system", "org.freedesktop.DBus.Properties")
    -- dbus.add_match("system", "interface='org.freedesktop.DBus.Properties',member='GetAll',string='org.freedesktop.NetworkManager.Device.Wireless")
    -- dbus.connect_signal("org.freedesktop.DBus.Properties", function(first, property, third, fourth, fifth, ...)
    --  notify_send("There is a Dog!")
    --  -- ipAddress = property["Ip4Adress"]
    --  if ipAddress then
    --      notify_send(ipAddress)
    --  end
    --  -- notify_send(inspect(first, 3))
    --  notify_send(inspect(property, 3))
    --  notify_send(inspect(third, 3))
    --  notify_send(inspect(fourth, 3))
    --  notify_send(inspect(fifth, 3))
    -- end)
    --

    -- Working
    -- dbus.request_name("system", "org.freedesktop.NetworkManager")
    -- dbus.add_match("system", "interface='org.freedesktop.NetworkManager',member='PropertiesChanged'")
    -- dbus.connect_signal("org.freedesktop.NetworkManager", function(first, second, ...) -- Doesn't seem to be a third
    --  -- debug_leaf(first)
    --  -- debug_leaf(second)

    --  if second.Connectivity and second.Connectivity == 4 then
    --      notify_send("DBUS: Connected to WIFI");
    --  elseif second.Connectivity and second.Connectivity == 1 then
    --      notify_send("DBUS: Disconnected from WIFI");
    --  end
    -- end)

end

-- TODO: Get this working with
function perScreen(callback)
    local returnValues = {}
    for s = 1, screen.count() do
        gears.table.join(returnValues, callback(s))
    end
    debug_leaf(inspect(screen.count()))
    return returnValues
end

--Signals
function setupSignals()
    -- Screen Signals
    screen.connect_signal("property::geometry", screenSetWallpaper)
    awful.screen.connect_for_each_screen(screenInit)

    -- Client Signals
    client.connect_signal("manage", manageClient)
    client.connect_signal("focus", clientDidFocus)
    client.connect_signal("unfocus", clientDidLoseFocus)
    client.connect_signal("property::floating", clientDidChangeFloating)
    client.connect_signal("mouse::enter", clientDidMouseEnter)
    setupClientRequestActivate()
end

local function transientShouldBeSticky(c)
    return (c.name and c.name:find("LEAFPAD_QUICK_NOTE")) -- or
end

function manageClient(c)
    -- When first created

    -- TODO: need to confirm this is fine...
    -- if not startup then
    --     -- determines order of new clients
    --     awful.client.setslave(c)
    --     -- Position
    --     if not c.size_hints.user_position and not c.size_hints.program_position then
    --         awful.placement.no_overlap(c)
    --         awful.placement.no_offscreen(c)
    --     end
    -- end
    if not awesome.startup then
        awful.client.setslave(c)
    end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Subwindows Sticky
    if c.transient_for and transientShouldBeSticky(c) then
        notify_send("Transient's UNITE!")
        c.sticky = true
    end

    -- TODO: 2 below, this is also in property-change/event-handlers & it would be nice if it was only in one location...
    -- If a client is automatically floating, make it ontop
    clientDidChangeFloating(c)

    if client.focus == c then
        clientDidFocus(c)
    end
end

function clientDidFocus(c)
    c.border_color = beautiful.border_focus
    c:raise()
end

function clientDidLoseFocus(c)
    c.border_color = beautiful.border_normal
end

function clientDidChangeFloating(c)
    c.ontop = c.floating and not c.fullscreen
end

function clientDidMouseEnter(c)
    if not c.minimized then
        clientShouldAttemptFocus(c)
    end
end

function setupClientRequestActivate()
    -- from: http://new.awesomewm.org/apidoc/documentation/90-FAQ.md.html
    client.disconnect_signal("request::activate", awful.ewmh.activate)
    function awful.ewmh.activate(c)
        if c:isvisible() then
            client.focus = c
            c:raise()
        end
    end
    client.connect_signal("request::activate", awful.ewmh.activate)
end

function screenPropertyGeometry(s)
    screenSetWallpaper(s)
end

function clientShouldAttemptFocus(c)
    -- NOTE: Experimental support for not changing focus from transient back to it's parent
    -- NOTE: If there is another client on screen then we can still switch to that client then back to the parent...
    -- NOTE: ALSO: Experimental support for not changing focus to fullscreen windows automatically, intended to help with the fact that fullscreen windows are displayed over top of wiboxes
    -- NOTE: Also with the fullscreen note above, the or current client floating means that I can quickly switch between a fullscreen window & say my calculator
    -- DEFAULT: and awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    if (not client.focus) or awful.client.focus.filter(c) and ((not client.focus) or client.focus.transient_for ~= c) and (not c.fullscreen or client.focus.floating) then
        client.focus = c
    end
end

function screenInit(s)
    -- Wallpaper
    screenSetWallpaper(s)

    --Tags
    awful.tag(CONFIG.screens.tags, s, awful.layout.layouts[1])

    -- Popup Terminal/Process Info/Notes/etc
    popup.init(s)

    --Wiboxes w/ Widgets
    widgetManager.initWiboxes(s)
end

--Utility
function evalTemplate(template, data)
    return template:gsub("{([%w_]+)}", data)
end
function expandUser(path)
    return path:gsub('~', os.getenv('HOME'))
end

function screenSetWallpaper(s)
    local resolutionPathTpl = CONFIG.theme.wallpapers.resolutionPath
    local normalPathTpl = CONFIG.theme.wallpapers.normalPath

    local resolutionPath = expandUser(evalTemplate(resolutionPathTpl, s.geometry))
    local normalPath = expandUser(evalTemplate(normalPathTpl, {
        theme_path = THEME_PATH,
    }))

    local wallpapersPath = (gears.filesystem.dir_readable(resolutionPath) and resolutionPath or normalPath)

    -- Random Background
    local cmd = evalTemplate(CONFIG.commands.setWallpaper, {
        screen = (s.index - 1),
        directory = wallpapersPath,
    })
    awful.spawn.with_shell(cmd)
end

--Naughty
function notify_send(text, timeout, preset)
    naughty.notify({preset=preset or naughty.config.presets.normal,
                      text=text,
                    screen=screen.count(),
                   timeout=timeout or 0})
end

-- Programs
function startupPrograms()
    for _,program in ipairs(CONFIG.startup.programs) do
        run_once(program)
    end
end
