local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)
local ColourUtils = require(Root.Packages.ColourUtils)

local Theme = require(Root.Theme)
local UICorner = require(Components.UICorner)
local UIPadding = require(Components.UIPadding)
local FluidFrame = require(Components.FluidFrame)
local UIListLayout = require(Components.UIListLayout)
local Button = require(Components.Button)

local bind = require(Root.Util.Bind)
local e = Roact.createElement

local Component = Roact.Component:extend("PremiumAd")

Component.defaultProps = {
    transparency = 0,
    variant = "default", -- "default" | "banner"
    size = UDim2.fromScale(1, 1), -- UDim2
}

function Component:init()
    local motor = Flipper.SingleMotor.new(0)

    self:setState({
        transparency = 0,
        premium = LocalPlayer.MembershipType ~= Enum.MembershipType.None,
    })

    motor:onStep(function(value)
        self:setState({
            transparency = value,
        })
    end)

    self.onClick = function()
        if self.state.premium then
            return
        end

        MarketplaceService:PromptPremiumPurchase(LocalPlayer)
    end

    self.onInputBegan = function(_, input: InputObject)
        local uit = input.UserInputType

        if uit == Enum.UserInputType.MouseMovement and not self.state.premium then
            motor:setGoal(Flipper.Spring.new(.2))
        end
    end

    self.onInputEnded = bind(motor.setGoal, motor, Flipper.Spring.new(0))

    self.evtMembershipChange = LocalPlayer:GetPropertyChangedSignal("MembershipType"):Connect(function()
        self:setState({ premium = LocalPlayer.MembershipType ~= Enum.MembershipType.None })
    end)
end

function Component:willUnmount()
    self.evtMembershipChange:Disconnect()
end

function Component:render()
    local props, state = self.props, self.state
    local isBanner = props.variant == "banner"

    return Theme.withTheme(function(theme)
        return e("ImageButton", {
            AutoButtonColor = false,
            BackgroundTransparency = props.transparency,
            BackgroundColor3 = theme.palette.background.default,
            Size = props.size,
            Image = "",

            [Roact.Event.Activated] = self.onClick,

            [Roact.Event.InputBegan] = self.onInputBegan,
            [Roact.Event.InputEnded] = self.onInputEnded,
        }, {
            BorderRadius = e(UICorner),
            Padding = e(UIPadding, { 4 }),

            Container = e("ImageLabel", {
                BackgroundTransparency = props.transparency > 0 and props.transparency or state.transparency,
                BackgroundColor3 = ColourUtils.Hex.fromHex("#1a1a1a"),
                Size = UDim2.fromScale(1, 1),
                Image = isBanner and "" or "rbxassetid://6564300589",
                ImageColor3 = theme.common.white,
                ImageTransparency = props.transparency > 0 and props.transparency or .85,
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.fromOffset(100, 100),
            }, {
                BorderRadius = e(UICorner, { radius = theme.borderRadius - 2 }),
                Padding = e(UIPadding, { 8 }),

                Contents = e(FluidFrame, {
                    spacing = theme.spacing,
                    direction = isBanner and "x" or "y",
                    fixedSide = "end",

                    fixedItems = {
                        Button = not state.premium and e(Button, {
                            -- TODO: Localisation
                            label = isBanner and "Subscribe" or "Get Premium",

                            borderRadius = theme.borderRadius - 4,
                            autoSize = true,
                            size = UDim2.new(1, 0, isBanner and 1 or 0, isBanner and 0 or 36),

                            onClick = self.onClick,
                        }),
                    },
                }, {
                    Layout = e(UIListLayout, {
                        align = isBanner and "start" or "middle",
                        alignY = Enum.VerticalAlignment.Center,
                        direction = isBanner and Enum.FillDirection.Horizontal,
                    }),

                    PremiumIcon = e("ImageLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(isBanner and 32 or 72, isBanner and 32 or 72),
                        Image = isBanner and "rbxasset://textures/ui/PlayerList/PremiumIcon@2x.png"
                            or "rbxassetid://6564325002",
                        ImageTransparency = props.transparency,
                    }),

                    Contents = e("Frame", {
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, isBanner and -32 or 0, 0, 0),
                    }, {
                        Layout = e(UIListLayout, {
                            align = "middle",
                            spacing = UDim.new(0, isBanner and 0 or theme.spacing / 2),
                        }),

                        not isBanner and e("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.fromOffset(0, theme.spacing),
                        }),

                        -- TODO: Localisation
                        Title = e("TextLabel", {
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            LayoutOrder = 10,
                            Size = UDim2.fromScale(1, 0),
                            Font = theme.font.semibold,
                            Text = "Premium Power-ups",
                            TextColor3 = theme.common.white,
                            TextSize = theme.fontSize + (isBanner and 2 or 4),
                            TextWrapped = true,
                            TextXAlignment = isBanner and Enum.TextXAlignment.Left or nil,
                        }),

                        -- TODO: Localisation
                        Paragraph = e("TextLabel", {
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            LayoutOrder = 20,
                            Size = UDim2.fromScale(1, 0),
                            Font = theme.font.regular,
                            Text = "Get 10% more coins when you buy coins!",
                            TextColor3 = theme.common.white,
                            TextSize = theme.fontSize,
                            TextWrapped = true,
                            TextXAlignment = isBanner and Enum.TextXAlignment.Left or nil,
                        }),
                    }),
                }),
            })
        })
    end)
end

return Component
