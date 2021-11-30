local awful = require("awful")

local left_screen  = 'awm-left'
local right_screen = 'awm-right'

local sh = require("utils.sh").load_scripts_from_dir('commands/screen/split')

local run = awful.spawn.easy_async_with_shell

local mod = {}

function mod.is_split(cont)
    run(sh.check_status({ screen = left_screen }), function (_, _, _, code)
        cont(code == 0)
    end)
end

function mod.toggle_split()
    run(sh.check_status({ screen = left_screen }), function (stdout, _, _, code)
        if code == 0 then
            local w, h = stdout:match('([0-9]+)\n([0-9]+)\n')

            local del_command =
                sh.delete_monitor({ name = left_screen })..
                sh.delete_monitor({ name = right_screen })

            run(del_command, function (stdout, stderr, _, code)
                if code == 0 then
                    screen[2]:fake_remove()
                    screen[1]:fake_resize(0, 0, w, h)

                    -- Ugly hack to remove again the non removed screen
                    run('sleep 1', function()
                        awful.screen.focus(1)
                        screen[2]:fake_remove()
                    end)
                end
            end)
        else
            local geo = screen[1].geometry
            local w1 = math.floor(geo.width / 2)
            local w2 = geo.width - w1
            local h = geo.height

            local mw, mh, target = stdout:match('([0-9]+)\n([0-9]+)\n(.+)\n')
            local mw1 = math.floor(mw / 2)
            local mw2 = math.floor(mw - mw1)

            local en_command =
                sh.enable_monitor({
                    name = left_screen,
                    target = target,
                    w = w1, h = h,
                    x = 0,
                    mmw = mw1, mmh = mh })..
                sh.enable_monitor({
                    name = right_screen,
                    target = 'none',
                    w = w2, h = h,
                    x = w1,
                    mmw = mw2, mmh = mh })

            run(en_command, function (stdout, stderr, _, code)
                if code == 0 then
                    screen[1]:fake_resize(0, 0, w1, h)
                    screen.fake_add(w1, 0, w2, h)

                    -- Ugly hack to remove extra created window if it exists
                    run('sleep 1', function()
                        if screen[3] then
                            screen[2]:fake_remove()
                        end
                    end)
                end
            end)
        end
    end)
end

return mod

