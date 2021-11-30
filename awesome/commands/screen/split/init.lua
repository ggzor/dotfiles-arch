local awful = require("awful")

local kont  = require("utils.kont")
local op  = require("utils.operator")

local left_screen  = 'awm-left'
local right_screen = 'awm-right'

local sh = require("utils.sh").load_scripts_from_dir('commands/screen/split')

local run = awful.spawn.easy_async_with_shell

local function run_kont(command)
    return function (cont)
       run(command, cont)
    end
end

local mod = {}

function mod.is_split(cont)
    run(sh.has_screen({ screen = left_screen }), function (_, _, _, code)
        cont(code == 0)
    end)
end

function mod.unsplit_screen()
    mod.is_split(function (is_split)
        if is_split then
            if screen[2] then
                screen[2]:fake_remove()
            end

            kont.sequence({
                run_kont(sh.delete_monitor({ name = right_screen })),
                run_kont(sh.delete_monitor({ name = left_screen })),
            })(op.id)
        end
    end)
end

function mod.split_screen(left_fr, right_fr)
    mod.is_split(function (is_split)
        if not is_split then
            local geo = screen[1].geometry
            local w = geo.width
            local h = geo.height

            -- TODO: Check for wrong total
            local total_fr = left_fr + right_fr
            local left_ratio = left_fr / total_fr

            local wleft = math.floor(w * left_ratio)
            local wright = math.floor(w - wleft)

            run(sh.get_screen_data({ screen = 0 }), function (stdout)
                local mmw, mmh, target = stdout:match('([0-9]+)\n([0-9]+)\n(.+)\n')

                local mmw_left = math.floor(mmw * left_ratio)
                local mmw_right = math.floor(mmw - mmw_left)

                kont.sequence({
                    run_kont(sh.enable_monitor {
                        name = left_screen,
                        target = target,
                        x = 0, y = 0,
                        w = wleft, h = h,
                        mmw = mmw_left, mmh = mmh
                    }),
                    run_kont(sh.enable_monitor {
                        name = right_screen,
                        target = 'none',
                        x = wleft, y = 0,
                        w = wright, h = h,
                        mmw = mmw_right, mmh = mmh
                    }),
                })(function ()
                    screen[1]:fake_resize(0, 0, wleft, h)
                    screen.fake_add(wleft, 0, wright, h)
                end)
            end)
        end
    end)
end

return mod

