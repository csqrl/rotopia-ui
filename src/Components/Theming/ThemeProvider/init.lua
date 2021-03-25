local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)
local Llama = require(Packages.Llama)

local DefaultTheme = require(script.Parent.DefaultTheme)

local ThemeContext = require(script.Context)

return function(props)
    props = props or {}

    return Roact.createElement(ThemeContext.Consumer, {
        render = function(outerTheme)
            local newTheme = Llama.Dictionary.merge(
                DefaultTheme,
                outerTheme and outerTheme.theme,
                props.theme
            )

            return Roact.createElement(ThemeContext.Provider, {
                value = {
                    theme = newTheme,
                }
            }, props[Roact.Children])
        end,
    })
end
