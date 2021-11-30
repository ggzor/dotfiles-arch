local beautiful = require("beautiful")
local wibox = require("wibox")

local function minimized_list(config)
    local label = wibox.widget {
        font = beautiful.font,
        widget = wibox.widget.textbox,
    }

    local handle_minimized = function()
        local count = 0

        for _, c in pairs(config.screen.hidden_clients) do
            if c.minimized then
                for _, t in pairs(c:tags()) do
                    if t == config.screen.selected_tag then
                        count = count + 1
                    end
                end
            end
        end

        if count == 0 then
            label.text = ''
        else
            label.text = '['..tostring(count)..']'
        end
    end

    client.connect_signal('manage', handle_minimized)
    client.connect_signal('unmanage', handle_minimized)

    client.connect_signal('focus', handle_minimized)
    client.connect_signal('unfocus', handle_minimized)

    config.screen:connect_signal('tag::history::update', handle_minimized)

    config.screen:connect_signal('removed', function (s)
        if s == config.screen then
            client.disconnect_signal('manage', handle_minimized)
            client.disconnect_signal('unmanage', handle_minimized)

            client.disconnect_signal('focus', handle_minimized)
            client.disconnect_signal('unfocus', handle_minimized)

            config.screen:disconnect_signal('tag::history::update', handle_minimized)
        end
    end)

    return label
end

return minimized_list

