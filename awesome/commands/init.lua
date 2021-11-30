local awful = require('awful')
local naughty = require('naughty')
local run = awful.spawn.easy_async_with_shell

local kont = require('utils.kont')
local op = require('utils.operator')
local tab = require('utils.tabletools')

local split_screen = require('commands.split_screen')

local mod = {}

function mod.toggle_systray()
    return {
        title = 'toggle systray',
        apply = function ()
            local systray = awful.screen.focused().systray
            systray.visible = not systray.visible
        end,
        enabled = kont.pure(true)
    }
end


function mod.split_screen_half()
    local function apply()
        naughty.notify { text = 'Halves' }
    end

    return {
        title = 'split screen into halves',
        apply = apply,
        enabled = kont.map(op.negate, split_screen.is_split)
    }
end

function mod.split_screen_third()
    local function apply()
        naughty.notify { text = 'Thirds' }
    end

    return {
        title = 'split screen into thirds',
        apply = apply,
        enabled = kont.map(op.negate, split_screen.is_split)
    }
end

local function get_options()
    return tab.map(op.call,
           tab.filter_keys(op.neq('show_options'),
           mod))
end

function mod.show_options()
    local enabled_results = kont.sequence(tab.map(op.index('enabled'), get_options()))

    enabled_results(function (results)
        local options = get_options()

        local enabled_titles =
            table.concat(
                tab.map(op.index('title'),
                tab.map(op.keyof(options),
                tab.keys(
                tab.filter(op.id,
                results)))),
                '\n')

        run("rofi -dmenu -p 'command' <<< '"..enabled_titles.."'",
            function (stdout, _, _, code)
                if code == 0 then
                    local target = stdout:match('^%s*(.*%S)')
                    for _, command in pairs(get_options()) do
                        if command.title:match('^%s*(.*%S)') == target then
                            command.apply()
                        end
                    end
                end
            end
        )
    end)
end

return mod

