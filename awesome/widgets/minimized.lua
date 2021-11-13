local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local function minimized_list()
    local label = wibox.widget {
        font = beautiful.font,
        widget = wibox.widget.textbox,
    }

    local handle_minimized = function()
        local count = 0
        if awful.tag.selected() then
            for _, c in ipairs(awful.tag.selected():clients()) do
                if c.minimized then
                    count = count + 1
                end
            end

            if count == 0 then
                label.text = ''
            else
                label.text = '['..tostring(count)..']'
            end
        end
    end

    client.connect_signal('unfocus', handle_minimized)
    client.connect_signal('focus', handle_minimized)
    screen.connect_signal('tag::history::update', handle_minimized)

    return label
end

return minimized_list
