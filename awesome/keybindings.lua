local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local audio = require("scripts.audio")

local Mod      = {"Mod4"}
local ModShift = {"Mod4", "Shift"}
local ModCtrl  = {"Mod4", "Control"}
local ModAlt  = {"Mod4", "Mod1"}

local search_engine = 'https://www.google.com'

local bind = require('utils.functools').bind
local spawn = function(program)
    return function()
        awful.spawn(program)
    end
end

function generate_globalkeys(tags)
    return {
        awesome = {
            { Mod,      "s", "Show help",            require("awful.hotkeys_popup").show_help },
            { Mod,      "t", "Toggle systray",       toggle_systray },
            { ModCtrl,  "r", "Reload configuration", awesome.restart },
            { ModShift, "q", "Quit awesomewm",       awesome.quit },
        },
        client = {
            { Mod,      "j", "Focus next",     bind(awful.client.focus.byidx,  1) },
            { Mod,      "k", "Focus previous", bind(awful.client.focus.byidx, -1) },

            { ModShift, "j", "Swap next",      bind(awful.client.swap.byidx,   1) },
            { ModShift, "k", "Swap previous",  bind(awful.client.swap.byidx,  -1) },

            { Mod,      "u", "Jump to urgent",         awful.client.urgent.jumpto },
            { ModShift, "g", "Print debug data",       print_client_debug },
            { Mod,      "+", "Unminimize next client", unminimize_next },
        },
        layout = {
            { ModCtrl,  "l", "Increase columns", bind(awful.tag.incncol,  1, nil, true) },
            { ModCtrl,  "h", "Decrease columns", bind(awful.tag.incncol, -1, nil, true) },

            { ModShift, "l", "Increase master clients", bind(awful.tag.incnmaster,  1, nil, true) },
            { ModShift, "h", "Decrease master clients", bind(awful.tag.incnmaster, -1, nil, true) },

            { Mod,      "l", "Increase master width", bind(awful.tag.incmwfact,  0.05) },
            { Mod,      "h", "Decrease master width", bind(awful.tag.incmwfact, -0.05) },

            { ModAlt,   "l", "Increase client size", bind(awful.client.incwfact,  0.1) },
            { ModAlt,   "h", "Decrease client size", bind(awful.client.incwfact, -0.1) },

            { Mod,      "space", "Next layout", bind(awful.layout.inc, 1) },
        },
        screen = {
            { ModCtrl,  "j", "Focus next",     bind(awful.screen.focus_relative,  1) },
            { ModCtrl,  "k", "Focus previous", bind(awful.screen.focus_relative, -1) },
        },
        programs = {
            { Mod,      "Return", "Terminal",     spawn("kitty") },
            { Mod,      "b",      "Browser",      spawn("firefox") },
            { Mod,      "d",      "Dotfiles",     open_dotfiles },
            { Mod,      "g",      "Search",       launch_search_engine },
            { Mod,      "ñ",      "Now.md",       open_now_md },
            { Mod,      "c",      "WM Commands",  require('commands').show_options },
            { Mod,      "p",      "Launcher",     spawn("rofi -show combi -display-combi do") },
            { {},       "Print",  "Print screen", spawn("flameshot gui") },
        },
        tag = {
            { Mod, ",", "Go to previous", awful.tag.viewprev },
            { Mod, ".", "Go to next",     awful.tag.viewnext },
            table.unpack((function ()
                result = {}

                for i, _ in ipairs(tags) do
                    table.insert(result,
                        { Mod,      "#"..i + 9, "View only tag "..i,      view_tag(i) }
                    )
                    table.insert(result,
                        { ModShift, "#"..i + 9, "Move client to tag "..i, move_to_tag(i) }
                    )
                end

                return result
            end)())
        },

        media = {
            { {}, "XF86AudioPlay",        "Play/Pause",  audio.play_pause },
            { {}, "XF86AudioNext",        "Next",        audio.next },
            { {}, "XF86AudioPrev",        "Previous",    audio.previous },
            { {}, "XF86AudioRaiseVolume", "Volume up",   audio.volume_up },
            { {}, "XF86AudioLowerVolume", "Volume down", audio.volume_down },
            { {}, "XF86AudioMute",        "Mute",        audio.mute },

            { {}, "XF86MonBrightnessUp",   "Brightness up",   spawn("brightnessctl set 10%+") },
            { {}, "XF86MonBrightnessDown", "Brightness down", spawn("brightnessctl set 10%-") },
        },
    }
end

local CMD_FULL = 'CMD_FULL'
local CMD_MAXIMIZE = 'CMD_MAXIMIZE'

