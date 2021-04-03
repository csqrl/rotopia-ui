local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)
local ColourUtils = require(Root.Packages.ColourUtils)
local Llama = require(Root.Packages.Llama)

local Theme = require(Root.Theme)
local UICorner = require(Components.UICorner)
local UIPadding = require(Components.UIPadding)
local UIListLayout = require(Components.UIListLayout)

local e = Roact.createElement

local Component = Roact.Component:extend("Button")

Component.defaultProps = {
    transparency = 0, -- number
    borderWidth = 1, -- number
    padding = nil, -- number
    order = 1, -- number

    size = UDim2.fromScale(1, 1), -- UDim2
    autoSize = false, -- boolean
    position = UDim2.new(), -- UDim2

    label = "Button", -- string

    disabled = false, -- boolean
    variant = "default", -- "default" | "primary"

    springFrequency = 8, -- number
    springDamping = .5, -- number

    theme = {}, -- automatic

    borderRadius = nil, -- number
    textColour = nil, -- Color3

    sinkCursor = true, -- boolean
}

function Component:init()
    self.motor = Flipper.SingleMotor.new(0)

    self:setState({
        hover = false,
        press = false,

        emphasis = self.motor:getValue()
    })

    self.motor:onStep(function(value)
        self:setState({
            emphasis = value,
        })
    end)

    self.onInputBegan = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.Touch or uit.Name:match("MouseButton%d") then
            self:setState({ press = true })
        elseif uit == Enum.UserInputType.MouseMovement then
            self:setState({ hover = true })
        end
    end

    self.onInputEnded = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.Touch or uit.Name:match("MouseButton%d") then
            self:setState({ press = false })
        elseif uit == Enum.UserInputType.MouseMovement then
            self:setState({ hover = false, press = false })
        end
    end

    self.onClick = function(rbx)
        if not self.props.disabled and type(self.props.onClick) == "function" then
            self.props.onClick(rbx)
        end
    end

    self.onRightClick = function(rbx)
        if not self.props.disabled and type(self.props.onRightClick) == "function" then
            self.props.onRightClick(rbx)
        end
    end
end

function Component:didUpdate(prevProps, prevState)
    local props, state = self.props, self.state
    local theme = props.theme

    local newValue = self.motor:getValue()

    if prevProps.disabled ~= props.disabled then
        newValue = props.disabled and theme.action.disabled or 0
    elseif not props.disabled then
        if prevState.press ~= state.press then
            newValue = state.press and theme.action.press or 0
        elseif prevState.hover ~= state.hover then
            newValue = state.hover and theme.action.hover or 0
        end
    end

    if newValue ~= self.motor:getValue() then
        self.motor:setGoal(Flipper.Spring.new(newValue, {
            frequency = props.springFrequency,
            dampingRatio = props.springDamping,
        }))
    end
end

function Component:getConfig()
    local props, state = self.props, self.state
    local theme = props.theme

    local config = {}

    if props.variant == "default" then
        config.border = theme.palette.background.default
        config.background = theme.palette.background.default
        config.text = theme.getTextColour(config.background)
    elseif props.variant == "primary" then
        config.border = theme.palette.background.default
        config.background = theme.palette.primary
        config.text = theme.getTextColour(config.background)
    end

    config.border = ColourUtils.Emphasise(config.border, state.emphasis)
    config.background = ColourUtils.Emphasise(config.background, state.emphasis)
    config.text = props.textColour or theme.getTextColour(config.background)

    return config
end

function Component:render()
    local props = self.props

    local theme = props.theme
    local config = self:getConfig()

    return e("ImageButton", {
        Active = props.sinkCursor,
        AutoButtonColor = false,
        BackgroundColor3 = config.border,
        BackgroundTransparency = props.transparency,
        LayoutOrder = props.order,
        Position = props.position,
        Size = props.size,
        Image = "",

        [Roact.Event.InputBegan] = self.onInputBegan,
        [Roact.Event.InputEnded] = self.onInputEnded,

        [Roact.Event.Activated] = self.onClick,
        [Roact.Event.TouchLongPress] = self.onRightClick,
        [Roact.Event.MouseButton2Click] = self.onRightClick,
    }, {
        BorderRadius = e(UICorner, {
            radius = props.borderRadius,
        }),

        Padding = e(UIPadding, { props.borderWidth }),

        Container = e("Frame", {
            BackgroundColor3 = config.background,
            BackgroundTransparency = props.transparency,
            Size = UDim2.fromScale(1, 1),
        }, {
            BorderRadius = e(UICorner, {
                radius = props.borderRadius,
                offset = -props.borderWidth,
            }),

            Padding = e(UIPadding, {
                props.padding or theme.spacing,
                props.padding and props.padding * 2 or theme.spacing * 2
            }),

            Layout = e(UIListLayout, {
                direction = Enum.FillDirection.Horizontal,
                align = "middle",
            }),

            Label = props.label and e("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 20,
                Font = theme.font.semibold,
                Text = props.label,
                TextColor3 = config.text,
                TextSize = theme.fontSize,
                TextTransparency = props.transparency,
            }),

            -- TODO: Icon support
        }),
    })
end

return function(props)
    return Theme.withTheme(function(theme)
        return e(Component, Llama.Dictionary.merge(props, {
            theme = theme,
        }))
    end)
end
