local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Roact)

local e = Roact.createElement

local defaultProps = {
    show = false,
    colour = Color3.fromHSV(0, 0, .1),
    transparency = 1,
    zindex = 0,

    dismissable = true,
    onDismiss = nil,
}

return function(props)
    props = Llama.Dictionary.merge(defaultProps, props)

    if props.transparency == 1 then
        return nil
    end

    local element = props.show and "ImageButton" or "Frame"

    local elementProps = {
        BackgroundTransparency = props.transparency,
        BackgroundColor3 = props.colour,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = props.zindex,
    }

    if props.show then
        elementProps.AutoButtonColor = false
        elementProps.Modal = true

        if props.show and props.dismissable and props.onDismiss then
            elementProps[Roact.Event.Activated] = props.onDismiss
            elementProps[Roact.Event.MouseButton2Click] = props.onDismiss
        end
    end

    return e(element, elementProps, props[Roact.Children])
end
