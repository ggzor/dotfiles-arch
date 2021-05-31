local awful = require("awful")
local naughty = require("naughty")
local sh = require("utils.sh").load_scripts_from_dir('scripts/audio')

local run = awful.spawn.easy_async_with_shell
local spawn = function(program)
    return function()
        awful.spawn(program)
    end
end

local mod = {}

function mod.play_pause()
    awful.spawn("playerctl play-pause")
end

function mod.next()
    awful.spawn("playerctl next")
end

function mod.previous()
    awful.spawn("playerctl previous")
end

function mod.volume_up()
    run(sh.get_volume(), function(stdout, stderr, _, code)
        if code == 0 then
            local volume = tonumber(stdout)
            awful.spawn(string.format(
                          "pactl set-sink-volume @DEFAULT_SINK@ %d%%",
                          math.min(100, volume + 10)))
        end
    end)
end

function mod.volume_down()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")
end

function mod.mute()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
end


return mod
