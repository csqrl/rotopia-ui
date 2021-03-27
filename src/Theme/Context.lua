local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local DefaultTheme = require(script.Parent.DefaultTheme)

local Context = Roact.createContext(DefaultTheme)

return Context
