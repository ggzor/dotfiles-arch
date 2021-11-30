local naughty = require('naughty')

local kont = require('utils.kont')
local op = require('utils.operator')

local split = require('commands.screen.split')

local mod = {}

function mod.split_screen_half()
    local function apply()
        naughty.notify { text = 'Halves' }
    end

    return {
        title = 'split screen into halves',
        apply = apply,
        enabled = kont.map(op.negate, split.is_split)
    }
end

function mod.split_screen_third()
    local function apply()
        naughty.notify { text = 'Thirds' }
    end

    return {
        title = 'split screen into thirds',
        apply = apply,
        enabled = kont.map(op.negate, split.is_split)
    }
end

return mod

