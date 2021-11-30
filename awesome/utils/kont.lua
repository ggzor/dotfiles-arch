-- Utils for Continuation Passing Style (CPS) things
-- type Cont a = (a -> r) -> r

local mod = {}

-- Map a continuation
-- (a -> b) -> Cont a -> Cont b
function mod.map(func, cont_src)
    return function (cont)
        cont_src(function (result)
            cont(func(result))
        end)
    end
end

-- Return a value wrapped in a continuation
-- a -> Cont a
function mod.pure(value)
    return function (cont)
        cont(value)
    end
end

-- Apply a function wrapped in a continuation
-- to a continuation value
-- Cont (a -> b) -> Cont a -> Cont b
function mod.ap(cont_f, cont_a)
    return function (cont)
        -- Order matters here! This applicative is
        -- not commutative when f is effectful.
        cont_f(function (f)
            cont_a(function (a)
                cont(f(a))
            end)
        end)
    end
end

-- Turn a list of continuations into a continuation of list.
-- [Cont a] -> Cont [a]
function mod.sequence(conts_list)
    local key = next(conts_list)
    if key == nil then
        return mod.pure({})
    else
        local current = conts_list[key]
        conts_list[key] = nil

        local function f(result)
            return function (l)
                l[key] = result
                return l
            end
        end

        return mod.ap(
                mod.map(f, current),
                mod.sequence(conts_list))
    end
end

return mod

