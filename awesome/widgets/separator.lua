local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local function separator(...)
    local amount = ...
    amount = amount or 1

    return wibox.widget {
        text = string.rep(' ', amount),
        widget = wibox.widget.textbox,
    }
end

return separator

