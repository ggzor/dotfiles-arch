-- Taken from: https://github.com/Arieleg/mpv-copyTime
local function divmod(a, b)
  return a / b, a % b
end

local function copyTime()
    local time_pos = mp.get_property_number("time-pos")
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)

    local pipe = io.popen("xclip -silent -in -selection clipboard", "w")
    pipe:write(time)
    pipe:close()

    mp.osd_message(string.format("Copied: %s", time))
end

mp.add_key_binding("Ctrl+c", "copyTime", copyTime)
