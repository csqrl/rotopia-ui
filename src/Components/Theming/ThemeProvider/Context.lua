local Components = script.Parent.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)

local Context = Roact.createContext(nil)

return Context
