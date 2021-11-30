local awful = require('awful')
local kont = require('utils.kont')

local mod = {}

function mod.toggle_systray()
    return {
        namespace = 'awesome.wibar',
        title = 'toggle systray',
        apply = function ()
            local systray = awful.screen.focused().systray
            systray.visible = not systray.visible
        end,
        enabled = kont.pure(true)
    }
end

return mod
