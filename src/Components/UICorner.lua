local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Theme = require(Root.Theme)

local max = math.max

return function(props)
    props = props or {}

    return Theme.withTheme(function(theme)
        local cornerRadius = props.CornerRadius
            or props.radius and UDim.new(0, props.radius)
            or UDim.new(0, theme.borderRadius)

        if props.offset then
            cornerRadius = cornerRadius + UDim.new(0, props.offset)
        end

        if type(props.radius) == "number" and props.radius <= 0 then
            cornerRadius = UDim.new(0, max(theme.borderRadius + props.radius, 0))
        end

        return Roact.createElement("UICorner", {
            CornerRadius = cornerRadius,
        })
    end)
end
