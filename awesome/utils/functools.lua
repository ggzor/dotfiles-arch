local mod = {}

function mod.bind(f, ...)
    local args = table.pack(...)

    return function()
        return f(table.unpack(args))
    end
end

return mod
