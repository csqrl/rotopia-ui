--[[
    Source:
    github@VerdommeMan/convert-to-human-readable-numbers
--]]
local Commas = require(script.Parent.Commas)

local floor = math.floor
local log = math.log
local abs = math.abs

local concat = table.concat
local fmt = string.format
local gsub = string.gsub
local sub = string.sub

local Suffixes = {
    "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid",
    "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg",
    [0] = "", [-1] = "d", [-2] = "c", [-3] = "m", [-4] = "µ", [-5] = "n", [-6] = "p", [-7] = "f",
    [-8] = "a", [-9] = "z", [-10] = "y",
}

local function formatException(value: number): string
    if value == math.huge or value == -math.huge then
        return "∞"
    elseif value ~= value then
        return "NaN"
    else
        return fmt("%g", value)
    end
end

return function(value: number, precision: number?, commas: boolean?): string
    if type(precision) ~= "number" then
        precision = 2
    end

    if type(commas) ~= "boolean" then
        commas = true
    end

    local index = floor(log(abs(value), 1e3))
    local prefix = Suffixes[index]
    local formattedNumber = nil

    if prefix then
        formattedNumber = fmt(concat({"%#.", precision, "f"}, ""), value / 10 ^ (index * 3))

        if precision <= 0 then
            formattedNumber = gsub(formattedNumber, "%.?0*$", "")
        end
    else
       prefix, formattedNumber = "", formatException(value)
    end

    return fmt(
        "%s%s%s%s",
        commas and Commas(formattedNumber) or formattedNumber,
        (prefix and sub(prefix, 1, 1) == "O") and " " or "",
        prefix,
        prefix and "+" or ""
    )
end
