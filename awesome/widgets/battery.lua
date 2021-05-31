local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local fs = require("utils.fs")

local battery_icons = {
    normal = {
        { 100, '' },
        {  90, '' },
        {  80, '' },
        {  70, '' },
        {  60, '' },
        {  50, '' },
        {  40, '' },
        {  30, '' },
        {  20, '' },
        {  10, '' },
    },
    charging = {
        { 100, '' },
        {  90, '' },
        {  80, '' },
        {  60, '' },
        {  40, '' },
        {  30, '' },
        {  20, '' },
    },
}

local function battery(config)
    local widget = wibox.widget {
        font = beautiful.font,
        widget = wibox.widget.textbox,
    }

    local notified_battery_low = false
    local suspending = false

    local function update(state)
        if state == nil then
            return
        end

        local capacity = state.capacity
        local charging = state.charging

        -- Reset state
        if charging or capacity > config.alert then
            notified_battery_low = false
            suspending = false
        end

        -- Battery color
        local color = beautiful.fg_normal
        local weight = 'normal'

        if not charging then
            if capacity <= config.warning then
                color = beautiful.colors.yellow_alt
            end
            if capacity <= config.alert then
                if not notified_battery_low then
                    naughty.notify({
                        preset = naughty.config.presets.critical,
                        title = "Battery critically low",
                        text = "The system is going to suspend at "
                                ..config.suspend.."%",
                    })
                    notified_battery_low = true
                end

                color = beautiful.colors.red
            end
            if capacity <= config.suspend then
                if not suspending then
                    awful.spawn("systemctl suspend")
                    suspending = true
                end
            end

            if capacity <= config.highlight then
                weight = 'bold'
            end
        end

        local icons = battery_icons.normal
        if charging then
            icons = battery_icons.charging
        end

        local icon = icons[1][2]
        for _, spec in ipairs(icons) do
            local k = spec[1]
            local v = spec[2]
            icon = v

            if capacity >= k then
                break
            end
        end

        widget.markup =
            '<span '..
                ' weight="'..weight..'"'..
                ' foreground="'..color..'"'..
                '>'..
            icon..' '..capacity..'%'
            ..'</span>'
    end

    local function read_battery_state()
        local capacity = fs.read_file(
            '/sys/class/power_supply/'..config.battery..'/capacity')
        local charging = fs.read_file(
            '/sys/class/power_supply/'..config.ac..'/online')

        if capacity == nil or charging == nil then
            return nil
        end

        return {
            capacity = tonumber(capacity),
            charging = tonumber(charging) == 1,
        }
    end

    -- Update with ACPI events
    awful.spawn.with_line_callback('acpi_listen', {
        stdout = function() update(read_battery_state()) end
    })

    -- Update with timer timeout
    local timer = gears.timer({ timeout = config.timeout or 1 })
    timer:connect_signal("timeout", function ()
        update(read_battery_state())
    end)
    timer:start()

    update(read_battery_state())

    return widget
end


return battery
