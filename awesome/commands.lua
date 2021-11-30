local awful = require('awful')
local naughty = require('naughty')

local run = require('awful').spawn.easy_async_with_shell

local function check_status(cont)
    run('echo $(( $RANDOM % 2 ))', function (stdout)
        cont(stdout == '1\n')
    end)
end

local mod = {}

function mod.split_screen_half()
    local function apply()
        naughty.notify { text = 'Halves' }
    end

    return {
        title = 'split screen into halves',
        apply = apply,
        enabled = check_status
    }
end

function mod.split_screen_third()
    local function apply()
        naughty.notify { text = 'Thirds' }
    end

    return {
        title = 'split screen into thirds',
        apply = apply,
        enabled = check_status
    }
end

local function get_options()
    local result = {}

    for key, value in pairs(mod) do
        if key ~= 'show_options' then
            result[key] = value()
        end
    end

    return result
end

local function evaluate_enabled(t, final_result, continuation)
    local key = next(t)
    if key == nil then
        continuation(final_result)
    else
        local value = t[key]
        t[key] = nil
        value.enabled(function (result)
            final_result[key] = result
            evaluate_enabled(t, final_result, continuation)
        end)
    end
end

function mod.show_options()
    evaluate_enabled(get_options(), {}, function (result)
        local options = get_options()

        local available_commands = 'do nothing\n'

        local first = true

        for key, enabled in pairs(result) do
            if enabled then
                if first then
                    first = false
                else
                    available_commands = available_commands..'\n'
                end

                available_commands = available_commands..options[key].title
            end
        end

        run("rofi -dmenu -p 'command' <<< '"..available_commands.."'",
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

