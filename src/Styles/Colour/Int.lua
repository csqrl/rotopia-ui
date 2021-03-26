local floor = math.floor
local fmt = string.format

local rshift = bit32.rshift
local lshift = bit32.lshift
local band = bit32.band

local ERR_NOT_TYPE = "%s(...): The argument must be a %s, but you passed %q (%s)"

local function IntToColor3(int: number): Color3
    assert(type(int) == "number", fmt(ERR_NOT_TYPE, "fromInt", "number", tostring(int), typeof(int)))
    int = floor(int)

    local red = band(rshift(int, 16), 255)
    local green = band(rshift(int, 8), 255)
    local blue = band(int, 255)

    return Color3.fromRGB(red, green, blue)
end

local function Color3ToInt(colour: Color3): number
    assert(typeof(colour) == "Color3", fmt(ERR_NOT_TYPE, "toInt", "Color3", tostring(colour), typeof(colour)))

    local int = floor(colour.R)
    int = lshift(int, 8) + floor(colour.G)
    int = lshift(int, 8) + floor(colour.B)

    return int
end

return {
    fromInt = IntToColor3,
    toInt = Color3ToInt,
}
