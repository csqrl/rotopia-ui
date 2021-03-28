local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Context = require(script.Parent.Context)

return function(render)
    return Roact.createElement(Context.Consumer, {
        render = render,
    })
end
