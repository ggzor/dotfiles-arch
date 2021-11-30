-- Functions to treat tables as iterables, functors, etc.

local mod = {}

function mod.map(f, t)
    local result = {}

    for key, value in pairs(t) do
        result[key] = f(value)
    end

    return result
end

function mod.filter(pred, t)
    local result = {}

    for key, value in pairs(t) do
        if pred(value) then
            result[key] = value
        end
    end

    return result
end

function mod.filter_keys(pred, t)
    local result = {}

    for key, value in pairs(t) do
        if pred(key) then
            result[key] = value
        end
    end

    return result
end

function mod.keys(t)
    local result = {}
    local n = 1

    for k, _ in pairs(t) do
        result[n] = k
        n = n + 1
    end

    return result
end

return mod
