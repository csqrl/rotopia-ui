local Root = script.Parent.Parent
local ColourUtils = require(Root.Packages.ColourUtils)

return {
    font = {
        light = Enum.Font.Gotham,
        regular = Enum.Font.Gotham,
        semibold = Enum.Font.GothamSemibold,
        bold = Enum.Font.GothamBold,
    },

    fontSize = 14,
    spacing = 8,
    borderRadius = 8,

    common = {
        white = Color3.new(1, 1, 1),
        black = Color3.new(),
    },

    palette = {
        text = {
            light = Color3.new(1, 1, 1),
            dark = ColourUtils.Lighten(Color3.new(), .13),
        },

        background = {
            default = Color3.new(1, 1, 1),
        },

        primary = ColourUtils.Hex.fromHex("#FF006A"),
    },
}
