local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local createTheme = require(script.Parent.Parent.Theme.createTheme)

local Context = Roact.createContext(createTheme())

return Context
