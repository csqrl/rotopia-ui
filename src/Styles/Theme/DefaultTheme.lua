local Hex = require(script.Parent.Parent.Colour.Hex)

local COL_BLACK = Color3.new()
local COL_WHITE = Color3.new(1, 1, 1)

local defaultPalette = {
    type = "light",

    common = {
        black = COL_BLACK,
        white = COL_WHITE,
    },

    grey = Hex.fromHex("#9e9e9e"),

    primary = Hex.fromHex("#3f51b5"),
    secondary = Hex.fromHex("#f50057"),
    error = Hex.fromHex("#f44336"),
    warning = Hex.fromHex("#ff9800"),
    info = Hex.fromHex("#2196f3"),
    success = Hex.fromHex("#4caf50"),

    contrastThreshold = 3,
    tonalOffset = .2,

    text = {
        light = {
            primary = Hex.fromHex("#202020"),
            secondary = Hex.fromHex("#727272"),
            disabled = Hex.fromHex("#9b9b9b"),
        },

        dark = {
            primary = COL_WHITE,
            secondary = Hex.fromHex("#c0c0c0"),
            disabled = Hex.fromHex("#979797"),
        },
    },

    background = {
        default = COL_WHITE,
    },

    borderRadius = {
        default = 8,
    },

    defaultSpacing = 8,

    font = {
        light = Enum.Font.Gotham,
        regular = Enum.Font.Gotham,
        semibold = Enum.Font.GothamSemibold,
        bold = Enum.Font.GothamBold,
    },

    fontSize = 14,
}

return defaultPalette
