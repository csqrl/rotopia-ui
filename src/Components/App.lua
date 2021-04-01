local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local Theme = require(Root.Theme)

local e = Roact.createElement

return function()
    return e(Theme.Provider, nil, {
        e(RoactRouter.Router, nil, {
            e("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ClipsDescendants = true,
            }),
        }),
    })
end