function generate_clientkeys()
    local client_actions = get_client_actions()

    return {
        client = {
            { Mod,  "q", "Close",                client_actions.close },
            { Mod,  "f", "Toggle fullscreen",    client_actions.maximized_or_full(CMD_FULL) },
            { Mod,  "m", "Toggle maximized",     client_actions.maximized_or_full(CMD_MAXIMIZE) },
            { Mod,  "n", "Toggle detached",      client_actions.detach },
            { Mod,  "o", "Move to other screen", client_actions.move_to_screen },
            { Mod,  "-", "Minimize",             client_actions.minimize },
        },
    }
end

function generate_clientbuttons()
    local client_actions = get_client_actions()

    return gears.table.map(
        function(t)
            return awful.button(table.unpack(t))
        end,
        {
            { {},  1, client_actions.click },
            { Mod, 1, client_actions.move },
            { Mod, 3, client_actions.resize },
        }
    )
end

function toggle_systray()
    local systray = awful.screen.focused().systray
    systray.visible = not systray.visible
end

function spawn_unique(title, command)
    for _, c in ipairs(client.get()) do
        if c.name == title then
            c:jump_to()
            return
        end
    end

    awful.spawn(command)
end

function launch_search_engine()
    for _, c in ipairs(awful.tag.selected():clients()) do
        if c.role == 'browser' then
            c:jump_to()
            break
        end
    end

    awful.spawn('xdg-open '..'"'..search_engine..'"')
end

function open_dotfiles()
    local command = [[
      echo "\033[1mDirectory contents:\033[0m"
      exa --icons 2> /dev/null || ls
      echo ""
      zsh -i
    ]]

    spawn_unique(
        '<dotfiles>',
        "kitty --title '<dotfiles>' --directory \"$HOME/dotfiles\" zsh -c '"..command.."'"
    )
end

function open_now_md()
    spawn_unique(
        '<now.md>',
        "kitty --title '<now.md>' nvim Now.md"
    )
end

function print_client_debug()
    local c = client.focus
    if c then
        naughty.notify({
            title='Debug information:',
            text='Class: '..c.class..
                 '\nName: '..c.name..
                 '\nRole: '..(c.role or 'None')..
                 '\nDimensions: '..c.width..'x'..c.height..
                 '\nType: '..c.type
        })
    end
end

function view_tag(i)
    return function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
           tag:view_only()
        end
    end
end

function move_to_tag(i)
    return function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end
end

function spec_to_table(keys_spec)
    local result = {}

    for group, values in pairs(keys_spec) do
        for _, spec in pairs(values) do
            mods, k, description, action = table.unpack(spec)
            table.insert(result, awful.key(mods, k, action, {
                description = description,
                group = group
            }))
        end
    end

    return result
end

function unminimize_next()
    local target = nil
    for _, c in ipairs(awful.tag.selected():clients()) do
        if c.minimized then
            if target
             and target.minimized
             and target.minimized_time
             and c.minimized_time
             then
                if c.minimized_time > target.minimized_time then
                    target = c
                end
            else
                target = c
            end
        end
    end

    if target then
        target.minimized = false
        target:jump_to()
    end
end

function get_client_actions()
    return {
        close = function(c)
            c:kill()
        end,
        maximized_or_full = function (cmd)
            return function (c)
                if not c.maximized and not c.fullscreen then
                    if cmd == CMD_MAXIMIZE then
                        c.maximized = true
                        c:raise()
                    elseif cmd == CMD_FULL then
                        c.fullscreen = true
                        c:raise()
                    end
                elseif c.maximized and not c.fullscreen then
                    if cmd == CMD_MAXIMIZE then
                        c.maximized = false
                    elseif cmd == CMD_FULL then
                        c.maximized = false
                        c.fullscreen = true
                        c:raise()
                    end
                elseif not c.maximized and c.fullscreen then
                    if cmd == CMD_MAXIMIZE then
                        -- Do not swap order!
                        c.fullscreen = false
                        c.maximized = true
                        c:raise()
                    elseif cmd == CMD_FULL then
                        c.fullscreen = false
                    end
                elseif c.maximized and c.fullscreen then
                    c.maximized = false
                    c.fullscreen = false
                end
            end
        end,
        move_to_screen = function(c)
            c:move_to_screen()
        end,
        detach = function(c)
            if not c.floating then
                c.floating = true
                c.ontop = true
                awful.placement.centered(c)
                c:raise()
            else
                c.floating = false
                c.ontop = false
            end
        end,
        click = function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end,
        move = function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end,
        resize = function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end,
        minimize = function (c)
            c.minimized_time = os.time()
            c.minimized = true
        end,
    }
end

return function(tags)
    local globalkeys = gears.table.join(
                             table.unpack(spec_to_table(generate_globalkeys(tags))))
    local clientkeys = gears.table.join(
                             table.unpack(spec_to_table(generate_clientkeys())))
    local clientbuttons = gears.table.join(
                             table.unpack(generate_clientbuttons()))

    return globalkeys, clientkeys, clientbuttons
end

