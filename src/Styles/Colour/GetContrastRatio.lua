local GetLuminance = require(script.Parent.GetLuminance)

local max = math.max
local min = math.min

return function(foreground: Color3, background: Color3): number
    local lumFg = GetLuminance(foreground)
    local lumBg = GetLuminance(background)

    return (max(lumFg, lumBg) + .05) / (min(lumFg, lumBg) + .05)
end
