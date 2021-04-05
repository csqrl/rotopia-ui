local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local Theme = require(Root.Theme)
local Device = require(Root.Device)
local Navbar = require(Components.Navbar)
local UIPadding = require(Components.UIPadding)
local FluidFrame = require(Components.FluidFrame)

local PremiumAd = require(script.Parent.PremiumAd)

local Pages = require(script.Parent.Pages)

local e = Roact.createElement

local Component = Roact.Component:extend("ShopPageRootContainer")

function Component:render()
    return Theme.withTheme(function(theme)
        return Device.withDevice(function(device)
            local isLarge = device.landscapeHeight >= 480
            local isTiny = device.landscapeHeight < 380

            return Roact.createFragment({
                Padding = e(UIPadding, { not isLarge and 4, 16, 16 }),

                RootContainer = e(FluidFrame, {
                    spacing = isLarge and theme.spacing or 0,
                    fixedItems = isLarge and {
                        PremiumAd = e(PremiumAd, {
                            size = UDim2.new(0, 200, 1, 0),
                        }),
                    },
                }, {
                    BodyContainer = e(FluidFrame, {
                        spacing = theme.spacing,
                        direction = "y",
                        fixedSize = 36,

                        fixedItems = {
                            Padding = not isLarge and e(UIPadding, { 0, 0, 0, device.topbarInset - 16 }),

                            Navigation = e(Navbar, {
                                buttons = {
                                    { label = "Coins", path = "/shop" },
                                    { label = "Game Passes", path = "/shop/game-passes" },
                                    { label = "Codes", path = "/shop/redeem-code" },
                                }
                            }),
                        }
                    }, {
                        Contents = e(FluidFrame, {
                            spacing = isLarge and 0 or theme.spacing,
                            direction = (isLarge or isTiny) and "y" or "x",
                            fixedSize = isLarge and 0 or isTiny and 56 or 180,

                            fixedItems = not isLarge and {
                                PremiumAd = e(PremiumAd, {
                                    variant = isTiny and "banner",
                                }),
                            },
                        }, {
                            -- TODO: Store pages
                            CoinsPage = e(Pages.Coins),
                        }),
                    }),
                }),
            })
        end)
    end)
end

return Component
