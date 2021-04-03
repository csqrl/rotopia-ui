local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)
local Flipper = require(Root.Packages.Flipper)

local Number = require(Root.Util.Number)
local Transition = require(Components.Transition)
local Device = require(Root.Device)
local Theme = require(Root.Theme)

local bind = require(Root.Util.Bind)
local merge = Llama.Dictionary.merge
local e = Roact.createElement

local Component = Roact.Component:extend("CoinDisplay")

Component.defaultProps = {
    show = true,
    transparency = 0,
}

local inputBeganSpring = {
    frequency = 8,
    dampingRatio = .5,
}

local inputEndedSpring = {
    frequency = 5,
    dampingRatio = 1,
}

function Component:init()
    local motor = Flipper.SingleMotor.new(1)

    self:setState({
        coins = 8243179,
        size = 1,
    })

    self.onInputBegan = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.Touch or uit.Name:match("MouseButton%d") then
            motor:setGoal(Flipper.Spring.new(.9, inputBeganSpring))
        elseif uit == Enum.UserInputType.MouseMovement then
            motor:setGoal(Flipper.Spring.new(1.1, inputBeganSpring))
        end
    end

    self.onInputEnded = bind(motor.setGoal, motor, Flipper.Spring.new(1, inputEndedSpring))

    motor:onStep(function(value)
        self:setState({ size = value })
    end)
end

function Component:render()
    local props, state = self.props, self.state

    -- TODO: Localise abbreviations and commas
    local coinsValue = state.coins >= 1e6 and Number.abbr(state.coins)
        or state.coins >= 1e4 and Number.commas(state.coins)
        or tostring(state.coins)

    return Device.withDevice(function() --device)
        return Theme.withTheme(function(theme)
            local baseImageProps = {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.056, .92),
                Size = UDim2.fromScale(.887, .857),
                ImageColor3 = theme.palette.background.default,
                ImageTransparency = props.transparency,
            }

            return e(Transition.Slide, {
                direction = "custom",
                hideAnchor = Vector2.new(0, 1),
                hidePosition = UDim2.fromScale(1, 0),
                showAnchor = Vector2.new(1, 0),
                showPosition = UDim2.new(1, theme.spacing * -2, 0, theme.spacing),
                size = UDim2.fromOffset(142, 112),
                show = props.show,
            }, {
                BaseButton = e("ImageButton", {
                    AnchorPoint = Vector2.new(.5, .5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(.5, .5),
                    Size = UDim2.fromScale(state.size, state.size),
                    Image = "rbxassetid://6551803737",
                    ImageColor3 = theme.palette.background.default,
                    ImageTransparency = props.transparency,

                    [Roact.Event.Activated] = props.onClick,
                    [Roact.Event.MouseButton2Click] = props.onRightClick,
                    [Roact.Event.TouchLongPress] = props.onRightClick,

                    [Roact.Event.InputBegan] = self.onInputBegan,
                    [Roact.Event.InputEnded] = self.onInputEnded,
                }, {
                    Icon = e("ImageLabel", merge(baseImageProps, {
                        ZIndex = 20,
                        Image = "rbxassetid://6551820072",
                        ImageColor3 = Llama.None,
                    })),

                    IconBorder = e("ImageLabel", merge(baseImageProps, {
                        ZIndex = 10,
                        Image = "rbxassetid://6551817243",
                    })),

                    ValueBackground = e("ImageLabel", merge(baseImageProps, {
                        Image = "rbxassetid://6551810103",
                        ImageColor3 = theme.palette.primary,
                    })),

                    Value = e("TextLabel", {
                        AnchorPoint = Vector2.new(.5, 1),
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(.479, .777),
                        Rotation = 5,
                        Size = UDim2.fromScale(.65, .196),
                        ZIndex = 30,
                        Font = theme.font.semibold,
                        Text = coinsValue,
                        TextColor3 = theme.palette.text.light,
                        TextScaled = true,
                        TextTransparency = props.transparency,
                    }),
                }),
            })
        end)
    end)
end

return Component
