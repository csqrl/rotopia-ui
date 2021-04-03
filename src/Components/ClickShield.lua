local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)

local e = Roact.createElement

local Component = Roact.Component:extend("ClickShield")

Component.defaultProps = {
    show = false,
    transitionOnMount = true,
    unmount = true,

    colour = Color3.fromHSV(0, 0, .1),
    transparency = .5,
    zindex = 0,

    dismissable = true,
    onDismiss = nil,

    springFrequency = 5,
    springDamping = 1,
}

function Component:init(props)
    self.motor = Flipper.SingleMotor.new((props.show and not props.transitionOnMount) and props.transparency or 1)

    self:setState({
        transparency = self.motor:getValue(),
    })

    self.motor:onStep(function(value)
        self:setState({ transparency = value })
    end)
end

function Component:didMount()
    local props = self.props

    if props.show and props.transitionOnMount then
        self.motor:setGoal(Flipper.Spring.new(props.transparency, {
            frequency = props.springFrequency,
            dampingRatio = props.springDamping,
        }))
    end
end

function Component:didUpdate(prevProps)
    local props = self.props

    if prevProps.show ~= props.show then
        local transparency = props.show and props.transparency or 1

        self.motor:setGoal(Flipper.Spring.new(transparency, {
            frequency = props.springFrequency,
            dampingRatio = props.springDamping,
        }))
    end
end

function Component:render()
    local props, state = self.props, self.state

    if props.unmount and state.transparency == 1 then
        return nil
    end

    local element = props.show and "ImageButton" or "Frame"

    local elementProps = {
        BackgroundTransparency = state.transparency,
        BackgroundColor3 = props.colour,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = props.zindex,
    }

    if props.show then
        elementProps.AutoButtonColor = false
        elementProps.Modal = true

        if props.dismissable and props.onDismiss then
            elementProps[Roact.Event.Activated] = props.onDismiss
            elementProps[Roact.Event.MouseButton2Click] = props.onDismiss
        end
    end

    return e(element, elementProps, props[Roact.Children])
end

return Component
