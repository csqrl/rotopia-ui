local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Context = Roact.createContext({
    width = 0,
    height = 0,
})

function Context.withDevice(render)
    return Roact.createElement(Context.Consumer, {
        render = render,
    })
end

return Context
