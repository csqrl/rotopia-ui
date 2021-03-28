local UserInputService = game:GetService("UserInputService")

local Root = script.Parent.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local ColourUtils = require(Root.Packages.ColourUtils)
local Theme = require(Root.Theme)

local BorderRadius = require(Components.Common.BorderRadius)
local UIListLayout = require(Components.Common.UIListLayout)
local UIPadding = require(Components.Common.UIPadding)

local e = Roact.createElement

local Component = Roact.Component:extend("ButtonContained")

Component.defaultProps = {
    colour = "default", -- "default" | "primary"

    text = "Button", -- string
    borderWidth = 2, -- number
    transparency = 0, --number
    size = UDim2.fromScale(1, 1), -- UDim2
    corners = "all", -- "all" | "left" | "right" | "none"

    disabled = false, -- boolean
}

function Component:init()
    self.previousKey = "default"

    self:setState({
        hover = false,
        press = false,
        focus = false,
    })

    self.onInputBegan = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.MouseMovement then
            self:setState({ hover = true })
        elseif uit == Enum.UserInputType.Touch or uit.Name:match("MouseButton%d") then
            self:setState({ press = true })
        end
    end

    self.onInputEnded = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.MouseMovement then
            self:setState({ hover = false, press = false })
        elseif uit == Enum.UserInputType.Touch or uit.Name:match("MouseButton%d") then
            if #UserInputService:GetMouseButtonsPressed() > 0 then
                return
            end

            self:setState({ press = false })
        end
    end
end

function Component:invokeCallback(prop: string)
    if type(self.props[prop]) ~= "function" or self.props.disabled then
        return nil
    end

    return self.props[prop]
end

function Component:getActiveKey()
    if self.props.disabled then
        return "disabled"
    elseif self.state.press then
        return "press"
    elseif self.state.focus then
        return "focus"
    elseif self.state.hover then
        return "hover"
    end

    return "default"
end

function Component:getBackgroundColour(theme)
    local colour = self.props.colour == "primary" and theme.palette.primary
        or theme.palette.background.default

    local presets = {
        default = colour,
        hover = ColourUtils.Emphasise(colour, theme.action.hover),
        focus = ColourUtils.Emphasise(colour, theme.action.hover),
        press = ColourUtils.Darken(colour, theme.action.press),
        disabled = ColourUtils.Darken(colour, theme.action.disabled),
    }

    return presets
end

function Component:getTextColour(theme)
    local background = self:getBackgroundColour(theme)
    local activeKey = self:getActiveKey()

    local colour = theme.getTextColour(background[activeKey])

    local presets = {
        default = colour,
        disabled = ColourUtils.Emphasise(colour, theme.action.disabled),
    }

    return presets
end

function Component:getBorderColour(theme)
    local colour = theme.palette.background.default

    local presets = {
        default = colour,
        focus = theme.palette.primary,
        disabled = ColourUtils.Darken(colour, theme.action.disabled),
    }

    return presets
end

function Component:render()
    local props = self.props

    return Theme.withTheme(function(theme)
        local activeKey = self:getActiveKey()

        local backgroundColour = self:getBackgroundColour(theme)
        local borderColour = self:getBorderColour(theme)
        local textColour = self:getTextColour(theme)

        local corners = {
            left = (props.corners == "all" or props.corners == "left") and theme.spacing or 0,
            right = (props.corners == "all" or props.corners == "right") and theme.spacing or 0,
        }

        return e("ImageButton", {
            Active = not props.disabled,
            AnchorPoint = props.anchor,
            BackgroundTransparency = 1,
            LayoutOrder = props.order,
            Position = props.position,
            Selectable = not props.disabled,
            Size = props.size,
            ZIndex = props.zindex,

            [Roact.Event.InputBegan] = self.onInputBegan,
            [Roact.Event.InputEnded] = self.onInputEnded,

            [Roact.Event.Activated] = self:invokeCallback("onClick"),
            [Roact.Event.TouchLongPress] = self:invokeCallback("onRightClick"),
            [Roact.Event.MouseButton2Click] = self:invokeCallback("onRightClick"),
        }, {
            Corners = e(BorderRadius, {
                transparency = props.transparency,
                colour = borderColour[activeKey] or borderColour.default,

                corners.left,
                corners.right,
            }),

            Container = e("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 10,
            }, {
                Padding = e(UIPadding, { props.borderWidth }),

                Corners = e(BorderRadius, {
                    transparency = props.transparency,
                    colour = backgroundColour[activeKey] or backgroundColour.default,

                    corners.left - props.borderWidth,
                    corners.right - props.borderWidth,
                }),

                Container = e("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = 10,
                }, {
                    Padding = e(UIPadding, { 8, props.text and 16 }),

                    Layout = e(UIListLayout, {
                        direction = Enum.FillDirection.Horizontal,
                    }),

                    Label = props.text and e("TextLabel", {
                        BackgroundTransparency = 1,
                        LayoutOrder = 10,
                        Size = UDim2.fromScale(1, 1),
                        Font = theme.font.semibold,
                        Text = props.text,
                        TextColor3 = textColour[activeKey] or textColour.default,
                        TextSize = theme.fontSize,
                        TextWrapped = true,
                    }),
                }),
            }),
        })
    end)
end

return Component
