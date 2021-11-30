local kont = require('utils.kont')
local op = require('utils.operator')

local split = require('commands.screen.split')

local mod = {}

function mod.split_screen_half()
    return {
        namespace = 'screen.split',
        title = 'into halves',
        apply = function () split.split_screen(1, 1) end,
        enabled = kont.map(op.negate, split.is_split)
    }
end

function mod.split_screen_third()
    return {
        namespace = 'screen.split',
        title = 'into thirds',
        apply = function () split.split_screen(1, 2) end,
        enabled = kont.map(op.negate, split.is_split)
    }
end

function mod.unsplit_screen()
    return {
        namespace = 'screen.split',
        title = 'unsplit',
        apply = split.unsplit_screen,
        enabled = split.is_split
    }
end

return mod

