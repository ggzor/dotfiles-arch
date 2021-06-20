local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local function network(config)
    config = config or {}

    local widget = wibox.widget {
        font = beautiful.font,
        widget = wibox.widget.textbox,
    }

    local function update(available)
        local color = available and beautiful.fg_normal or beautiful.colors.red
        local icon = available and ' 直 ' or ' 睊 '

        widget.markup =
            '<span '..
                ' foreground="'..color..'"'..
                '>'..
            icon
            ..'</span>'
    end

    local function run()
        awful.spawn.easy_async_with_shell(
            'ping -c 1 '..(config.server or '1.1.1.1')..' -W '..(config.wait or 0.4),
            function(_, _, _, code)
                if code == 0 then
                    update(true)

                    gears.timer({
                        timeout = config.timeout or 1,
                        autostart = true,
                        single_shot = true,
                        callback = run
                    })
                else
                    update(false)
                    run()
                end
            end)
    end

    run()

    return widget
end

return network
