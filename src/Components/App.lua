local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Theme = require(Root.Theme)

local LayerRouting = require(Components.AppLayers.Routing)

local ClientBaseLayer = require(Components.ClientAppLayers.ClientBaseLayer)
local ShopLayer = require(Components.ClientAppLayers.ShopLayer)

return function()
    return Roact.createElement(Theme.Provider, nil, {
        Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = true,
        }, {
            LayerRouting = Roact.createElement(LayerRouting, nil, {
                ClientBaseLayer = Roact.createElement(ClientBaseLayer),
                ShopLayer = Roact.createElement(ShopLayer),
            }),
        })
    })
end
