local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)
local ColourUtils = require(Root.Packages.ColourUtils)

local Theme = require(Root.Theme)
local Transition = require(Components.Transition)
local ClickShield = require(Components.ClickShield)
local BlurEffect = require(Components.BlurEffect)

local Window = require(script.Window)

local bind = require(Root.Util.Bind)
local e = Roact.createElement

return function()
    return e(Theme.Provider, {
        value = {
            palette = {
                primary = ColourUtils.Hex.fromHex("#F76F0E"),
            },
        },
    }, {
        Routing = e(RoactRouter.Route, {
            path = "/shop",
            exact = true,
            always = true,

            render = function(routing)
                local show = routing.inRangeLoose

                return e("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    ZIndex = 100,
                }, {
                    Fade = e(Transition.Fade, {
                        whenHidden = .5,
                        show = show,
                        unmount = false,
                    }, {
                        Window = e(Transition.Slide, {
                            show = show,
                        }, {
                            Content = e(Window),
                        }),
                    }),

                    BlurEffect = e(BlurEffect, {
                        show = show,
                    }),

                    ClickShield = e(ClickShield, {
                        onDismiss = bind(routing.history.goBack, routing.history),
                        show = show,
                    }),
                })
            end,
        })
    })
end
