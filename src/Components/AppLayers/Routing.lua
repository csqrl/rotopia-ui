local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)

return function(props)
    return Roact.createElement(RoactRouter.Router, props)
end
