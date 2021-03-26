local function transformValue(value: number, coefficient: number): number
    return value + ((1 - value) * coefficient)
end

return function(colour: Color3, coefficient: number): Color3
    coefficient = math.clamp(coefficient, 0, 1)

    local red = transformValue(colour.R, coefficient)
    local green = transformValue(colour.G, coefficient)
    local blue = transformValue(colour.B, coefficient)

    return Color3.new(red, green, blue)
end
