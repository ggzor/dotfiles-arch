local naughty = require('naughty')

local kont = require('utils.kont')
local op = require('utils.operator')

local split = require('commands.screen.split')

local mod = {}

function mod.split_screen_half()
    return {
        title = 'split screen into halves',
        apply = function () split.split_screen(1, 1) end,
        enabled = kont.map(op.negate, split.is_split)
    }
end

function mod.split_screen_third()
    return {
        title = 'split screen into thirds',
        apply = function () split.split_screen(1, 2) end,
        enabled = kont.map(op.negate, split.is_split)
    }
end

function mod.unsplit_screen()
    return {
        title = 'unsplit screen',
        apply = split.unsplit_screen,
        enabled = split.is_split
    }
end

return mod

