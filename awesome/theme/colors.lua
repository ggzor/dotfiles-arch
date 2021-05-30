local colors = {}

function populate()
    colors.bg = '#011627'
    colors.fg = '#d6deeb'

    colors.black     = '#536372'
    colors.red       = '#ef5350'
    colors.green     = '#22da6e'
    colors.yellow    = '#ecc48d'
    colors.blue      = '#82aaff'
    colors.magenta   = '#c792ea'
    colors.cyan      = '#7fdbca'
    colors.white     = '#ffffff'
    colors.orange    = '#f78c6c'
    colors.lime      = '#9ccc65'
    colors.yellow_alt = '#e2b93d'

    colors.bg_dark   = '#00121f'
    colors.bg_light  = '#2c3043'
    colors.bg_blue   = '#5f7e97'
    colors.bg_scroll = '#084d81'

    colors.rainbow1 = '#c792ea'
    colors.rainbow2 = '#adc7ff'
    colors.rainbow3 = '#f75590'
    colors.rainbow4 = '#f49190'
    colors.rainbow5 = '#badb94'
    colors.rainbow6 = '#f3dbb9'
    colors.rainbow7 = '#979287'

    local bg_rgb = hex2rgb(colors.bg)
    local fg_rgb = hex2rgb(colors.fg)

    local original_colors = copy(colors)
    for color, _ in pairs(original_colors) do
        if color ~= "bg" then
            for amount = 5, 95, 5 do
                local color_rgb = hex2rgb(original_colors[color])

                colors[color..amount] =
                    rgb2hex(linear_interp(amount / 100.0, bg_rgb, color_rgb))
                colors[color..amount..'fg'] =
                    rgb2hex(linear_interp(amount / 100.0, fg_rgb, color_rgb))
            end
        end
    end
end

function hex2rgb(color)
    return {
        tonumber(color:sub(2, 3), 16),
        tonumber(color:sub(4, 5), 16),
        tonumber(color:sub(6, 7), 16),
    }
end

function rgb2hex(rgb)
    return string.format('#%02x%02x%02x', rgb[1], rgb[2], rgb[3])
end

local first = true
function linear_interp(amount, c1, c2)
    result = {}
    for i = 1, 3 do
        result[i] = clamp(0, 255, math.floor(c1[i] + amount * (c2[i] - c1[i])))
    end
    return result
end

function clamp(min, max, value)
    return math.max(0, math.min(value, max))
end

function copy(t)
    local result = { }
    for k, v in pairs(t) do
        result[k] = v
    end
    return result
end

populate()
return colors
