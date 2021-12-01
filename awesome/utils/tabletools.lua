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

function mod.assign(target, src)
    for key, value in pairs(src) do
        target[key] = value
    end
end

function mod.sort(t)
    table.sort(t)
    return t
end

function mod.count(t)
    local result = 0

    for _, _ in pairs(t) do
        result = result + 1
    end

    return result
end

function mod.has(t, item)
    for _, value in pairs(t) do
        if item == value then
            return true
        end
    end

    return false
end

return mod
