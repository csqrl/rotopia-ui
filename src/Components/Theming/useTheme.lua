local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)

local ThemeContext = require(script.Parent.ThemeProvider.Context)

return function(render)
    return Roact.createElement(ThemeContext.Consumer, {
        render = function(context)
            return render(context.theme)
        end,
    })
end
