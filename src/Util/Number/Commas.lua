local reverse = string.reverse
local match = string.match
local gsub = string.gsub

local concat = table.concat

return function(value: (number | string)): string
    local left, number, right = match(tostring(value), "^([^%d]*%d)(%d*)(.-)$")

    return concat({
        left,
        reverse(gsub(reverse(number), "(%d%d%d)", "%1,")),
        right
    }, "")
end
