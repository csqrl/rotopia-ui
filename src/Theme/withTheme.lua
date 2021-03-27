local Root = script.Parent.Parent

local InheritedContext = require(Root.Packages.InheritedContext)
local ThemeContext = require(script.Parent.Context)

return function(render)
    return InheritedContext.withContext(ThemeContext, render)
end
