local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local InheritedContext = require(Root.Packages.InheritedContext)
local ColourUtils = require(Root.Packages.ColourUtils)

local ThemeContext = require(script.Parent.Context)
local ThemeProvider = InheritedContext.Provider(ThemeContext)

local function getTextColour(background: Color3, darkThemeText: Color3, lightThemeText: Color3): Color3
    local contrastRatio = ColourUtils.GetContrastRatio(background, darkThemeText)
    return contrastRatio >= 3 and darkThemeText or lightThemeText
end

local function transformContext(context)
    context.getTextColour = function(background: Color3): Color3
        return getTextColour(
            background,
            context.palette.text.light,
            context.palette.text.dark
        )
    end

    return context
end

return function(props)
    props.transform = transformContext

    return Roact.createElement(ThemeProvider, props)
end
