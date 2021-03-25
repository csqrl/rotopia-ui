local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)

local e = Roact.createElement

local AppLayerRoute = require(Components.AppLayers.Route)
local Slide = require(Components.Transition.Slide)
local ShieldOverlay = require(Components.Shield.ShieldOverlay)

local LayerContent = require(script.LayerContent)

return function()
    return AppLayerRoute("/shop", function(routing)
        return Roact.createFragment({
            ShieldOverlay = e(ShieldOverlay, {
                show = routing.inRangeLoose,
                blur = true,

                onDismiss = function()
                    routing.history:goBack()
                end
            }),

            Content = e(Slide, {
                show = routing.inRangeLoose,
                zindex = 10,
            }, {
                e(LayerContent),
            })
        })
    end)
end
