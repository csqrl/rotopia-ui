local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Component = Roact.PureComponent:extend("DEBUG_BLOCK")

function Component:init()
    self.colour = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

function Component:render()
    return Roact.createElement("Frame", {
        BackgroundColor3 = self.colour,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
    })
end

return Component
