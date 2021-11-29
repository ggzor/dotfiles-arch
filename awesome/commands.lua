local naughty = require('naughty')

local mod = {}

function mod.split_screen_half()
    local function apply()
        naughty.notify { text = 'Halves' }
    end

    return {
        title = 'Split screen into halves',
        apply = apply,
        enabled = true
    }
end

function mod.split_screen_third()
    local function apply()
        naughty.notify { text = 'Thirds' }
    end

    return {
        title = 'Split screen into thirds',
        apply = apply,
        enabled = true
    }
end

function mod.get_list()
    local result = '\n'

    for command_func, get_command_info in pairs(mod) do
        if command_func ~= 'get_list' and command_func ~= 'run_command' then
            local command = get_command_info()

            if command.enabled then
                result = result..tostring(command_func)
                result = result..':'
                result = result..tostring(command.title)
                result = result..'\n'
            end
        end
    end

    return result
end

function mod.run_command(command_func_name)
    mod[command_func_name]().apply()
end

return mod
