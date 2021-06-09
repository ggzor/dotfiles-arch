-- Use luarocks if available
pcall(require, "luarocks.loader")
-- Handle startup and runtime errors
require('error_handling')

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

-- Shell for awful.shell
awful.util.shell = "bash"
beautiful.init(require("theme"))

local tags = { "1", "2", "3", "4", "5" }

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- Bar
awful.screen.connect_for_each_screen(function(s)
    awful.tag(tags, s, awful.layout.layouts[1])

    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
        }
    }

    s.systray = wibox.widget.systray()
    s.systray.visible = false

    local wibar = awful.wibar({ screen = s })
    wibar:setup {
        layout = wibox.layout.align.horizontal,
        -- Left
        {
            -- Arch Icon
            wibox.widget {
                {
                    markup = "   ",
                    font = beautiful.font_large,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.horizontal
            },
            -- Tag List
            s.taglist,

            layout = wibox.layout.fixed.horizontal,
        },
        -- Center
        wibox.widget {},
        -- Right
        {
            -- Battery
            require('widgets.battery') {
                highlight = 35,
                warning   = 25,
                alert     = 15,
                suspend   = 7,

                timeout = 10,

                battery = 'BAT0',
                ac = 'AC'
            },
            -- Separator
            wibox.widget {
                text = " ",
                widget = wibox.widget.textbox,
            },
            wibox.widget.textclock(),
            awful.widget.keyboardlayout(),
            s.systray,
            -- Layout box
            awful.widget.layoutbox({
                screen = s,
                buttons = {
                    awful.button({ }, 1, function () awful.layout.inc(1) end)
                },
            }),

            layout = wibox.layout.fixed.horizontal,
        },
    }
end)

globalkeys, clientkeys, clientbuttons = require('keybindings')(tags)

root.keys(globalkeys)

awful.rules.rules = {
    -- All clients
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- Floating clients
    {
        rule_any = {
            instance = {
              "pinentry",
            },
            class = {
              "Arandr",
              "Tor Browser",
              "Wpa_gui",
            },
            name = {
              "Event Tester",
              "Blender Preferences",
            },
            role = {
              "pop-up",
            }
        },
        properties = { floating = true, }
    },
    -- Special rules
    {
        rule = { "Google-chrome" },
        properties = {
            focusable = true,
            maximized_vertical = false,
            maximized_horizontal = false,
        }
    }
}

-- Aditional hooks

-- Focus
require('awful.autofocus')
-- Follow mouse
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
-- Urgent client
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

-- Borders
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Placement
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Place clients as slaves
        awful.client.setslave(c)

        if c.name == '<floating>' then
            c.floating = true
            area = awful.screen.focused().workarea

            conf = beautiful.floating

            c.width = math.max(conf.min_width, conf.width_factor * area.width)
            c.height = math.max(conf.min_height, conf.height_factor * area.height)

            awful.placement.centered(c)
        end
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes
        awful.placement.no_offscreen(c)
    end
end)

-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end)

