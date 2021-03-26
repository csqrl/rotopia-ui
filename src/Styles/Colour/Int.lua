local floor = math.floor

local function IntToColor3(int: number): Color3
    local red = floor(int / 256 ^ 2) % 256
    local green = floor(int / 256) % 256
    local blue = floor(int) % 256

    return Color3.fromRGB(red, green, blue)
end

local function Color3ToInt(colour: Color3): number
    local red = floor(colour.R * 255) * 256 ^ 2
    local green = floor(colour.G * 255) * 256
    local blue = floor(colour.B * 255)

    return red + green + blue
end

return {
    fromInt = IntToColor3,
    toInt = Color3ToInt,
}
