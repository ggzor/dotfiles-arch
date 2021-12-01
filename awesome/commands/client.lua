local awful = require('awful')
local naughty = require('naughty')

local kont = require('utils.kont')
local tab = require('utils.tabletools')

local mod = {}

local function disallow_focus_stealing(_, context)
    if context == 'ewmh' or context == 'rules' then
        return false
    end
end

function mod.disallow_focus_stealing()
    local is_enabled = tab.has(awful.permissions.generic_activate_filters,
                               disallow_focus_stealing)

    return {
        namespace = 'awesome.client',
        title = (is_enabled and 'enable' or 'disable')..' focus stealing',
        apply = function ()
            if is_enabled then
                awful.permissions.remove_activate_filter(disallow_focus_stealing)
                naughty.notify {
                    title = "Focus Stealing: Enabled",
                    position = "top_middle"
                }
            else
                awful.permissions.add_activate_filter(disallow_focus_stealing)
                naughty.notify {
                    title = "Focus Stealing: Disabled",
                    position = "top_middle"
                }
            end
        end,
        enabled = kont.pure(true)
    }
end

return mod

