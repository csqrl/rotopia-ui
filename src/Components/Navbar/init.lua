local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)
local Llama = require(Root.Packages.Llama)

local Theme = require(Root.Theme)
local UICorner = require(Components.UICorner)
local UIPadding = require(Components.UIPadding)
local FluidFrame = require(Components.FluidFrame)
local Button = require(Components.Button)

local bind = require(Root.Util.Bind)
local e = Roact.createElement

local Component = Roact.Component:extend("NavigationBar")

function Component:createButtons(theme, routing)
    local props = self.props

    if not props.buttons then
        return nil
    end

    return Llama.List.map(props.buttons, function(config, index)
        local active = routing.history._entries[routing.history._index].path == config.path

        return e(Button, {
            onClick = bind(routing.history[config.push and "push" or "replace"], routing.history, config.path),
            order = index * 10,
            borderRadius = theme.borderRadius - 2,
            borderWidth = 0,
            label = config.label,
            variant = active and "primary" or "default",
            textColour = active and theme.palette.background.default,
        })
    end)
end

function Component:render()
    local props = self.props

    return e(RoactRouter.Context.Consumer, {
        render = function(routing)
            return Theme.withTheme(function(theme)
                local buttons = self:createButtons(theme, routing)

                return e(FluidFrame, {
                    spacing = theme.spacing,
                    fixedSize = 36,
                    fixedSide = "end",

                    fixedItems = nil,
                }, {
                    Container = e("ImageButton", {
                        AutoButtonColor = false,
                        BackgroundColor3 = theme.palette.background.default,
                        BackgroundTransparency = props.transparency,
                        Size = UDim2.fromScale(1, 1),
                    }, {
                        Padding = e(UIPadding, { 2 }),
                        BorderRadius = e(UICorner),

                        Layout = e("UIGridLayout", {
                            CellPadding = UDim2.new(),
                            CellSize = UDim2.fromScale(1 / #props.buttons, 1),
                            FillDirection = Enum.FillDirection.Horizontal,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                        }),

                        Buttons = Roact.createFragment(buttons),
                    }),
                })
            end)
        end,
    })
end

return Component
