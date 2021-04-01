local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Theme = require(Root.Theme)

return function(props)
    props = props or {}

    return Theme.withTheme(function(theme)
        local padding = props.Padding
            or props.padding
            or props.offset and UDim.new(0, theme.spacing * props.offset)
            or UDim.new(0, theme.spacing)

        local xAlignment = nil
        local yAlignment = nil

        if props.align then
            xAlignment = Enum.HorizontalAlignment[props.align == "start" and "Left" or props.align == "end" and "Right" or "Center"]
            yAlignment = Enum.VerticalAlignment[props.align == "start" and "Top" or props.align == "end" and "Bottom" or "Center"]
        end

        xAlignment = props.HorizontalAlignment or props.alignX or xAlignment
        yAlignment = props.VerticalAlignment or props.alignY or yAlignment

        return Roact.createElement("UIListLayout", {
            Padding = padding,
            FillDirection = props.direction or Enum.FillDirection.Vertical,
            HorizontalAlignment = xAlignment,
            VerticalAlignment = yAlignment,
            SortOrder = props.order or Enum.SortOrder.LayoutOrder,
        })
    end)
end
