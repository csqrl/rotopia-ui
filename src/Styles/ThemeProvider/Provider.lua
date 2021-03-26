local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Context = require(script.Parent.Context)
local withTheme = require(script.Parent.withTheme)
local createTheme = require(script.Parent.Parent.Theme.createTheme)

return function(props)
    return withTheme(function(outerTheme)
        local innerTheme = Llama.Dictionary.mergeDeep(outerTheme, props.theme)
        local theme = createTheme(innerTheme)

        return Roact.createElement(Context.Provider, {
            value = theme,
        }, props[Roact.Children])
    end)
end
