local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Context = Roact.createContext({
    width = 0,
    height = 0,
})

return Context
