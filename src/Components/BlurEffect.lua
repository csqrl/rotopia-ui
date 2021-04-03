local Lighting = game:GetService("Lighting")
local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)

local e = Roact.createElement

local Component = Roact.Component:extend("BlurEffect")

Component.defaultProps = {
    show = false,
    unmount = true,
    transitionOnMount = true,

    size = 24,

    springFrequency = 5,
    springDamping = 1,
}

function Component:init(props)
    self.motor = Flipper.SingleMotor.new((props.show and not props.transitionOnMount) and props.size or 0)

    self:setState({ size = self.motor:getValue() })

    self.motor:onStep(function(value)
        self:setState({
            size = value,
        })
    end)
end

function Component:didMount()
    local props = self.props

    if props.show and props.transitionOnMount then
        local size = props.show and props.size or 0

        self.motor:setGoal(Flipper.Spring.new(size, {
            frequency = props.springFrequency,
            dampingRatio = props.springDamping,
        }))
    end
end

function Component:didUpdate(prevProps)
    local props = self.props

    if prevProps.show ~= props.show then
        local size = props.show and props.size or 0

        self.motor:setGoal(Flipper.Spring.new(size, {
            frequency = props.springFrequency,
            dampingRatio = props.springDamping,
        }))
    end
end

function Component:render()
    local props, state = self.props, self.state

    if props.unmount and state.size <= 0 then
        return nil
    end

    return e(Roact.Portal, {
        target = Lighting,
    }, {
        RoactUIBlurEffect = e("BlurEffect", {
            Size = state.size,
        }),
    })
end

return Component
