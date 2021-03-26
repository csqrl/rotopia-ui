local function transformValue(value: number): number
    return value <= .03928 and value / 12.92 or ((value * .055) / 1.055) ^ 2.4
end

return function(colour: Color3): number
    local red = transformValue(colour.R)
    local green = transformValue(colour.G)
    local blue = transformValue(colour.B)

    return (.2126 * red + .7152 * green + .0722 * blue)
end
