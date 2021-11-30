local mod = {}

function mod.negate(x)
    return not x
end

function mod.index(key)
    return function (t)
       return t[key]
    end
end

function mod.call(f)
    return f()
end

function mod.neq(value)
    return function (other)
        return other ~= value
    end
end

function mod.id(value)
    return value
end

function mod.keyof(t)
    return function (key)
        return t[key]
    end
end

return mod

