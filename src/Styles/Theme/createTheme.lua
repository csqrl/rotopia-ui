local Root = script.Parent.Parent.Parent

local Llama = require(Root.Packages.Llama)

local GetContrastRatio = require(script.Parent.Parent.Colour.GetContrastRatio)
local Lighten = require(script.Parent.Parent.Colour.Lighten)
local Darken = require(script.Parent.Parent.Colour.Darken)
local defaultTheme = require(script.Parent.DefaultTheme)

local fmt = string.format

local ERR_AUG_INVALID_TYPE = "%s(...): The argument must be a %s, but you passed %q (%s)"
local ERR_AUG_MISSING_PROP = "%s(...): The table supplied is missing a `%s` property"
local ERR_AUG_INVALID_PROP = "%s(...): The table supplied has a `%s` property but it must be a %s; you passed %q (%s)"

local function createTheme(theme)
    local newTheme = Llama.Dictionary.mergeDeep(defaultTheme, theme)

    local function getContrastText(background)
        local contrastColour = GetContrastRatio(background, newTheme.text.dark.primary) >= newTheme.contrastThreshold
            and newTheme.text.dark.primary
            or newTheme.text.light.primary

        return contrastColour
    end

    local function createShades(shades)
        local shadesType = typeof(shades)
        local shadesOutput = nil

        if shadesType == "Color3" then
            shadesOutput = { main = shades }
        elseif shadesType == "table" then
            assert(shades.main, fmt(ERR_AUG_MISSING_PROP, "createShades", "main"))

            assert(typeof(shades.main) == "Color3", fmt(
                ERR_AUG_INVALID_PROP, "createShades", "main", "Color3", tostring(shades.main), typeof(shades.main)
            ))

            shadesOutput = shades
        else
            error(fmt(ERR_AUG_INVALID_TYPE, "createShades", "Color3 or table with `main` property", tostring(shades), shadesType), 2)
        end

        if not shadesOutput.light then
            shadesOutput.light = Lighten(shadesOutput.main, newTheme.tonalOffset)
        end

        if not shadesOutput.dark then
            shadesOutput.dark = Darken(shadesOutput.main, newTheme.tonalOffset * 1.5)
        end

        if not shadesOutput.contrastText then
            shadesOutput.contrastText = getContrastText(shadesOutput.main)
        end

        -- print(shades, shadesOutput)

        return shadesOutput
    end

    local function createSpacing(coefficient: number): number
        if type(coefficient) ~= "number" then
            coefficient = 1
        end

        return newTheme.defaultSpacing * coefficient
    end

    newTheme.grey = createShades(newTheme.grey)

    newTheme.primary = createShades(newTheme.primary)
    newTheme.secondary = createShades(newTheme.secondary)
    newTheme.error = createShades(newTheme.error)
    newTheme.warning = createShades(newTheme.warning)
    newTheme.info = createShades(newTheme.info)
    newTheme.success = createShades(newTheme.success)

    newTheme.getContrastText = getContrastText
    newTheme.createShades = createShades
    newTheme.spacing = createSpacing

    return newTheme
end

return createTheme
