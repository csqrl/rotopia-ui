local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local RootContainer = require(script.Parent.RootContainer)

local e = Roact.createElement

return function()
    return e("Frame", {
        AnchorPoint = Vector2.new(.5, .5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(.5, .5),
        Size = UDim2.fromScale(1, 1),
    }, {
        SizeConstraint = e("UISizeConstraint", {
            MaxSize = Vector2.new(900, 500),
        }),

        RootContainer = e(RootContainer),
    })
end
