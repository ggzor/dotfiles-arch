local fs = require('utils.fs')

local mod = {}

function mod.inject_vars(script, vars)
    if vars ~= nil then
        for k, v in pairs(vars) do
            script = k.."='"..v.."';".."\n"..script
        end
    end

    return script
end

function mod.callable_script(file)
    local script = fs.read_file(file)
    return function (vars)
        return '( '..mod.inject_vars(script, vars)..' );'
    end
end

function mod.load_scripts_from_dir(directory)
    local result = {}

    for _, f in ipairs(fs.list_dir(fs.resolve_relative(directory))) do
        m = f:match('([^\\.]+).sh$')
        if m then
            result[m] = mod.callable_script(fs.resolve_relative(directory, f))
        end
    end

    return result
end

return mod
