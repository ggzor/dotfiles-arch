local awful = require('awful')
local run = awful.spawn.easy_async_with_shell

local fs = require('utils.fs')
local kont = require('utils.kont')
local op = require('utils.operator')
local tab = require('utils.tabletools')

local mod = {}
local options_spec = {}

-- Load plugins
for _, dir in pairs(fs.list_dir(fs.resolve_relative('commands'))) do
    if dir ~= 'init.lua' then
        module = dir:match('[^%.]+')
        tab.assign(options_spec, require('commands.'..module))
    end
end

function mod.show_options()
    local options = tab.map(op.call, options_spec)

    local enabled_results =
        kont.sequence(
            tab.map(op.index('enabled'),
            options))

    enabled_results(function (results)
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
                    for _, command in pairs(options) do
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

