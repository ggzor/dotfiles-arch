local cfg_dir = require('gears.filesystem').get_configuration_dir()
local mod = {}

-- FIXME: Fragile resolve
function mod.resolve(...)
    args = {...}

    result = args[1]
    for i, p in ipairs(args) do
        if i > 1 then
            if result:len() > 0 and result:sub(-1) ~= '/' then
                result = result..'/'
            end
            result = result .. p
        end
    end

    return result
end

function mod.resolve_relative(...)
    return mod.resolve(cfg_dir, ...)
end

function mod.read_file(file)
    local f = io.open(file, 'r')
    if f ~= nil then
        local s = f:read('*all')
        f:close()
        return s
    else
        return nil
    end
end

function mod.read_file_relative(file)
    return mod.read_file(mod.resolve_relative(file))
end

function mod.list_dir(file)
    local list_command =
        "bash -c '"..
        'shopt -s nullglob; '..
        'for f in "'..file..'"/*; do '..
           'echo "$(basename "$f")";'..
        'done; '..
        "'"

    local process = io.popen(list_command)

    result = {}
    for l in process:lines() do
        table.insert(result, l)
    end

    local _, _, code = process:close()

    if code == 0 then
        return result
    else
        return nil
    end
end

return mod
